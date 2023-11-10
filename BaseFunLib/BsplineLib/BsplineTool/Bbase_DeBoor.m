function result = Bbase_DeBoor(i,k,u,NodeVector)
% ���������result
% iΪ���ƶ�������    kΪ����  uΪ�����ֵ  NodeVectorΪ�ڵ�����
if k==0 
    if NodeVector(i)<=u && u<NodeVector(i+1)
        result=1;
        return;
    else
        result=0;
        return;
    end
end
    if NodeVector(i+k)-NodeVector(i)==0 
        alpha=0;
    else
        alpha=(u-NodeVector(i))/(NodeVector(i+k)-NodeVector(i));
    end
    if NodeVector(i+k+1)-NodeVector(i+1)==0
         beta=0;
    else
        beta=(NodeVector(i+k+1)-u)/(NodeVector(i+k+1)-NodeVector(i+1));
    end
result=alpha*Bbase(i,k-1,u,NodeVector)+beta*Bbase(i+1,k-1,u,NodeVector);
end
