% given a tree structure, print out the decision logic on the console

function disp_tree(t)

for i=1:t.nnodes
    str = [num2str(i) ': '];
    if t.isleaf(i)
        str = [str 'cluster ' num2str(t.clusterid(i))];
    else
        lowbranch = min(find(t.parents==i));
        highbranch = max(find(t.parents==i));
        str = [str 'if var(' num2str(t.decisionvar(i)) ') < ' num2str(t.decisionthresh(i)) ' then ' num2str(lowbranch) ' else ' num2str(highbranch)];
    end
    disp(str);
end

