filename = 'nocolor/bunny';
pcname = [filename, '.ply'];
pc = pcread(pcname);
X = double(pc.Location);
n = pc.Count;
range = [pc.XLimits; pc.YLimits; pc.ZLimits];
clear pc;

VOLUMN = prod(range(:,2)-range(:,1));
sigma = nthroot(VOLUMN/n,3);
disp([num2str(sigma), ', ', num2str(sigma^2)]);