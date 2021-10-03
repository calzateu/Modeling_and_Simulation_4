classdef EmpiricalDistribution
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function obj = SthngElse(~, values, it)
            %values: array with data.
            %it: amount of iterations (>0)
            
            N = length(values);
            empDist = zeros(it, 1);
            p = it;
            
            d = 100;
            mi = min(values);
            prct = (max(values)-mi)/d;
            
            while it > 0
                it = it - 1;
                positions = ceil(N*rand([1 N]));
                empDist(p-it) = mean(values(positions));
            end
            
            q = d-1;
            
            fin = zeros(q, 1);
            fin(1) = length(empDist(empDist < mi + prct));
            
            cont = fin(1);
            
            while q > 0
                
                fin(d-q+1) = length(empDist(empDist < mi+(d-q+1)*prct)) - cont;
                cont = cont + fin(d-q+1);
                q = q-1;
                
            end
            
            obj = fin;
        end
        
        function obj = EmpDist(~, values)
            
            n = length(values);
            Empirical = NaN(n, 2);
            values = sort(values);
            pos = 1;
            ind = 1;
            
            while pos < n
                
                while values(pos) == values(pos + 1) && pos < n - 1
                    pos = pos + 1;
                end
                
                Empirical(ind, :) = [values(pos), 1/n*length(values(values<=values(pos)))];
                ind = ind + 1;
                pos = pos + 1;
                
            end
            
            if(values(end - 1) ~= values(end))
                Empirical(ind, :) = [values(end), 1];
            end
            
            Empirical = rmmissing(Empirical);
            
            obj = Empirical;
            
        end
        
        function obj = statBT(obj, data, n, B)
            
            i = 1;
            sample = zeros(B, n+2);
            empDistProb = {B};
            
            while i <= B
                sample(i, 1:n) = datasample(data, n);
                sample(i, n+1) = mean(sample(i, 1:n));
                sample(i, n+2) = var(sample(i, 1:n));
                empDistProb{i} = obj.EmpDist(sample(i, 1:n));
                i = i + 1;
            end
            
            obj = [sample empDistProb];
        end
        
        function obj = plotting(~, BT)
            l = size(BT, 2);
            k = 2;
            hold on
            while k <= l
                plot(BT{1,k}(:,1), BT{1,k}(:,2));
                k = k + 1;
            end
            
            obj = BT;
        end
        
        function obj = GL(~, data)
            
            V = var(data);
            M = mean(data);
            lambda = 1/sqrt(V);
            gamma = M - 1/lambda;
            t = gamma*1/rand(size(data));
            ft = lambda*exp(-lambda*(t - gamma));
            histogram(ft)
            
            obj = ft;
            
        end
    end
end

