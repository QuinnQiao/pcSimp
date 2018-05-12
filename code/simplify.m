function simpX = simplify(alpha, lambda, sigma, k, X)
    
    n = size(X,1);
    m = ceil(n*alpha);
    
    L = zeros(n);
    A = zeros(n);
    
    for i = 1:n
        d = dist(X,X(i,:),sigma);
        [d,p] = sort(d);
        for j = 2:k+1
            L(i,p(j)) = exp(-d(j));
            L(p(j),i) = L(i,p(j));
            A(i,p(j)) = 1;
            A(p(j),i) = A(i,p(j));
        end
    end
    
    diagL = sum(L,2);
    for i = 1:n
        L(i,:) = L(i,:)/diagL(i);
    end

    gamma = 1/alpha-1-2*k*lambda;
    beta = -alpha*gamma*(gamma+1);
    I = eye(n);
    J = ones(n);
    L = I-L;

    Psi = ???

    simpX = [];
end
