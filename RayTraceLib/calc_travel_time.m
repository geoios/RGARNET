function [travel_time] = calc_travel_time(t_angle, nl, layer_d, layer_s, sv_d, sv_s, y_d, y_s, l_dep, l_sv, l_sv_trend, l_th)
lmax=55;epg=10^-2;
eang=80*pi/180;
epr=10^-12;
epa=sin(eang);
travel_time = 0.0;
pp = sin(t_angle)/sv_d;  
tinc = 0.0;

%%.0
if y_d~=y_s
    k1=layer_s-1;  
    vn=zeros(1,layer_d);tn=zeros(1,layer_d);
    
    vn(k1+1:layer_d-1) = l_sv(k1+1:layer_d-1);  
    vn(k1)      = sv_s;
    vn(layer_d) = sv_d;
    
    tn(layer_s:layer_d) = l_th(layer_s-1:layer_d-1);
    tn(layer_s) = tn(layer_s) - (y_s - l_dep(k1));
    tn(layer_d) = tn(layer_d) - (l_dep(layer_d) - y_d);
    
    for i=layer_s:1:layer_d
        j=i-1;
        sn1 = pp*vn(i);
        cn1 = sqrt(1.0 - sn1^2);
        sn2 = pp*vn(j);
        cn2 = sqrt(1.0 - sn2^2);
        
        if abs(l_sv_trend(i-1))>epg
            tinc=(log((1.0+cn2)/(1.0+cn1))+log(vn(i)/vn(j)))/l_sv_trend(i-1);
        elseif abs(l_sv_trend(i-1))<=epg
            snm=min(sn1,sn2);
            if (snm>epa)
                aatra=1.0;bbtra=1.0;
                cctra=cn1*(cn2+cn1);
                d2=cn2^2;
                d1=cn1^2;
                tmp=0;ls=1;
                while 1
                    tmpdd=aatra/ls;
                    tmp=tmp+tmpdd;
                    if (tmpdd>=epr && ls<=lmax)
                        aatra=aatra*d2+bbtra*cctra;
                        bbtra=bbtra*d1;
                        ls=ls+2;
                        continue;
                    else
                        tinc=tn(i)*tmp*pp*(sn1+sn2)/(cn1+cn2);
                        break;
                    end
                end
            elseif (snm<=epa)
                zzc = pp*(sn1 + sn2)/(1.0 + cn1)/(cn1 + cn2);
                xxc = 1.0/vn(i);
                zz = (cn1 - cn2)/(1.0 + cn1);xx = xxc*(vn(i) - vn(j));
                za = 1.0;xa = 1.0;tmp = 0.0;ls = 1 ;
                
                while 1
                    tmpdd=(za*zzc+xa*xxc)/ls;
                    tmp=tmp+tmpdd;
                    if (tmpdd>=epr && ls<=lmax)
                        za=za*zz;
                        xa=xa*xx;
                        ls=ls+1;
                        continue;
                    else
                        tinc=tn(i)*tmp;
                        break;
                    end
                end
            end
        end
        travel_time = travel_time + tinc;
    end
end
end

