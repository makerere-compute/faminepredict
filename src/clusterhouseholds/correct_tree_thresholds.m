% Given a partitioning tree structure, make sure the decision thresholds
% are consistent, resampling where necessary.
%
% Parameters: T, the partitioning tree to correct
%
% Output: Partitioning tree, with some parameter resampled if necessary
% to enforce consistency.

function tout = correct_tree_thresholds(t)

% the top-level function starts at the root.
tout = correct_tree_thresholds_range(t,1,zeros(t.nvars,1), ones(t.nvars,1)*100);

% as we recurse down the tree, we have tighter allowable variable ranges
function tout = correct_tree_thresholds_range(t,node,rangemin,rangemax)
if t.isleaf(node)
    tout = t;
else
    % check current threshold is inside the allowable range
    % if not then resample
    var = t.decisionvar(node);
    thresh = t.decisionthresh(node);

    if thresh<rangemin(var) || thresh>rangemax(var)
        thresh = round(rand*(rangemax(var)-rangemin(var))) + rangemin(var);
        t.decisionthresh(node) = thresh;
    end

    % update the allowable ranges for each variable at this point in the tree
    lowbranchidx = min(find(t.parents== node));
    highbranchidx = max(find(t.parents== node));
    
    rangemin_lowbranch = rangemin;
    rangemax_lowbranch = rangemax;
    rangemax_lowbranch(var) = thresh;

    rangemin_highbranch = rangemin;
    rangemax_highbranch = rangemax;
    rangemin_highbranch(var) = thresh;

    % recurse to each of the children nodes
    tout_low = correct_tree_thresholds_range(t,lowbranchidx,rangemin_lowbranch,rangemax_lowbranch);
    tout_high = correct_tree_thresholds_range(tout_low,highbranchidx,rangemin_highbranch,rangemax_highbranch);
    tout = tout_high;
end

