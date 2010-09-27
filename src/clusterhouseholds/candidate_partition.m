% Perform a modification move on a partition tree. Moves include changing
% the threshold at a decision node, changing the variable being considered
% at a decision node, and swapping any two nodes. Returns a modified,
% consistent partitioning tree.

function tout = candidate_partition(t)

MOD_THRESH = 1;
MOD_CHG_VAR = 2;
MOD_SWAP_NODE = 3;

% Prior probabilities of different modification moves
padjustthresh = 60;
pchangevar = 20;
pswapnode = 20;

% Choose which type of move to performher to adjust threshold, swap var, swap nodes
rnd = rand*100;
if rnd<padjustthresh
    modificationtype = MOD_THRESH;
elseif rnd<(padjustthresh+pchangevar) 
    modificationtype = MOD_CHG_VAR;
else
    modificationtype = MOD_SWAP_NODE;
end

switch modificationtype

% Change the threshold on some decision node
case MOD_THRESH
    decisionnodes = find(t.isleaf==0);
    decisionnodes = decisionnodes(randperm(length(decisionnodes)));
    n = decisionnodes(1);

    % Calculate the allowable range for the threshold
    rangemin = 0;
    rangemax = 100;

    atroot = (n==1);
    path = n;
    nextnode = n;
    while ~atroot
        thisnode = nextnode;
        nextnode = t.parents(thisnode);
        path = [nextnode path];
        atroot = (nextnode==1);
    end

    % Now get the limiting range for each node
    for j=1:(length(path)-1)
        if t.decisionvar(path(j)) == t.decisionvar(n)
            % Find out if we are on the "less than" or the "greater than" branch
            lessthanbranchidx = min(find(t.parents==path(j)));
            lessthan = (lessthanbranchidx==path(j+1));
            val = t.decisionthresh(path(j));
            if lessthan
                assert(rangemax>val);
                rangemax = val;
            else
                assert(rangemin<val);
                rangemin = t.decisionthresh(path(j));
            end
        end
    end

    % Sample a threshold
    t.decisionthresh(n) = round(rand*(rangemax-rangemin)) + rangemin;
    
% Change the variable being considered at a decision node
case MOD_CHG_VAR
    decisionnodes = find(t.isleaf==0);
    decisionnodes = decisionnodes(randperm(length(decisionnodes)));
    n = decisionnodes(1);

    t.decisionvar(n) = ceil(rand*t.nvars); 

% Swap two nodes
case MOD_SWAP_NODE
    swappablenodes = 2:t.nnodes;
    swappablenodes = swappablenodes(randperm(length(swappablenodes)));
    n1 = swappablenodes(1);
    n2 = swappablenodes(2);
    % Change parents
    n1parent = t.parents(n1);
    n2parent = t.parents(n2);
    % But don't swap a parent and its child
    if (n1~=n2parent) && (n2~=n1parent)
        t.parents(n1) = n2parent;
        t.parents(n2) = n1parent;
    end
    % Adjust thresholds, which may now be inconsistent
    t = correct_tree_thresholds(t);
end

tout = t;
