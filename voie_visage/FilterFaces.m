function res = FilterFaces(res)

f = ones(size(res,1),1);

for i=1:size(res,1)-1
    for j=i+1:size(res,1)
        
        if( res(i,1)<res(j,1))
            overlap_width = min(res(i,1)+res(i,3)-res(j,1),res(j,3));
        else
            overlap_width = min(res(j,1)+res(j,3)-res(i,1),res(i,3));
        end
        
        if( res(i,4)<res(j,4))
            overlap_height = min(res(i,2)+res(i,4)-res(j,2),res(j,4));
        else
            overlap_height = min(res(j,2)+res(j,4)-res(i,2),res(i,4));
        end
        
        if (overlap_width > 0 && overlap_height > 0 )
            t1 = (overlap_width*overlap_height) / (res(i,3)*res(i,4));
            t2 = (overlap_width*overlap_height) / (res(j,3)*res(j,4));
            
            if( max(t1,t2)>0.6),
                if (res(i,6)==2 && res(j,6)==2),
                    if (res(i,5)>res(j,5)) % more confident frontal
                        f(j) = f(j)&0;
                    else
                        f(i) = f(i)&0;
                    end
                elseif (res(i,6)==2),
                    if( max(t1,t2)>0.8),
                        f(j) = f(j)&0;
                    elseif (res(i,5)>res(j,5))
                        f(j) = f(j)&0;
                    else
                        f(i) = f(i)&0;
                    end
                elseif (res(j,6)==2),
                    if( max(t1,t2)>0.8),
                        f(i) = f(i)&0;
                    elseif (res(j,5)>res(i,5))
                        f(i) = f(i)&0;
                    else
                        f(j) = f(j)&0;
                    end
                else % smaller region
                    if (t1>t2)
                        f(j) = f(j)&0;
                    else
                        f(i) = f(i)&0;
                    end
                end
            end
        end
    end
end

res(f(:)==0,:)=[];