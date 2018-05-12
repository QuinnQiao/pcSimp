function simpX = simplify(alpha, lambda, sigma, k, X)
    
    n = size(X,1);
    m = ceil(n*alpha);
    
    L = zeros(n);
    
    for i = 1:n
        
    end
    
    gamma = 1/alpha-1-2*k*lambda;
    beta = -alpha*gamma*(gamma+1);
    I = eye(n);
    J = ones(n);
    
    simpX = [];
end
