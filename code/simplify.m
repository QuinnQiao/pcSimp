function simpX = simplify(alpha, lambda, sigma, eta, k, X)
    % size of grid
    n = size(X,1);

    if n*alpha < 1
        % too small -> maybe the corner -> kept 
        simpX = X;
    else % normal grid
        % graph operators
        m = ceil(n*alpha);
        k = min(k,n-1);    
        L = zeros(n);
        A = zeros(n);      
        for i = 1:n
            d = dist(X,X(i,:),sigma,eta);
            [d,p] = sort(d);
            A(i, p(2:k+1)) = 1;
            L(i, p(2:k+1)) = exp(-d(2:k+1));
        end
        % make sure the symmetry
        A = (A+A')/2;
        L = (L+L')/2;
        % normalize L
        d = sum(L,2);
        L = eye(n) - L./d;
        % f vector
        f = diag((L*X)*(L*X)');
        % x = quadprog(H,f,A,b,Aeq,beq,lb,ub)
        % min 1/2x'Hx + f'x
        % s.t Ax<=b, Aeqx=beq, lb<=x<=ub
        H = diag(f) + lambda*(A'*A);
        f = f + lambda*alpha*k*A*ones(n,1);
        d = quadprog(H, -f, [], [], ones(1,n), m, zeros(n,1), ones(n,1));
        [~,p] = sort(-d); % max of d <=> min of -d
        % top alpha
        simpX = X(p(1:m),:);
        clear L A H f d p;
    end
end