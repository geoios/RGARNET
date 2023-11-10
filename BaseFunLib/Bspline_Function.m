function [Y] = Bspline_Function(u,Mp,knots,spdeg,nchoosekList,model)

switch model
    case 1 % der-Boor Cox
        Y = 0;
        for i=1:length(Mp)
            Y = Y + Mp(i) * Bbase(i,spdeg,u,knots);
        end
    case 2 % Clark

        Array=u-knots;
        Rnum=find(Array<=0,1);
        Rscope=knots(Rnum);
        Lnum=max(find(Array>0));
        Lscope=knots(Lnum);
        if Rscope==knots(spdeg+1)
            Rnum=Rnum+1;Lnum=Lnum+1;
            Rscope=knots(Rnum);Lscope=knots(Lnum);
        end
        r=(u-Lscope)/(Rscope-Lscope);

        Y=0;
        for k = 0:1:spdeg
            Y = Y + Mp(Lnum-spdeg+k) * Bbase_Clark(k,spdeg,r,nchoosekList);
        end

end