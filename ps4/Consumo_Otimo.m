function Total = consumo_otimo(A, P, delta, R, Omega, Dotacao_Economia, lambda, F)

N = length(Omega);
NewF=zeros(N,N); 
NewF=F(1:N,2:N+1);
 
% Tx. Poupan�a
S=ones(1,N);
 
% Vamos verificar agora quantos agentes pacientes temos na economia:

Pacientes(1:N)=zeros(1,N); 

for i=1:N-1
    Pacientes(i+1)=sum(Omega(1:i)); 
end

% Vamos verificar agora, dada nossa matriz Omega gerada anteriormente,
% aonde est�o os agentes impacientes;

Impacientes=find(Omega==0);

% Poupan�a

for i=Impacientes
    S(i)=NewF(Pacientes(i)+1, i);
    S(i)=S(i)/(1+S(i));
end

% Logo S representa a taxa de poupan�a do banco.

Acumulo=1;
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

end