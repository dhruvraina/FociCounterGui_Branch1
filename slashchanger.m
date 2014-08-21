function varargout = slashchanger(inputdir, changetoslash)
inputdir(inputdir=='\')=changetoslash;
varargout{1} = inputdir;
end