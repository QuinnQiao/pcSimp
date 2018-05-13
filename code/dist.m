function d = dist(X, p, sigma, eta)
	% compute the spatial distance and color distance
	%   weighted sum of two kinds of distance
    % Author: Junkun Qi
    % 2018/5/13

	% init
	d = zeros(size(X,1),1);
	% if there's color
	if length(p) == 6
		C = rgb2lab(X(:,4:6));
		c = rgb2lab(p(4:6));
		X = X(:,1:3);
		p = p(1:3);
		% color distance
		c_max = max(C);
		c_min = min(C);
		c_sigma = sum((c_max-c_min).^2);
		d = eta*sum((C-c).^2,2)/c_sigma;
	end
	% add spatial distance
	d = d + sum((X-p).^2,2)/sigma;
end