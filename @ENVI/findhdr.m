function hdrfile = findhdr(filename)
%FINDHDR Return the corresponding ENVI header filename, if it exists
% hdrfile = findhdr(datafile) attempts to find a corresponding .hdr file
% for the given filename. If such a file does not exist, throw an error.

% Discard the existing extension, if there is one
[fpath,fname,~] = fileparts(filename);
hdrfile = fullfile(fpath, [fname, '.hdr']);

% Check the existence of the file
assert(exist(hdrfile,'file')==2,'ENVI header file %s does not exist',hdrfile);

end