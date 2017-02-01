function out = Nvalue(r, e)
if e < 0 &&  r(9) > 0.5 
    out = 8;
elseif e == 0 && (r(5) > 0.5 || r(7) > 0.5 || r(10) > 0.5 || r(6) > 0.5) %con imfill va tutto 
    massimo = max([r(5), r(7), r(10)]);
    out =  find(r == massimo) - 1;
else
   %massimo = max([r(1), r(2), r(3),r(4), r(5), r(6), r(8)]);
    massimo = max(r);
    out =  find(r == massimo) - 1;
    if out == 8   % OVVIAMENTE NON HA SENSO
        out = 7;
    end
 end