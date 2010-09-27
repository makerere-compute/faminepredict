% Given a NxD dataset, containing N rows of D-dimensional data
% and a number of desired clusters, generate a random initial 
% partitioning tree.
function t = init_partitions(data,k)

nvars = size(data,2);

% initialise the partitioning tree
t = struct;

% for each node, specify which is the parent node
t.parents = [0 reshape([1:(k-1);1:(k-1)],1,(k-1)*2)];
% number of nodes
t.nnodes = length(t.parents);
% whether each node is a leaf
t.isleaf = ones(t.nnodes,1);
t.isleaf(unique(t.parents(2:end))) = 0;
% cluster ids for leaf nodes
t.clusterid = cumsum(t.isleaf);
% number of dimensions in input data
t.nvars = nvars;
% number of clusters
t.nclusters = k;

% calculate the percentile values for each data dimension
t.percentiles = zeros(nvars,100);
for i=1:nvars
    t.percentiles(i,:) = [-inf prctile(data(:,i),0:(100/97):100) inf];
end

% decide on the decision variables at each node
t.decisionvar = zeros(t.nnodes,1);
t.decisionthresh = zeros(t.nnodes,1);
for i=1:t.nnodes
    if ~t.isleaf(i)
        t.decisionvar(i) = ceil(rand*nvars);
    end
end

% calculate a threshold for each node
for i=1:t.nnodes
    rangemin = 0;
    rangemax = 100;

    % get the unique path from root to node
    atroot = (i==1);
    path = i;
    if i<t.nnodes
        nextnode = i;
        while ~atroot
            thisnode = nextnode;
            nextnode = t.parents(thisnode);
            path = [nextnode path];
            atroot = (nextnode==1);
        end
    end

    % now get the limiting range for each node
    for j=1:(length(path)-1)
        if t.decisionvar(j) == t.decisionvar(i)
            % find out if we are on the "less than" or the "greater than" branch
            lessthanbranchidx = min(find(t.parents==path(j)));
            lessthan = (lessthanbranchidx==path(j+1));
            val = t.decisionthresh(path(j));
            % check we're not violating any conditions from higher-up nodes
            if lessthan
                assert(rangemax>val);
                rangemax = val;
            else
                assert(rangemin<val);
                rangemin = t.decisionthresh(path(j));
            end
        end
    end
        
    % sample a threshold
    t.decisionthresh(i) = round(rand*(rangemax-rangemin)) + rangemin;
end

