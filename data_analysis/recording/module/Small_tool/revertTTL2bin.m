function data = revertTTL2bin(tRise, tDur, Fs, tlen)
%detectTTL������̡��������غͳ���ʱ�佨��������bool����
%data = revertTTL2bin(tRise, tDur)
%data = revertTTL2bin(tRise, tDur, Fs, tlen)
%
% ---------------------------Input---------------------------
% tRise     :  TTL��������ʱ�̣���λsec
% tDur      :  TTL�ĸߵ�ƽ����ʱ������λsec
% Fs        :  ������
% tlen      :  data �Ĳ���ʱ��
%
% ---------------------------Output--------------------------
% data      :  bool�������ݣ�1y

assert(isvector(tRise) && isvector(tDur));
assert(length(tRise) == length(tDur));
if ~exist('Fs', 'var'); Fs = 1; end
if ~exist('tLen', 'var'); tLen = tRise(end)+tDur(end) + 1/Fs; end

%% ����
nlen = round(tlen * Fs);
data = false(nlen, 1);
tDown = tRise + tDur;
tRise_n_dt = round(tRise * Fs);
tDown_n_dt = round(tDown * Fs)-1;
for i=1:length(tRise)
    data(tRise_n_dt(i):tDown_n_dt(i)) = true;
end