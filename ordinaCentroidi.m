function out = ordinaCentroidi(List)
    
    In = List;
    out = sortrows(In.',3);
    out = out';
    
    vettore_ordinato = [];
    a = 1;
    b = 9;
    for t=1:9
       riga = out(:,a:b);
       riga_ordinata = sortrows(riga',2);
       vettore_ordinato =[vettore_ordinato;riga_ordinata];
       a = a + 9;
       b = b + 9;
    end
    
    out = vettore_ordinato(:,1)';

end