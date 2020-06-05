% Check that param.v.range and param.f.range exist
if ~ isfield(param.f,'range')
    param.f.range=param.f.lo:param.f.diff:param.f.hi;
    param.v.range=param.v.lo:param.v.diff:param.v.hi;
    disp('Added param.f.range and param.v.range');
    save('param.mat','param')
end

% Check that param.fullreps exists
if ~ isfield(param,'fullreps')
    param.fullreps=1;
    disp('Added param.fullreps = 1');
    save('param.mat','param')
end