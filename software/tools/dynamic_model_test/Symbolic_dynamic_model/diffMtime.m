function [ dF ] = diffMtime(F, V )
%DIFFMTIME Differentiate symbolic matrix with respect to time. Max second
%derivative!

syms t;
Var=length(V)/3;
Vt=V;
    for cont0=1:1:Var
        Vt(cont0*3-2)=strcat('f',num2str(cont0),'(t)');
        Vt(cont0*3-1)=diff(Vt((cont0*3)-2),t);
        Vt(cont0*3)=diff(Vt((cont0*3)-2),t,2);
    end
    Dposx=F;
    
    for cont=1:1:Var*3
        Dposx=subs(Dposx,V(cont),Vt(cont));
    end
    dF=diff(Dposx,t);
    
    for cont=Var*3:-1:1         %
        dF=subs(dF,Vt(cont),V(cont));
    end

end

