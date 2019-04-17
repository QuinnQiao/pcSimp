function simpX = simplify(alpha, lambda, k, X, range)
    % Simplify X using the formulation
    
    % Size of grid
    n = size(X,1);
    simpX = [];

    if n*alpha < 1
        % Too small -> maybe the corner -> save them 
        simpX = X;
    else
        % Normal grid
        
        % Graph operators
        k = min(k, n-1);
        L = zeros(n);
        A = zeros(n);
        % Parameter used in edge weights -> exp(-d^2/sigma)
        sigma = 0;
        
        % Only coordinates are used to construct graph here
        % Other properties such as color and texture can also be adopted
        %   with a balance of coordinates
        for i = 1:n
            d = sum((X-X(i,:)).^2,2);
            [~, p] = sort(d);
            % d(i) must be 0
            % Besides d(i), preserve the nearest k (2:k+1) and clear the rest
            clear_p = p(k+2:end);
            d(i) = 0.;
            if ~isempty(clear_p) 
            	d(clear_p) = 0.;
            end
            ones_p = (d ~= 0);
            sigma = max(max(d), sigma);
            A(i, ones_p) = 1;
            L(i, :) = d;
        end
        
        % Normalize weight = exp(-d^2/sigma)
        p = (A==1);
        L(p) = exp(-L(p)/sigma);
        
        % Guarantee symmetry of matrix
        A = (A+A')*0.5;
        L = (L+L')*0.5;
        
        % Normalize L
        d = sum(L,2);
        L = eye(n) - L./d; % L = I-D^-1W
        
        % f vector
        f = diag((L*X)*(L*X)');
        
        % Remove overlap
        delta = 1e-10;
        range(:,1) = range(:,1)-delta;
        range(:,2) = range(:,2)+delta;
        p = X(:,1)>range(1,1) & X(:,1)<range(1,2) & X(:,2)>range(2,1)...
            & X(:,2)<range(2,2) & X(:,3)>range(3,1) & X(:,3)<range(3,2);
        
        f = f(p);
        A = A(p,p);

        % Complement neglected degree
        d = (k-sum(A,2));
        A = A + diag(d);
        X = X(p,:);
        
        n = length(f);
        if n==0
            return;
        end
        m = round(n*alpha);
        
        % x = quadprog(H,f,A,b,Aeq,beq,lb,ub)
        % min 1/2x'Hx + f'x
        % s.t Ax<=b, Aeqx=beq, lb<=x<=ub
        L = diag(f) + lambda*(A'*A);
        f = f + lambda*alpha*k*A*ones(n,1);
        d = quadprog(L, -f, [], [], ones(1,n), m, zeros(n,1), ones(n,1));
        [~,p] = sort(-d); % max of d <=> min of -d
        
        % Top alpha
        simpX = X(p(1:m),:);
    end
end