% Lista 2 - Macroeconomia II (2017)
% Aluno: Raul Guarini Riva
% Quest�o 3 - item 3
% Fun��o auxiliar para calcular distribui��o invariante da matriz
% estoc�stica M, cujas linhas somam 1, numericamente.
% M eh a matriz em que estamos interessados e epsilon eh o par�metro de converg�ncia. 

function inv_dist = inv_dist_num(M, epsilon)
inv_dist0 = ones(length(M),1);
inv_dist1 = M'*inv_dist0;
diff = norm(inv_dist1 - inv_dist0);

while diff > epsilon
    inv_dist0 = inv_dist1;
    inv_dist1 = M'*inv_dist0;
    diff = norm(inv_dist1 - inv_dist0);
end

inv_dist = inv_dist1/sum(inv_dist1);