function mark = sigmark(pval, defalut_ns)
%½«PVAL¼ÆËã³É 'n.s.','*', '**', '***'
%function mark = sigmark(pval, defalut_ns)
%--------------------Example---------------
% mark = sigmark(0.3);      %'n.s'
% mark = sigmark(0.3, '-'); %'-'
% mark = sigmark(0.004);     %'**'

if ~exist('default_ns', 'var')
    defalut_ns = 'n.s.';
end
if pval>0.05
    mark=defalut_ns;
elseif 0.01<pval&&pval<0.05
    mark='*';
elseif pval<0.01&&pval>0.001
    mark='**';
elseif pval<0.001
    mark='***';
end