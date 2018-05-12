function d = dist(X, p, sigma)
	if length(p) == 6
		C = X(:,4:6)
		c = p(4:6)
		X = X(:,1:3)
		p = p(1:3)
		% color distance
		avg = mean(C,1)
		
	end
	% add spatial distance
	d = d + sum((X-p).^2,2)/sigma
end