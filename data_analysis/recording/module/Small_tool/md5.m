function md5hash = md5(data, type)
%% [md5hash] = md5(string) md5(filename, 'file')
% Use a java routine to calculate MD5 hash of a string or file
assert(ischar(data));
if ~exist('type', 'var')
    type = 'string';
end

switch lower(type)
    case 'file'
        fid = fopen(data); % <- this is much faster than java i/o stream
        datastr = fread(fid, inf, '*uint8');
        fclose(fid);
    case 'string'
        datastr = data;
    otherwise
        error('Error type!');
end

mddigest   = java.security.MessageDigest.getInstance('MD5');
md5hash = reshape(dec2hex(typecast(mddigest.digest(uint8(datastr)),'uint8'))',1,[]);

end