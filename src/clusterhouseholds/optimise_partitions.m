%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIND_OPTIMAL_PARTITIONS: cluster households into groups which are specific %
% in terms of production.                                                    %
% To run, first read in household demographic data with READHOUSEHOLDDATA    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of clusters
k = 10;
% max number of iterations to optimise clusters
max_iter = 1000;
% whether to plot the optmisation progress
show_plot = 1;
% number of separate runs
ntrials = 1;
% values of the objective function at each iteration
scores = zeros(ntrials,max_iter,2);
% can decide whether to optmise greedily or with simulated annealing
use_stochastic_optimisation = 1

if ~exist('landsize')
    error('Use readhouseholddata.m to load demographic data.')
end

for itrial=1:ntrials

    disp(itrial)
    % household data read in from spreadsheet  
    data = [age landsize hhsize distancetogarden distancetoroad livestock income hhlabourseason1+hhlabourseason2];
    
    % random intialisation of partitions
    t = init_partitions(data,k);
    
    % initialise the objective function
    oldscore = inf;

    for it=1:max_iter
        % generate candidate partition from old partition
        tcandidate = candidate_partition(t);

        % calculate household membership for new clusters
        c = partitions_to_membership(tcandidate,data);

        % calculate objective score given by candidate partitioning
        [newscore,C] = membership_to_correlation_score(c,k,prodseason1+prodseason2,districtidx);

        % simple cooling schedule if simulated annealing is being used
        if use_stochastic_optimisation
            T = 1/it;
        else
            T = 0;
        end
    
        % decide whether to accept or reject.
        if newscore<(oldscore + rand*T) % add temperature
            t = tcandidate;
            hhclusterid = c;
            oldscore = newscore;
            if show_plot
                subplot(1,2,2);
                imagesc(C);
            end
        end

        % update the scores
        scores(itrial,it,use_stochastic_optimisation+1) = oldscore;
        if show_plot
            subplot(1,2,1);
            plot(scores(itrial,1:it,use_stochastic_optimisation+1));
            drawnow 
        end
    end
end
