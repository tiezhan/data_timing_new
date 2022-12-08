function BF_plx2mat(pfnames)
% 转化 .plx 文件为 .mat。 可同时转化多个。
% NeuroPhys 软件的多通道数据。
%
%function BF_plx2mat(pfnames)
%----Input 参数---------
% pfnames    : plx文件路径, 可省略
%
%----Output 参数---------
% pfmats     : mat文件路径，cell类型
%
%----Example-------------
%BF_plx2mat(); %弹出对话框

%% add path
% OR PLEASE ADD THE TOOL BOX OF "PLEXON LNC MATLAB OFFILINE FILES SDK"
path1 = which('BF_help.m');
ind = find(path1==filesep, 3, 'last');
path_LILAB = path1(1:ind);
addpath(fullfile(path_LILAB, 'CuiYT', 'PLXrecoder', 'Plx_Cite'));

%% load file
if ~exist('pfnames', 'var')
    pfnames = uigetfilemult('*.plx');
end
pfmats = cell(size(pfnames));
for i=1:length(pfnames);
    pfmats{i} = trans(pfnames{i});
end

%%
function pfnew = trans(pf)
[~, f, ext] = fileparts(pf);
pfnew = regexprep(pf, '\.plx$', '_plx.mat');
if BF_fileDateCmp(pf, pfnew)<0
    fprintf('> %s%s\t<Existed(skip)>\n\n', f, '_plx.mat');
    return;
end

convert_plx2mat(pf);

fprintf('-------------File-Info--------------\n');
fprintf('> %s%s\n', f, ext);

save(pfnew, 'data', 'Fs');


%% 引用
function convert_plx2mat(inputFilename)

path = fileparts(inputFilename);
if isempty(path); path = '.'; end

saveWaveforms = true;
separateFiles = false;
saveUnsorted = true;
% fprintf('\nPlease select a mode:\n');
% fprintf(' (1) Easy mode - saves all data, including waveforms and unsorted spikes, to a single file\n');
% fprintf(' (2) Advanced mode - will prompt you to allow selective saving of data, and/or saving to multiple files\n');
% answer = input('Type selection, or press ENTER to accept default (1): ');
answer = 1;
if ~isempty(answer)
    if answer == 2
        % Now prompt user for a few options
        answer = input('\nSave spike waveforms (in addition to timestamps)? (1 yes, 0 no, or press ENTER to accept default = YES): ');
        % Makes sure argument is 0 or 1. If not, or if it is empty, then
        % substitute default value
        saveWaveforms = parseInput(answer, true);

        answer = input('Save each channel to its own file? (1 yes, 0 no, or press ENTER to accept default = NO): ');
        separateFiles = parseInput(answer, false);

        answer = input('Save unsorted units as well as sorted (1 yes, 0 no, or press ENTER to accept default = YES): ');
        saveUnsorted = parseInput(answer, true);
        
        fprintf('\n');
    end
end

useSubfolder = separateFiles;

x = length(inputFilename);
if x <= 4
    % Not a PLX file (filename too short)
    return;
end

if (x >= 5) && ~strcmp(inputFilename(x-3:x), '.plx')
    % Not a PLX file (wrong extension)
    return;
end

% Strip off .plx extension to get base filename. Will append to
% the base to generate output .mat filenames
[~, filename_without_extension, ~] = fileparts(inputFilename);

if useSubfolder
    subfolder = [path, '\', filename_without_extension];
    if ~exist(subfolder, 'dir')
        % If it doesn't already exist,
        % create subfolder in which to place .MAT files
        mkdir(subfolder);
    end
else
    subfolder = '.';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%   Open file and display header info          %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
[InputFileName, Version, SpikeSamplingFreqHz, Comment, Trodalness, PointsPerWaveform, PointsPerWaveformPreThreshold, ...
    SpikeChannelMaxRangeMillivolts, SpikeChannelResolutionBits, ContinuousChannelMaxRangeMillivolts, ContinuousChannelResolutionBits, ...
    DurationSeconds, RecordingDateTime] = plx_information(inputFilename);

%disp(' ');
%disp(['Sampling frequency : ' num2str(SamplingFreqHz)]);
%disp(['Date/Time at start of recording : ' DateTimeString]);
%disp(['File Duration (seconds): ' num2str(DurationSeconds)]);
%disp(['Num points in each spike waveform : ' num2str(PointsPerWaveform)]);
%disp(['Num points in each spike waveform prior to threshold crossing : ' num2str(PointsPerWaveformPreThreshold)]);

% Save header info
if separateFiles
    % If saving into separate files, then append "_info.mat" to original
    % filename.
    filename2 = [subfolder ,'\', filename_without_extension, '_Basic_Info.mat'];
else
    filename2 = [path ,'\', filename_without_extension, '_plx.mat']; %陈昕枫修改
end

save(filename2, 'InputFileName', 'SpikeSamplingFreqHz', 'Comment', 'RecordingDateTime', 'DurationSeconds', 'PointsPerWaveformPreThreshold', 'Trodalness');

% get counts of # of events for spike, waveform, event, and continuous data channels
[spike_counts, waveform_counts, event_counts, continuous_sample_counts] = plx_info(InputFileName,1);

% get spike channel names
[n1, spike_channel_names] = plx_chan_names(InputFileName);
% Neurophys will always make consecutive channel numbers (1, 2, 3 ...) but
% plx file format allows arbitrary channel numbers and channel order. To
% make sure this works with any plx file, we check the channel map using
% plx_chanmap function.
[n1, spike_channel_IDs] = plx_chanmap(InputFileName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                %
%   Scan all spike channels      %
%                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numTotalSpikes = sum(sum(spike_counts));
numSortedSpikes = sum(spike_counts(2:end, :));
if numTotalSpikes == 0
    fprintf('File does not contain neural spikes\n');
else
    if numSortedSpikes == 0
        fprintf('WARNING: all spikes in this file are UNSORTED. ');
        if ~saveUnsorted
            fprintf('Would you like to turn on saving of unsorted spikes?\n');
            answer = input('[1 = yes, 0 = no, or press ENTER for default = YES]');
            saveUnsorted = parseInput(answer, true);
        else
            fprintf('\n');
        end
    end
end

highestSpikeChannel = 0;
highestSortUnit = 0;
for x = 1:n1

    % plx_chan_names function returns null-padded string names.
    % The following line replaces nulls with white space to avoid problems
    % later with graph axes.
    spike_channel_names(spike_channel_names == 0) = 32;
    
    % Display names of all channels that are non-empty.
    if sum(spike_counts(:,x+1)) > 0
        % The first index in array is sort unit, with 1 being the unsorted
        % units, and 2, 3, etc. being sorted units "a", "b", etc.
        %
        % The second index is the channel number. Strangely, Plexon 
        % requires x+1, not x. Very weird, and very unnecessary.
        fprintf('Found data in spike channel index %d, channel ID %d, name %s, with %d spikes\n', x - 1, spike_channel_IDs(x), spike_channel_names(x,:), spike_counts(1,x+1));
        highestSpikeChannel = x;
        u = max(find(spike_counts(:,x+1) > 0));
        if u > highestSortUnit
            highestSortUnit = u;
        end
    end
end

if highestSortUnit < 5
    % This causes cell array to have exactly 11 columns most of the time.
    highestSortUnit = 5;
end

% Get continuous channel wire #. Neurophys will always make sequential wire numbers
% (1, 2, 3 ...) but PLX file formats allow non-consecutive wires. So to
% make sure this will work with ANY plx file, we check the channel map
% using plx_ad_chanmap function.
[n2, continuous_channel_IDs] = plx_ad_chanmap(InputFileName);
% get text channel names
[n2, continuous_channames] = plx_adchan_names(InputFileName);
% get sample rates for each channel
[n2, continuous_sample_rates] = plx_adchan_freqs(InputFileName);
   
% plx_adchan_names function returns null-padded string names.
% We replace nulls with white space to avoid problems later, e.g. when
% names are used as graph axis/legend/title text.
continuous_channames(continuous_channames == 0) = 32;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          %
%   Scan all continuous channels           %
%                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
highestContinuousChannel = 0;
firstVideoChannel = 0;
highestVideoChannel = -1;   % Must be less than firstVideoChannel, so that for loop won't execute if no video channels found
for x = 1:n2
    % Display names of all non-empty continuous channel
    if continuous_sample_counts(x) > 0
        channame = continuous_channames(x,:);
        if x > 64 && length(channame) > 5 && strcmpi(channame(1:5), 'video')
            % Video tracking channels start with index 65 (one-based)
            fprintf('Found video tracking data, channel index %d, name %s, sample rate %d, with %d points\n', x - 1, strtrim(channame), continuous_sample_rates(x), continuous_sample_counts(x));
            if firstVideoChannel < 1
                firstVideoChannel = x;
            end
            highestVideoChannel = x;
        elseif firstVideoChannel < 1
            % Once we find a videotracking channel, stop looking for normal
            % continuous ephys channels
            fprintf('Found data for continuous channel index %d, channel ID %d, name %s, sample frequency %d, with %d points\n', x - 1, continuous_channel_IDs(x), strtrim(continuous_channames(x,:)), continuous_sample_rates(x), continuous_sample_counts(x));
            highestContinuousChannel = x;
        end
    end
end

% Get event map. Normally event ID are sequential (1, 2, 3 ...)
% but there could be non-consecutive events, or map could start at 0 instead of 1.
% Wire number is used to retrieve raw data.
[n3, event_channel_ID] = plx_event_chanmap(InputFileName);
% get event channel names
[n3, event_channames] = plx_event_names(InputFileName);
firstDataGapChannel = 0;
lastDataGapChannel = -1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%  Scan all event channels                     %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
highestEventChannel = 0;
for x = 1:n3
    % plx_event_names function returns null-padded string names.
    % We replace nulls with white space to avoid problems later, e.g. when
    % names are used as graph axis/legend/title text.
    event_channames(event_channames == 0) = 32;

    % Display names of all non-empty continuous channel
    if event_counts(x) > 0
        channame = strtrim(event_channames(x,:));
        if x >= 250
            if length(channame) > 7 && strcmpi(channame(1:7), 'datagap')
                if firstDataGapChannel < 1
                    firstDataGapChannel = x;
                end
                lastDataGapChannel = x;
            end
        else
            fprintf('Found data for event index %d, ID %d, name: %s, with %d event counts\n', x, event_channel_ID(x), strtrim(event_channames(x,:)), event_counts(x));
            highestEventChannel = x;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%  Save spike timestamps, waveforms            %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~separateFiles && highestSortUnit > 0
    if saveWaveforms
        SpikeData = cell(highestSpikeChannel + 1, 1 + highestSortUnit * 2);
    else
        SpikeData = cell(highestSpikeChannel + 1, 1 + highestSortUnit);
    end
    SpikeData{1,1} = 'Name';
    SpikeData{1,2} = 'Timestamps unsorted';
    for y = 2:highestSortUnit
        SpikeData{1,1+y} = ['Unit ', num2str(y-1)];
        if saveWaveforms
            SpikeData{1,1+highestSortUnit+y} = ['Unit ', num2str(y-1)];
        end
    end
    if saveWaveforms
        SpikeData{1,2 + highestSortUnit} = 'Waveforms unsorted';
    end
else
    SpikeData = [];
end
for x = 1:highestSpikeChannel

    ChannelID = spike_channel_IDs(x);
    unitsInChannel = spike_counts(:,x+1);
    
    ChannelName = spike_channel_names(x,:);
    ChannelName = strtrim(ChannelName);   % Trim trailing nulls/spaces

    if ~separateFiles
        SpikeData{x + 1, 1} = ChannelName;
    end

    for y = 1:length(unitsInChannel)
        
        if unitsInChannel(y) == 0
            % No units in this channel
            continue;
        end
        
        if y == 1 && ~saveUnsorted
            % Only have unsorted units, and we are not saving those
            continue;
        end
    
        % get some timestamps for first available channel
        [num_spikes, spike_timestamps] = plx_ts(InputFileName, ChannelID, y - 1);
    
        fprintf('Saving spike data from channel "%s", sort unit %d\n', ChannelName, y - 1);

        if separateFiles
            filename3 = [subfolder ,'\', filename_without_extension, '_', ChannelName, '_unit', num2str(y - 1), '.mat'];
        else
            % save to cell array
            SpikeData{x + 1, 1 + y} = spike_timestamps;
        end
        
        if ~saveWaveforms
            if separateFiles
                save(filename3, 'ChannelName', 'spike_timestamps');
            end
            continue
        end
        
        [num_waveforms, numpoints_waveform, waveform_timestamps, spike_waveforms] = plx_waves(InputFileName, ChannelID, y - 1);
        if num_waveforms > 0
        
            % Get channel gains so we can compute voltages
            [n,spike_channel_gains] = plx_chan_gains(InputFileName);

            % Calculate scaling factors for converting raw values to voltages
            % The following is the # of samples between lowest and highest voltage.
            % Typically 2^16 = 65536.
            sample_range = 2 ^ SpikeChannelResolutionBits;
            % The following is the difference between highest and lowest
            % possibleex
            % voltage. Note the multiplication by 2, because this range is
            % two-sided, i.e. includes negative numbers as well.
            voltage_range = 2 * SpikeChannelMaxRangeMillivolts / 1000 / spike_channel_gains(x);

            % Convert from raw binary values to voltages
            spike_waveforms = spike_waveforms * voltage_range / sample_range;

            if separateFiles
                save(filename3, 'ChannelName', 'spike_timestamps', 'spike_waveforms');
            else
                SpikeData{x + 1, 1 + highestSortUnit + y} = spike_waveforms;
            end

        else
        
            fprintf('    Warning: No waveforms in this spike channel\n');

        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%  Save EEG/continuous channels                %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get channel gains, so we can convert raw to voltage
[n,continuous_channel_gains] = plx_adchan_gains(InputFileName);
if ~separateFiles
    if highestContinuousChannel > 0
        ContinuousData = cell(highestContinuousChannel + 1, 4);
        ContinuousData{1,1} = 'Name';
        ContinuousData{1,2} = 'Sample Rate (Hz)';
        ContinuousData{1,3} = 'Timestamps';
        ContinuousData{1,4} = 'Voltages';
    else
        ContinuousData = [];
    end
end

for x = 1:highestContinuousChannel
    
    ChannelName = strtrim(continuous_channames(x,:));
    if ~separateFiles
        ContinuousData{x + 1, 1} = ChannelName;
    end
    
    if continuous_sample_counts(x) == 0
        % No data in this channel
        continue;
    end

    ChannelID = continuous_channel_IDs(x);
    
    % Calculate scaling factors for converting raw values to voltages
    % The following is the # of samples between lowest and highest voltage.
    % Typically 2^16 = 65536.
    sample_range = 2 ^ ContinuousChannelResolutionBits;
    % The following is the difference between highest and lowest possible
    % voltage. Note the multiplication by 2, because this range is
    % two-sided, i.e. includes negative numbers as well.
    voltage_range = 2 * ContinuousChannelMaxRangeMillivolts / 1000 / continuous_channel_gains(x);
       
    % Read all data. If file is very large, this could suck up a lot of
    % memory.

    % plx_ad_span retrieves all data into one large vector. If there are
    % any acquisition gaps, they will be padded with zeros. Unfortunately,
    % there is one big problem: it won't tell you where the first sample
    % starts. You can't assume it is at zero - there often is a gap before
    % the first sample.
    % Another disadvantage of plx_ad_span is that you have to already know the
    % final timestamp in order to get all data (it is the last argument passed).
%    [continuous_sample_freq, total_num_datapoints, raw_ad_values] = plx_ad_span(InputFileName, ChannelID, 1, continuous_sample_counts(x));

    % So instead we use plx_ad() which retrieves all data, and tells
    % you where each data block starts. But it may retrieve data in
    % several chunks. The number of chunks is somewhat machine-dependent,
    % and there may be gaps between them.
    
    [continuous_sample_freq, total_num_datapoints, timestamps, fragment_lengths, raw_ad_values] = plx_ad(InputFileName, ChannelID);

    % We have a problem. NeuroPhys always makes the continuous sample rate
    % an exact divisor of the spike sample rate. But this value might not
    % be an integer, and the PLX format can only store sample rates as
    % integers. So we use heuristics to try to recover the original exact
    % sample rate.
    ratio = SpikeSamplingFreqHz / continuous_sample_freq;
    ratio = round(ratio);
    continuous_sample_freq = SpikeSamplingFreqHz / ratio;

    time_values = zeros(length(raw_ad_values),1);
    index = 1;
    for y = 1:length(timestamps)
        len = fragment_lengths(y);
        ts = 0:(len-1);
        time_values(index + ts) = timestamps(y) + ts'/continuous_sample_freq;
        index = index + len;
    end
    
    fprintf('Saving continuous data from channel "%s"\n', ChannelName);

    % We could have read data using plx_ad_v, which does voltage conversion
    % for us. But it rounds off to the nearest millivolt. Not cool. So we use plx_ad,
    % and do the conversion ourselves.

    % Convert raw values to voltages
    continuous_voltages = raw_ad_values / sample_range * voltage_range;

    if separateFiles
        filename4 = [subfolder ,'\', filename_without_extension, '_', ChannelName, '.mat'];
        save(filename4, 'ChannelID', 'ChannelName', 'continuous_sample_freq', 'time_values', 'continuous_voltages');
    else
        ContinuousData{x + 1, 2} = continuous_sample_freq;
        ContinuousData{x + 1, 3} = time_values;
        ContinuousData{x + 1, 4} = continuous_voltages;
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%  Save video tracking                         %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~separateFiles
    if firstVideoChannel > 0
        VideoTrackingData = cell(highestVideoChannel - firstVideoChannel + 2, 1);
        VideoTrackingData{1, 1} = 'Name';
        VideoTrackingData{1, 2} = 'Frame Rate (Hz)';
        VideoTrackingData{1, 3} = 'Timestamps';
        VideoTrackingData{1, 4} = 'Values';
    else
        VideoTrackingData = [];
    end
end

for x = firstVideoChannel:highestVideoChannel
    
    ChannelName = strtrim(continuous_channames(x,:));

    if ~separateFiles
        VideoTrackingData{x + 2 - firstVideoChannel, 1} = ChannelName;
    end

    if continuous_sample_counts(x) == 0
        % No data in this channel
        continue;
    end

    ChannelID = continuous_channel_IDs(x);

    % Retrieve data, possibly in multiple chunks
    [continuous_sample_freq, total_num_datapoints, timestamps, fragment_lengths, raw_ad_values] = plx_ad(InputFileName, ChannelID);

    ratio = SpikeSamplingFreqHz / continuous_sample_freq;
    ratio = round(ratio);
    continuous_sample_freq = SpikeSamplingFreqHz / ratio;

    % NeuroPhys always makes the continuous sample rate
    % an exact divisor of the spike sample rate. But this value might not
    % be an integer, so we use heuristics to try to recover the original exact
    % sample rate.
    ratio = SpikeSamplingFreqHz / continuous_sample_freq;
    ratio = round(ratio);
    continuous_sample_freq = SpikeSamplingFreqHz / ratio;

    time_values = zeros(total_num_datapoints,1);
    index = 1;
    for y = 1:length(timestamps)
        len = fragment_lengths(y);
        ts = 0:(len-1);
        time_values(index + ts) = timestamps(y) + ts'/continuous_sample_freq;
        index = index + len;
    end

    fprintf('Saving video tracking data from channel "%s"\n', ChannelName);

    if separateFiles
        filename4 = [subfolder ,'\', filename_without_extension, '_', ChannelName, '.mat'];
        save(filename4, 'ChannelID', 'ChannelName', 'continuous_sample_freq', 'time_values', 'raw_ad_values');
    else
        VideoTrackingData{x + 2 - firstVideoChannel, 2} = continuous_sample_freq;
        VideoTrackingData{x + 2 - firstVideoChannel, 3} = time_values;
        VideoTrackingData{x + 2 - firstVideoChannel, 4} = raw_ad_values;
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%  Save event timestamps                       %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~separateFiles
    if highestEventChannel > 0
        EventData = cell(highestEventChannel + 1,2);
        EventData{1,1} = 'Name';
        EventData{1,2} = 'Timestamps';
    else
        EventData = [];
    end
end
for x = 1:highestEventChannel
    EventName = strtrim(event_channames(x,:));
    if ~separateFiles
        EventData{x + 1,1} = EventName;
    end
                
    if event_counts(x) == 0
        continue;
    end
    
    ChannelID = event_channel_ID(x);
    [num_events, event_timestamps] = plx_event_ts(InputFileName, ChannelID);
    
    fprintf('Saving event ID %d, named "%s"\n', ChannelID, EventName);

    if separateFiles
        filename4 = [subfolder ,'\', filename_without_extension, '_Event_', EventName, '.mat'];
        save(filename4, 'ChannelID', 'EventName', 'event_timestamps');
    else
        EventData{x + 1,2} = event_timestamps;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%  Save data gap info, if present              %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~separateFiles
    if lastDataGapChannel > 0
        DataGaps = cell(lastDataGapChannel - firstDataGapChannel + 2, 2);
        DataGaps{1,1} = 'Name';
        DataGaps{1,2} = 'Timestamps';
    end
end
for x = firstDataGapChannel:lastDataGapChannel
    ChannelID = event_channel_ID(x);
    if event_counts(x) == 0
        continue;
    end
    
    % get some timestamps for first available channel
    [num_events, event_timestamps] = plx_event_ts(InputFileName, ChannelID);
    
    EventName = strtrim(event_channames(x,:));
    
    fprintf('Saving event ID %d, named "%s"\n', ChannelID, EventName);

    if separateFiles
        filename4 = [subfolder ,'\', filename_without_extension, '_event_', EventName, '.mat'];
        save(filename4, 'ChannelID', 'EventName', 'event_timestamps');
    else
        DataGaps{x - firstDataGapChannel + 2,1} = EventName;
        DataGaps{x - firstDataGapChannel + 2,2} = event_timestamps;
    end
end

% Close plx file and do final save if needed
plx_close('');
if ~separateFiles
    save(filename2, 'SpikeData', 'ContinuousData', 'EventData', 'VideoTrackingData', '-append');
    if exist('DataGaps', 'var')
        save(filename2,  'DataGaps', '-append');
    else
    end
    fprintf('\nSaved all data to file %s\n', filename2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%  Auxiliary function to help parse user input %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function answer = parseInput(input, default)

if ~isempty(input)
    if input == 1
        answer = true;
    elseif input == 0
        answer = false;
    else
        fprintf('Unrecognized option, reverting to default\n');
        answer = default;
    end
else
    answer = default;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              %
%  Plexon function calls                       %
%                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreTresh, SpikePeakV, SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information(filename)
% plx_information(filename) -- read extended header infromation from a .plx file
%
% [OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreTresh, SpikePeakV, SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information(filename)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%
% OUTPUT:
% OpenedFileName    - returns the filename (useful if empty string is passed as filename)
% Version -  version code of the plx file format
% Freq -  timestamp frequency for waveform digitization
% Comment - user-entered comment
% Trodalness - 0,1 = single electrode, 2 = stereotrode, 4 = tetrode
% Number of Points Per Wave - number of samples in a spike waveform
% Pre Threshold Points - the sample where the threshold was crossed
% SpikePeakV - peak voltage in mV of the final spike A/D converter
% SpikeADResBits - resolution of the spike A/D converter (usually 12 bits)
% SlowPeakV - peak voltage of mV of the final analog A/D converter
% SlowADResBits - resolution of the analog A/D converter (usually 12 bits)
% Duration - the duration of the file in seconds
% DateTime - date and time string for the file

if nargin < 1
    error 'Expected 1 input argument';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreTresh, SpikePeakV, SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = mexPlex(13, filename);

function  [tscounts, wfcounts, evcounts, contcounts] = plx_info(filename, fullread)
% plx_info(filename, fullread) -- read and display .plx file info
%
% [tscounts, wfcounts, evcounts, contcounts] = plx_info(filename, fullread)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%   fullread - if 0, reads only the file header
%              if 1, reads the entire file
%
% OUTPUT:
%   tscounts - 2-dimensional array of timestamp counts for each unit
%      tscounts(i, j) is the number of timestamps for channel j-1, unit i
%                                (see comment below)
%   wfcounts - 2-dimensional array of waveform counts for each unit
%     wfcounts(i, j) is the number of waveforms for channel j-1, unit i
%                                (see comment below)
%   evcounts - 1-dimensional array of external event counts
%     evcounts(i) is the number of events for event channel i
%
%   contcounts - 1-dimensional array of sample counts for continuous channels
%     contcounts(i) is the number of continuous for slow channel i-1
%
% Additional notes by TJ:
% Note that for tscounts, wfcounts, the unit,channel indices i,j are off by one. 
% That is, for channels, the count for channel n is at index n+1, and for units,
%  index 1 is unsorted, 2 = unit a, 3 = unit b, etc
% The dimensions of the tscounts and wfcounts arrays are
%   (NChan+1) x (MaxUnits+1)
% where NChan is the number of spike channel headers in the plx file, and
% MaxUnits is 4 if fullread is 0, or 26 if fullread is 1. This is because
% the header of a .plx file can only accomodate 4 units, but doing a
% fullread on the file may show that there are actually up to 26 units
% present in the file. Likewise, NChan will have a maximum of 128 channels
% if fullread is 0.
% The dimension of the evcounts and contcounts arrays is the number of event
% and continuous (slow) channels. 
% The counts for slow channel 0 is at contcounts(1)

if nargin < 2
    error 'Expected 2 input arguments';
end

if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[tscounts, wfcounts, evcounts, contcounts] = mexPlex(4, filename, fullread);


function [n,names] = plx_chan_names(filename)
% plx_chan_names(filename): Read name for each spike channel from a .plx file
%
% [n,names] = plx_chan_names(filename)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%
% OUTPUT:
%   names - array of channel name strings
%   n - number of channels

if nargin < 1
    error 'Expected 1 input argument';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n,names] = mexPlex(14, filename);


function  [n,dspchans] = plx_chanmap(filename)
% plx_chanmap(filename) -- return map of raw DSP channel numbers for each channel
%
% [n,dspchans] = plx_chanmap(filename)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%
% OUTPUT:
%   n - number of spike channels
%   dspchans - 1 x n array of DSP channel numbers
%
% Normally, there is one channel entry in the .plx for for each raw DSP channel,
% so the mapping is trivial dspchans[i] = i.
% However, for certain .plx files saved in some ways from OFS (notably after
% loading data files from other vendors), the mapping can be more complex.
% E.g. there may be only 2 non-empty channels in a .plx file, but those channels
% correspond to raw DSP channel numbers 7 and 34. So in this case NChans = 2, 
% and dspchans[1] = 7, dspchans[2] = 34.
% The plx_ routines that return arrays always return arrays of size NChans. However,
% routines that take channels numbers as arguments always expect the raw DSP 
% channel number.  So in the above example, to get the timestamps from unit 4 on 
% the second channel, use
%   [n,ts] = plx_ts(filename, dspchans[2], 4 );

if nargin < 1
    error 'Expected 1 input argument';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n,dspchans] = mexPlex(26, filename);


function  [n,adchans] = plx_ad_chanmap(filename)
% plx_ad_chanmap(filename) -- return map of raw continuous channel numbers for each channel
%
% [n,adchans] = plx_ad_chanmap(filename)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%
% OUTPUT:
%   n - number of continuous channels
%   adchans - 1 x n array of continuous channel numbers
%
% Normally, there is one channel entry in the .plx for for each raw continuous channel,
% so the mapping is trivial adchans[i] = i-1 (because continuous channels start at 0).
% However, for certain .plx files saved in some ways from OFS (notably after
% loading data files from other vendors), the mapping can be more complex.
% E.g. there may be only 2 non-empty channels in a .plx file, but those channels
% correspond to raw channel numbers 7 and 34. So in this case NChans = 2, 
% and adchans[1] = 7, adchans[2] = 34.
% The plx_ routines that return arrays always return arrays of size NChans. However,
% routines that take channels numbers as arguments always expect the raw  
% channel number.  So in the above example, to get the data from  
% the second channel, use
%   [adfreq, n, ts, fn, ad] = plx_ad(filename, adchans[2])

if nargin < 1
    error 'Expected 1 input argument';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n,adchans] = mexPlex(27,filename);


function [n,names] = plx_adchan_names(filename)
% plx_adchan_names(filename): Read name for each a/d channel from a .plx file
%
% [n,names] = plx_adchan_names(filename)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%
% OUTPUT:
%   names - array of a/d channel name strings
%   n - number of channels

if nargin < 1
    error 'Expected 1 input argument';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n,names] = mexPlex(15, filename);


function [n,freqs] = plx_adchan_freqs(filename)
% plx_adchan_freq(filename): Read the per-channel frequencies for analog channels from a .plx file
%
% [n,freqs] = plx_adchan_freq(filename)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%
% OUTPUT:
%   freqs - array of frequencies
%   n - number of channels

if nargin < 1
    error 'Expected 1 input argument';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n,freqs] = mexPlex(12, filename);

function  [n, evchans] = plx_event_chanmap(filename)
% plx_event_chanmap(filename) -- return map of raw event numbers for each channel
%
% [n, evchans] = plx_event_chanmap(filename)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%
% OUTPUT:
%   n - number of event channels
%   evchans - 1 x n array of event channel numbers
%
% In a .plx file there are only a few event channel headers, so the raw
% event channel numbers are NOT the same as the index in the event channel
% array.
% E.g. there may be only 2 event channels in a .plx file header, but those channels
% correspond to raw event channel numbers 7 and 34. So in this case NChans = 2, 
% and evchans[1] = 7, evchans[2] = 34.
% The plx_ routines that return arrays always return arrays of size NChans. However,
% routines that take channels numbers as arguments always expect the raw  
% channel number.  So in the above example, to get the event timestamps from  
% the second channel, use
%   [n, ts, sv] = plx_event_ts(filename, evchans[2])

if nargin < 1
    error 'Expected 1 input argument';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n, evchans] = mexPlex(28, filename);


function [n,names] = plx_event_names(filename)
% plx_event_names(filename): Read name for each event type from a .plx file
%
% [n, names] = plx_event_names(filename)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%
% OUTPUT:
%   names - array of event name strings
%   n - number of channels

if nargin < 1
    error 'Expected 1 input argument';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n, names] = mexPlex(16, filename);


function [n, ts] = plx_ts(filename, channel, unit)
% plx_ts(filename, channel, unit): Read spike timestamps from a .plx file
%
% [n, ts] = plx_ts(filename, channel, unit)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%   channel - 1-based channel number
%   unit  - unit number (0- unsorted, 1-4 units a-d)
%
% OUTPUT:
%   n - number of timestamps
%   ts - array of timestamps (in seconds)

if nargin < 3
    error 'Expected 3 input arguments';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n, ts] = mexPlex(5, filename, channel, unit);


function [n,gains] = plx_chan_gains(filename)
% plx_chan_gains(filename): Read channel gains from .plx file
%
% [gains] = plx_chan_gains(filename)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%
% OUTPUT:
%  gains - array of total gains
%   n - number of channels

if nargin < 1
    error 'Expected 1 input argument';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n,gains] = mexPlex(8, filename);


function [n, npw, ts, wave] = plx_waves(filename, channel, unit)
% plx_waves(filename, channel, unit): Read waveform data from a .plx file
%
% [n, npw, ts, wave] = plx_waves(filename, channel, unit)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%   channel - 1-based channel number
%   unit  - unit number (0- unsorted, 1-4 units a-d)
%
% OUTPUT:
%   n - number of waveforms
%   npw - number of points in each waveform
%   ts - array of timestamps (in seconds) 
%   wave - array of waveforms [npw, n], raw a/d values

if nargin < 3
    error 'Expected 3 input arguments';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n, npw, ts, wave] = mexPlex(6, filename, channel, unit);


function [n,gains] = plx_adchan_gains(filename)
% plx_adchan_gains(filename): Read analog channel gains from .plx file
%
% [n,gains] = plx_adchan_gains(filename)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%
% OUTPUT:
%  gains - array of total gains
%  n - number of channels

if nargin < 1
    error 'Expected 1 input argument';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n,gains] = mexPlex(11, filename);


function [adfreq, n, ad] = plx_ad_span(filename, channel, startCount, endCount)
% plx_ad_span(filename, channel): Read a span of a/d data from a .plx file
%
% [adfreq, n, ad] = plx_ad_span(filename, channel, startCount, endCount)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%   startCount - index of first sample to fetch
%   endCount - index of last sample to fetch
%   channel - 0 - based channel number
%
% OUTPUT:
%   adfreq - digitization frequency for this channel
%   n - total number of data points 
%   ad - array of raw a/d values

if nargin < 4
    error 'Expected 4 input arguments';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[adfreq, n, ad] = mexPlex(7, filename, channel, startCount, endCount);


function [adfreq, n, ts, fn, ad] = plx_ad(filename, channel)
% plx_ad(filename, channel): Read a/d data from a .plx file
%
% [adfreq, n, ts, fn, ad] = plx_ad(filename, channel)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%   channel - 0-based channel number
%
%           a/d data come in fragments. Each fragment has a timestamp
%           and a number of a/d data points. The timestamp corresponds to
%           the time of recording of the first a/d value in this fragment.
%           All the data values stored in the vector ad.
% 
% OUTPUT:
%   adfreq - digitization frequency for this channel
%   n - total number of data points 
%   ts - array of fragment timestamps (one timestamp per fragment, in seconds)
%   fn - number of data points in each fragment
%   ad - array of raw a/d values

if nargin < 2
    error 'Expected 2 input arguments';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[adfreq, n, ts, fn, ad] = mexPlex(2, filename, channel);


function [n, ts, sv] = plx_event_ts(filename, channel)
% plx_event_ts(filename, channel) Read event timestamps from a .plx file
%
% [n, ts, sv] = plx_event_ts(filename, channel)
%
% INPUT:
%   filename - if empty string, will use File Open dialog
%   channel - 1-based external channel number
%             strobed channel has channel number 257  
%
% OUTPUT:
%   n - number of timestamps
%   ts - array of timestamps (in seconds)
%   sv - array of strobed event values (filled only if channel is 257)

if nargin < 2
    error 'Expected 2 input arguments';
end
if (isempty(filename))
   [fname, pathname] = uigetfile('*.plx', 'Select a Plexon .plx file');
   if isequal(fname,0)
     error 'No file was selected'
   end
   filename = fullfile(pathname, fname);
end

[n, ts, sv] = mexPlex(3, filename, channel);



function [n] = plx_close(filename)
% plx_close(filename): Close the .plx file
%
% [n] = plx_close(filename)
%
% INPUT:
%   filename - if empty string, will close any open files
%
% OUTPUT:
%   n - always 0

[n] = mexPlex(22, filename);
