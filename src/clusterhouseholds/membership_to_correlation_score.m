% Take all the households in each cluster, and calculate mean 
% production for each district. Where there are no households
% in a cluster for a given district, use the mean.
% Return score and correlation matrix.
%
% Parameters:
% C: vector of cluster IDs for each household
% K: number of clusters
% PRODUCTION: vector of production levels for each household
% DISTRICTIDX: vector of district indices for each household
%
% Output:
% SCORE: The normalised objective function score
% C: The KxK correlation matrix

function [score,C] = membership_to_correlation_score(c,k,production,districtidx);

uniquedists = unique(districtidx);
ndistricts = length(uniquedists);
prodmatrix = zeros(ndistricts,k);

for district=1:length(uniquedists)
    
    % The index of the current district
    distidx = find(districtidx==uniquedists(district));

    for cluster=1:k
        % Identify the other households in this cluster
        clusteridx = find(c==cluster); 

        idx = intersect(clusteridx,distidx);

        % Mean production for a given cluster/district combination
        if ~isempty(idx)
            prodmatrix(district,cluster) = mean(production(idx));
        else
            prodmatrix(district,cluster) = mean(production(distidx));
        end
    end
end

% Find the correlation and normalise
C = corr(prodmatrix);
score = sum(sum(C))-k;
score = score / (k^2);


