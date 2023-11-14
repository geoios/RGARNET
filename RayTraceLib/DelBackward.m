function [Profi,DelProf] = DelBackward(Profi)

%% Removed some outliers from the sound velocity profile observations
DelProf = [];
while 1
    pf1 = Profi(:,1);
    pf2 = Profi(:,1);
    idxp = [];
    for i = 1:length(pf1)-1
        dpf = pf1(i+1) - pf1(i);
        if dpf == 0             % The next observation will be at the same depth as this one
           Profi(i,2) = (Profi(i,2) + Profi(i+1,2))/2;
           idxp = [idxp i+1];   % Outlier index
        end
        if dpf < 0              % The next observation is shallower than this one
           idxp = [idxp i+1];   % Outlier index
        end
    end
    if length(idxp) == 0 ; break;  end
    DelProf = [DelProf;Profi(idxp,:)]; %Outlier storage
    Profi(idxp,:) = [];       % Outliers are removed from the observed data
end