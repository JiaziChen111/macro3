clear all;
close all;
clc;

%% QUESTAO 2

% Item b)

% Nesse item, faremos o par�metro "A" variar. A id�ia � torn�-lo crescente at� o ponto
% em que passa a ser vantajoso para o indiv�duo correr. Em termos de
% algoritmo, repetimos o procedimento do item anterior, apenas
% acrescentando-se o loop para fazer a itera��o em torno do valor de A desejado.

% Dados
A=1;  % Do problema inicial
N=2;
R=1.05;
delta=2;
P=0.5;
e=10;

% Utilidade
u=@(c)((c.^(1-delta))/(1-delta));


iterA=0;
P_Esperado_Mentir=0;
P_Esperado_Verdade=0;

while (P_Esperado_Mentir <= P_Esperado_Verdade) && (iterA < 600)
    A = A + 0.1;   % ou seja, estamos fazendo A se elevar em incrementos de 0,1.
    iterA = iterA + 1;

% Chute inicial para o multiplicador (seguiremos o algoritmo proposto pelas
% notas):

Lambda=10;

dist=1;
tol=10^(-6);

itmax=10^(6);
it=0;

while it<itmax && dist>tol
    
      it=it+1;
      
      % Escrevendo gamma como no handout:
      
      gamma=abs(((1+Lambda/(1-P))/(A-Lambda/P))^(1/delta)); % porque gamma � 
                                                            % a raz�o beta/alpha
      M=N+1;
      F=zeros(M,M);
      
    % Obs:. Para evitar confus�o com os �ndices, seguiremos o padr�o
    % estabelecido pelo handout, utilizando "i" para representar
    % o agente e "j" para representar o seu anuncio.
    
    % Aqui vamos calcular o F �timo para o problema do agente ap�s a
    % realiza��o de um certo (w), conforme feito no handout.
    
    for j=1:M
        F(j,M)=gamma*(j-1)*R^(1/delta-1);
    end
    
    % Agora vamos completar os temos da matriz F, a id�ia e resolver o
    % problema retroativamente utilizando a informa��o calculada na parte
    % anterior.
      
      for k=1:M-1;
        j=M-k;
        for i=1:M-k
            F(i,j)=(P*((F(i,j+1)+1)^delta)+(1-P)*(F(i+1,j+1)^delta))^(1/delta);
        end    
      end
      
          
    % Precisamos ver qual seria o ganho do agente de desviar para, ent�o,
    % podermos atualizar o multiplicador e iterar at� chegarmos ao �timo:
      
      Ganho=zeros(M,M); 

    % Vamos fazer da mesma forma como fizemos para calcular F. Aqui o ganho
    % de desviar para o �ltimo indiv�duo � equivalente ao que ele ganharia
    % em t=1 se desviasse do mecanismo calculado acima.
    
    for j=1:M 
        Ganho(j,M) = (P/(1-P))*(j-1)^delta*R^(1-delta);
    end
      
    % Completando a matriz:  
    
    % O calculo do ganho foi baseado novamente no handout.
      for k=1:M-1 
          j=M-k;
        for i=1:M-k
            Aux=Ganho(i,j+1)*(F(i,j+1)^(1-delta));
            if isnan(Aux)==1
                Aux=0;
            end    
            Ganho(i,j)=P*(Aux-1)*(1+F(i,j+1)^(delta-1))+(1-P)*(Ganho(i+1,j+1));
        end    
      end
      
    % Agora � s� calcular o novo lambda, seguindo a metodologia da fun��o
    % penalidade, e verificar a sua converg�ncia (esse loop maior)
    
    lambda=exp(Ganho(1,1))*Lambda;
    dist=abs(Lambda-lambda);
    Lambda=lambda; 
end


% De posse, ent�o, do lambda encontrado, e ainda seguindo o handout, vamos procurar o
% mecanismo �timo:

% A matriz abaixo representa todo o espa�o de "estados" poss�veis.

Omega=ones(length(N));

for k=1:N
    Omega(k)=round(rand(1));
end 

NewF=zeros(N,N); 
NewF=F(1:N,2:N+1);

% Verifiquemos, ent�o, se o paciente tem incentivo a correr, i.e., se � prefer�vel a
% ele mentir quando acredita que todos os demais est�o mentindo. Para
% tanto, necessitaremos do c�lculo dos pagamentos totais no �timo.


% Tx. Poupan�a
S=ones(1,N);
 
% Verifiquemos quantos agentes pacientes h� na economia:

Pacientes(1:N)=zeros(1,N); 

for i=1:N-1
    Pacientes(i+1)=sum(Omega(1:i)); 
end

% Verifiquemos em seguida, e dada nossa matriz Omega gerada anteriormente,
% onde est�o os agentes impacientes;

Impacientes=find(Omega==0);

% Poupan�a

for i=Impacientes
    S(i)=NewF(Pacientes(i)+1, i);
    S(i)=S(i)/(1+S(i));
end

% Logo, S representa a taxa de poupan�a do banco.

Acumulo=1;
Dotacao_Economia=e*N;
Consumo=Dotacao_Economia*ones(1,N);

for i=1:N
    Acumulo=Acumulo*S(i);
    Consumo(i)=Acumulo*Dotacao_Economia;
end

Pag_Impacientes=(1-S).*[Dotacao_Economia,Consumo(1:N-1)];

Pag_Pacientes=zeros(1,N);
if sum(Omega)>0
    Aux=Consumo(N)*R/sum(Omega);
    Pag_Pacientes=Omega.*Aux;
end
    
Total=Pag_Impacientes+Pag_Pacientes;

% Assim, para o c�lculo dos payoffs em dizer a verdade,

% Chute inicial
P_Esperado_Verdade = 0; 
P_Esperado_Mentir = 0;

for k = 1:N
    for i = 1:N
        omega(1,N-i+1) = floor(mod(2^(k-1)/(2^(i-1)),2));
    end
    P_Esperado_Verdade = P_Esperado_Verdade + omega*u(Total)';
    P_Esperado_Mentir = P_Esperado_Mentir + omega*u(Consumo_Otimo(A, P, delta, R, zeros(1,N), Dotacao_Economia, Lambda, F))';
end

P_Esperado_Mentir = P_Esperado_Mentir/N; % payoff esperado de se mentir
P_Esperado_Verdade = P_Esperado_Verdade/N; % payoff esperado de se falar a verdade

end

