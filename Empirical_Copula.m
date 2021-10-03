function f = Empirical_Copula(x,y)
    xS = sort(x);
    yS = sort(y);
    numRows = size(x,1);
    res = zeros(numRows,numRows);
    for i = 1:numRows
        for j = 1:numRows
            conX = xS(i);
            conY = yS(j);
            res(i,j) = sum(x <= conX & y <= conY)/numRows;
        end
    end
    f = res;
end