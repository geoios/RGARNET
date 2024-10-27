function [MP,RESData,Q] = FixTCalModelT(RESData,SetModelMP)
ConvCriteria = SetModelMP.Inv_parameter.ConvCriteria;
for MAXLoop2=1:SetModelMP.Inv_parameter.maxloop
    JCB = [];detalTOri=[];MPList=[];TotalNum = length(RESData);MPListTotal = []; MP0 = [];Num = [0];
    for DataNum = 1:TotalNum
        RESData(DataNum).OBSData         =   CalPosJcb_T(RESData(DataNum).OBSData,SetModelMP,RESData(DataNum).INIData,RESData(DataNum).SVP,...
            RESData(DataNum).MP,RESData(DataNum).MPNum);
        
        [ProData(DataNum).JCB,ProData(DataNum).P,ProData(DataNum).dX,ProData(DataNum).dY,ProData(DataNum).Qxx,...
            ProData(DataNum).Qyx,ProData(DataNum).detalTOri,ProData(DataNum).VirObs,...
            ProData(DataNum).slvidx,ProData(DataNum).Jcbline]    =   CalMPJcb(RESData(DataNum).OBSData,RESData(DataNum).INIData,...
            SetModelMP,RESData(DataNum).SVP,RESData(DataNum).MP,RESData(DataNum).MPNum,RESData(DataNum).knots);
        
        
        MPList = [MPList,[RESData(DataNum).MPNum(1);length(ProData(DataNum).slvidx)]];MPListTotal = [MPListTotal,length(ProData(DataNum).slvidx)];
        MP0 = [ MP0;RESData(DataNum).MP(ProData(DataNum).slvidx)'];Num = [Num,ProData(DataNum).Jcbline];
    end
    MPList = cumsum([MPList(1,:),MPList(2,:)-MPList(1,:)]);MPListTotal = cumsum(MPListTotal);
    NumList = cumsum(Num);
    MPListTotal0 = [0,MPListTotal];
    P = sparse(NumList(end),NumList(end));
    switch SetModelMP.Inv_model.AdjGuiModel
        case 1
            for DataNum = 1:TotalNum
                JCB = blkdiag(JCB,ProData(DataNum).JCB);
                P(NumList(DataNum)+1:NumList(DataNum+1),NumList(DataNum)+1:NumList(DataNum+1)) = sparse(ProData(DataNum).P);
                detalTOri = [detalTOri;ProData(DataNum).detalTOri];
            end
            VirObs = sparse(MPList(TotalNum-1) - (TotalNum-1)*3,MPListTotal(end));
            VirObs(1:MPList(1)-3,1:MPListTotal(1)) = ProData(1).VirObs;
            VirObs(1:MPList(1)-3,MPListTotal(1)+1:MPListTotal(2)) = - ProData(2).VirObs;
            for DataNum = 2:TotalNum-1
                LineMin = MPList(DataNum - 1)- (DataNum-1)*3+1;LineMax = MPList(DataNum) - DataNum*3;
                RowMin = MPListTotal(DataNum -1);RowMiddle = MPListTotal(DataNum);RowMax = MPListTotal(DataNum+1);
                VirObs(LineMin:LineMax,RowMin+1:RowMiddle) = ProData(DataNum).VirObs;
                VirObs(LineMin:LineMax,RowMiddle+1:RowMax) = - ProData(DataNum+1).VirObs;
            end
            JCB = [JCB;VirObs];detalTOri = [detalTOri;-VirObs*MP0];
            AddPNum = MPList(TotalNum-1) - (TotalNum-1)*3;
            Mu3 = SetModelMP.HyperParameters.Mu3;
            P = blkdiag(P,Mu3 * spdiags(ones(AddPNum,1),0,AddPNum,AddPNum));
            Q = inv(JCB'*P*JCB);
            dx = Q*JCB'*P*detalTOri;detalX = [];
            for DataNum = 1:TotalNum
                dX = zeros(RESData(DataNum).MPNum(end),1);
                dX(ProData(DataNum).slvidx) = dx(MPListTotal0(DataNum)+1:MPListTotal0(DataNum+1));
                RESData(DataNum).MP = RESData(DataNum).MP  + dX';
                detalX = [detalX;dX(1:RESData(DataNum).MPNum(1))];
            end
            [dposmax(MAXLoop2),index]  =  max(abs(detalX));
            if dposmax(MAXLoop2)<ConvCriteria
                break;
            end
        case 4
            dx=[];dy = [];Qxx=[];Qyx=[];MP0=[];QXX=[];
            for DataNum = 1:TotalNum
                dx = [dx;ProData(DataNum).dX];
                dy = [dy;ProData(DataNum).dY];
                Qxx{DataNum} = ProData(DataNum).Qxx;
                Qyx{DataNum} = ProData(DataNum).Qyx;
                QXX = blkdiag(QXX,ProData(DataNum).Qxx);
                MP0 = [ MP0;RESData(DataNum).MP(1:RESData(DataNum).MPNum(1))'];
            end
            
            dx0 = [dx;dy];
            AddPNum = MPList(TotalNum-1) - (TotalNum-1)*3;
            P0 = spdiags(ones(AddPNum,1),0,AddPNum,AddPNum);
            C = sparse(MPList(TotalNum-1)-(TotalNum-1)*3,MPList(TotalNum));
            C(1:MPList(1)-3,1:MPList(1)) = ProData(1).VirObs(:,1:RESData(1).MPNum(1));
            C(1:MPList(1)-3,MPList(1)+1:MPList(2)) = - ProData(2).VirObs(:,1:RESData(1).MPNum(1));
            for DataNum = 2:TotalNum-1
                LineMin = MPList(DataNum - 1)- (DataNum-1)*3+1;LineMax = MPList(DataNum) - DataNum*3;
                RowMin = MPList(DataNum -1);RowMiddle = MPList(DataNum);RowMax = MPList(DataNum+1);
                C(LineMin:LineMax,RowMin+1:RowMiddle) = ProData(DataNum).VirObs(:,1:RESData(1).MPNum(1));
                C(LineMin:LineMax,RowMiddle+1:RowMax) = - ProData(DataNum+1).VirObs(:,1:RESData(1).MPNum(1));
            end
            Mu3 = SetModelMP.HyperParameters.Mu3;
            K = inv(inv(Mu3*P0) + C*QXX*C');L = [- C * MP0 - C * dx];KL = K*L;
            
            dXX=[];dXY=[];detalX=[];MPListAdd = [0,MPList];QXx = [];
            for DataNum = 1:TotalNum
                T = C(:,MPListAdd(DataNum)+1:MPListAdd(DataNum+1))'*KL;
                dXX = ProData(DataNum).dX + Qxx{DataNum} * T;
                dYX = ProData(DataNum).dY + Qyx{DataNum} * T;
                dX = zeros(RESData(DataNum).MPNum(end),1);
                dX(ProData(DataNum).slvidx) = [dXX;dYX]';
                RESData(DataNum).MP = RESData(DataNum).MP  + dX';
                detalX = [detalX;dXX];
                detalTOri = [detalTOri;ProData(DataNum).detalTOri];
                P(NumList(DataNum)+1:NumList(DataNum+1),NumList(DataNum)+1:NumList(DataNum+1)) = sparse(ProData(DataNum).P);
                QXx = blkdiag(QXx,Qxx{DataNum} - Qxx{DataNum}*C(:,MPListAdd(DataNum)+1:MPListAdd(DataNum+1))'*K*C(:,MPListAdd(DataNum)+1:MPListAdd(DataNum+1))*Qxx{DataNum});
            end
            sigma2 = detalTOri'*P*detalTOri/MPList(end);
            Q = QXx*sigma2;
            [dposmax(MAXLoop2),index]  =  max(abs(detalX))
            if dposmax(MAXLoop2) <ConvCriteria
                break;
            end
        case 5
            for DataNum = 1:TotalNum
                JCB = blkdiag(JCB,ProData(DataNum).JCB);
                P(NumList(DataNum)+1:NumList(DataNum+1),NumList(DataNum)+1:NumList(DataNum+1)) = sparse(ProData(DataNum).P);
                detalTOri = [detalTOri;ProData(DataNum).detalTOri];
            end
            VirObs = sparse(MPList(TotalNum-1) - (TotalNum-1)*3,MPListTotal(end));
            VirObs(1:MPList(1)-3,1:MPListTotal(1)) = ProData(1).VirObs;
            VirObs(1:MPList(1)-3,MPListTotal(1)+1:MPListTotal(2)) = - ProData(2).VirObs;
            for DataNum = 2:TotalNum-1
                LineMin = MPList(DataNum - 1)- (DataNum-1)*3+1;LineMax = MPList(DataNum) - DataNum*3;
                RowMin = MPListTotal(DataNum -1);RowMiddle = MPListTotal(DataNum);RowMax = MPListTotal(DataNum+1);
                VirObs(LineMin:LineMax,RowMin+1:RowMiddle) = ProData(DataNum).VirObs;
                VirObs(LineMin:LineMax,RowMiddle+1:RowMax) = - ProData(DataNum+1).VirObs;
            end
            Wx = VirObs*MP0;C = VirObs;
            NBB = JCB'*P*JCB;Wl = JCB'*P*detalTOri;
            NCC = C*inv(NBB)*C';
            dx = (inv(NBB)-inv(NBB)*C'*inv(NCC)*C*inv(NBB))*Wl+inv(NBB)*C'*inv(NCC)*(-Wx);
            detalX = [];
            for DataNum = 1:TotalNum
                dX = zeros(RESData(DataNum).MPNum(end),1);
                dX(ProData(DataNum).slvidx) = dx(MPListTotal0(DataNum)+1:MPListTotal0(DataNum+1));
                RESData(DataNum).MP = RESData(DataNum).MP  + dX';
                detalX = [detalX;dX(1:RESData(DataNum).MPNum(1))];
            end
            Q = inv(NBB) - inv(NBB) * C' * NCC * C * inv(NBB);
            [dposmax(MAXLoop2),index]  =  max(abs(detalX))
            if dposmax(MAXLoop2)<ConvCriteria
                break;
            end
    end
end
MP=[];
for DataNum = 1:TotalNum
    RESData(DataNum).OBSData  =   CalPosJcb_T(RESData(DataNum).OBSData,SetModelMP,RESData(DataNum).INIData,RESData(DataNum).SVP,RESData(DataNum).MP,RESData(DataNum).MPNum);
    MP = [MP,RESData(DataNum).MP];
end
end

