clear;
filename = 'nocolor/tool';
pcname = [filename, '.ply'];
simpname = [filename, '-contour.ply'];

pc = pcread(pcname);
X = double(pc.Location);
n = pc.Count;
clear pc;

k = 15;
alpha = 0.1;
m = round(n*alpha);

sigma = 0;
index = zeros(n,k,'int32');
d = zeros(n,k);
f = zeros(n,1);

for i = 1:n
    t = sum((X-X(i,:)).^2,2);
    [t, p] = sort(t);
    index(i,:) = p(2:k+1);
    d(i,:) = t(2:k+1);
    sigma = max(max(d(i,:)), sigma);
end

d = exp(-d/sigma);
t = sum(d,2);
d = d./t;

for i = 1:n
    t = X(i,:);
    for j = 1:k
        t = t-d(i,j)*X(index(i,j),:);
    end
    f(i) = sum(t.^2);
end

[~,p] = sort(-f);
simpX = X(p(1:m),:);
pc = pointCloud(simpX);
pcwrite(pc,simpname,'PLYFormat','binary');