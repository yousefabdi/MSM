function Strct = Migration( Structure, Rm, topology, policy )

% Topology: 1 -> Ring, 2 -> Random Star, 3 -> Full Mesh
% Policy: 1->W-B, 2->B-B, 3->R-B, 4->R-R
    switch topology
        case 1 % Random Ring Topoligy
            switch policy   
                case 1 % W-B 
                    CopyStruct=Structure;
                    ring_set=randperm(numel(Structure));
                    front=ring_set(1);
                    rear=front;
                    [~,n_mabda]=sort([CopyStruct(front).Group.Cost]); 
                    for k=1:numel(Structure) 
                       if k==numel(Structure)
                          rear=ring_set(1); 
                       else
                          rear=ring_set(k+1);
                       end
                       %rear=rem(rear,numel(Structure))+1;
                       [~,n_maqsad]=sort([CopyStruct(rear).Group.Cost]); 
                       for wi=1:ceil(Rm*numel(n_maqsad))
                           Structure(rear).Group(n_maqsad(end+1-wi))=CopyStruct(front).Group(n_mabda(wi));
                       end   
                       front=rear;
                       [~,n_mabda]=sort([CopyStruct(front).Group.Cost]);                        
                    end
                    
                case 2 %B-B
                    front=randi(numel(Structure));
                    rear=front;
                    [~,n_mabda]=sort([Structure(front).Group.Cost]); 
                    for k=1:numel(Structure) 
                       rear=rem(rear,numel(Structure))+1;
                       [~,n_maqsad]=sort([Structure(rear).Group.Cost]); 
                       for wi=1:ceil(Rm*numel(Structure(k).Group))
                           Structure(rear).Group(n_maqsad(wi))=Structure(front).Group(n_mabda(wi));
                       end
                       front=rear;
                       [~,n_mabda]=sort([Structure(front).Group.Cost]);
                    end
                    
                case 3 %R-B
                    front=randi(numel(Structure));
                    rear=front;
                    [~,n_mabda]=sort([Structure(front).Group.Cost]); 
                    for k=1:numel(Structure)   
                       rear=rem(rear,numel(Structure))+1;
                       n_maqsad=randsample(1:numel(Structure(rear).Group),ceil(Rm*numel(Structure(rear).Group)),'false'); 
                       for wi=1:ceil(Rm*numel(n_maqsad))
                           Structure(rear).Group(n_maqsad(wi))=Structure(front).Group(n_mabda(wi));
                       end
                       front=rear;
                       [~,n_mabda]=sort([Structure(rear).Group.Cost]);
                    end                  
                    
                case 4 % R-R
                    front=randi(numel(Structure));
                    rear=front;
                    n_mabda=randsample(1:numel(Structure(front).Group),ceil(Rm*numel(Structure(front).Group)),'false');
                    for k=1:numel(Structure)   
                       rear=rem(rear,numel(Structure))+1;
                       n_maqsad=randsample(1:numel(Structure(rear).Group),ceil(Rm*numel(Structure(rear).Group)),'false'); 
                       for wi=1:ceil(Rm*numel(n_maqsad))
                           Structure(rear).Group(n_maqsad(wi))=Structure(front).Group(n_mabda(wi));
                       end
                       front=rear;
                       [~,n_mabda]=randsample(1:numel(Structure(front).Group),ceil(Rm*numel(Structure(front).Group)),'false'); 
                    end
                                                                     
            end % End of Ring Topoligy
            
        case 2 % Random Star Topology
            switch policy
                case 1 % W-B 
                    Node=randi(numel(Structure));
                    [~,n_mabda]=sort([Structure(Node).Group.Cost]); 
                    for k=1:numel(Structure)
                        if k~=Node
                           [~,n_maqsad]=sort([Structure(k).Group.Cost]);
                           for wi=1:ceil(Rm*numel(n_mabda))                        
                               Structure(k).Group(n_maqsad(end+1-wi))=Structure(Node).Group(n_mabda(wi));
                           end
                        end
                    end
                    
                case 2 % B-B
                    Node=randi(numel(Structure));
                    [~,n_mabda]=sort([Structure(Node).Group.Cost]); 
                    for k=1:numel(Structure)
                        if k~=Node
                           [~,n_maqsad]=sort([Structure(k).Group.Cost]);
                           for wi=1:ceil(Rm*numel(n_mabda))
                               Structure(k).Group(n_maqsad(wi))=Structure(Node).Group(n_mabda(wi));
                           end
                        end
                    end
                    
                case 3 % R-B
                    Node=randi(numel(Structure));
                    [~,n_mabda]=sort([Structure(Node).Group.Cost]); 
                    for k=1:numel(Structure)
                        if k~=Node
                           n_maqsad=randsample(1:numel(Structure(k).Group),ceil(Rm*numel(Structure(k).Group)),'false');
                           for wi=1:numel(n_maqsad)                          
                               Structure(k).Group(n_maqsad(wi))=Structure(Node).Group(n_mabda(wi));
                           end
                        end
                    end
                    
                case 4 % R-R
                    Node=randi(numel(Structure));
                    n_mabda=randsample(1:numel(Structure(Node).Group),ceil(Rm*numel(Structure(Node).Group)),'false'); 
                    for k=1:numel(Structure)
                        if k~=Node
                           n_maqsad=randsample(1:numel(Structure(k).Group),ceil(Rm*numel(Structure(k).Group)),'false');
                           for wi=1:numel(n_maqsad)                          
                               Structure(k).Group(n_maqsad(wi))=Structure(Node).Group(n_mabda(wi));
                           end
                        end
                    end
            end  % End of Star Topoligy
            
        case 3  % Full Mesh Topology
            switch policy
                case 1 %W-B
                    CopyPop=Structure;
                    for k=1:numel(Structure)
                        [~,n_mabda]=sort([CopyPop(k).Group.Cost]); 
                        for l=1:numel(Structure)
                           if k~=l
                               [~,n_maqsad]=sort([Structure(l).Group.Cost]); 
                               for wi=1:ceil(Rm*numel(Structure(l).Group))
                                   Structure(l).Group(n_maqsad(end+1-wi))=CopyPop(k).Group(n_mabda(wi));
                               end
                           end
                        end
                    end
                    
                case 2 %B-B
                    CopyPop=Structure;
                    for k=1:numel(Structure)
                        [~,n_mabda]=sort([CopyPop(k).Group.Cost]); 
                        for l=1:numel(Structure)
                           if k~=l
                               [~,n_maqsad]=sort([Structure(l).Group.Cost]); 
                               for wi=1:ceil(Rm*numel(Structure(l).Group))
                                   Structure(l).Group(n_maqsad(wi))=CopyPop(k).Group(n_mabda(wi));
                               end
                           end
                        end
                    end
                    
                case 3 %R-B
                    CopyPop=Structure;
                    for k=1:numel(Structure)
                        [~,n_mabda]=sort([CopyPop(k).Group.Cost]); 
                        for l=1:numel(Structure)
                           if k~=l
                               n_maqsad=randsample(1:numel(Structure(l).Group),ceil(Rm*numel(Structure(l).Group)),'false'); 
                               for wi=1:numel(n_maqsad)
                                   Structure(l).Group(n_maqsad(end+1-wi))=CopyPop(k).Group(n_mabda(wi));
                               end
                           end
                        end
                    end
                    
                case 4 %R-R
                    CopyPop=Structure;
                    for k=1:numel(Structure)
                        n_mabda=randsample(1:numel(Structure(k).Group),ceil(Rm*numel(Structure(k).Group)),'false');  
                        for l=1:numel(Structure)
                           if k~=l
                               n_maqsad=randsample(1:numel(Structure(l).Group),ceil(Rm*numel(Structure(l).Group)),'false'); 
                               for wi=1:numel(n_maqsad)
                                   Structure(l).Group(n_maqsad(end+1-wi))=CopyPop(k).Group(n_mabda(wi));
                               end
                           end
                        end
                    end
            end
    end
    Strct =Structure;
    
end

