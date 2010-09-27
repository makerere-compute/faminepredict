% Given a partitioning tree and a set of data vectors, return the cluster
% assignment for each vector.
%
% Inputs:
% T: partitioning tree
% DATA: NxD matrix, containing N rows of D-dimensional data

function c = partitions_to_membership(t,data)

nrows = size(data,1);
% cluster assignments
c = zeros(nrows,1);

% a few optimisations for speed
decisionnodes = find(t.isleaf==0);
lowbranchidx = zeros(t.nnodes,1);
highbranchidx = zeros(t.nnodes,1);
for i=decisionnodes'
    lowbranchidx(i) = min(find(t.parents==i));
    highbranchidx(i) = max(find(t.parents==i));
end

percentiles = t.percentiles;
decisionthresh = t.decisionthresh;
isleaf = t.isleaf;
treedecisionvar = t.decisionvar;
clusterid = t.clusterid;

% for all rows, find the path to tree leaf
for i=1:nrows
    foundcluster = 0;
    currnode = 1;
    while ~foundcluster
        % if we've reached a leaf, then can make the cluster assignment
        if isleaf(currnode)
            foundcluster = 1;
            c(i) = clusterid(currnode);
        % otherwise move to the next level down
        else
            decisionvar = treedecisionvar(currnode); 
            val = data(i,decisionvar);

            % move appropriately to the left (lower) child or right (upper) child node
            if (decisionthresh(currnode)>0) && val < percentiles(decisionvar,decisionthresh(currnode))
                currnode = lowbranchidx(currnode);
            else
                currnode = highbranchidx(currnode);
            end
        end 
    end
end

