This project contains code described in the paper:

Increased-specificity famine prediction using satellite observation data
J.A. Quinn, W. Okori and A. Gidudu, First Annual Symposium on Computing for Development (ACM DEV), 2010.

--------------------------------------------------

To run the experiments, there are three stages:

1. Import the data from csv and mat files:
src/readhouseholddata.m

2. Cluster households to form a partitioning tree:
src/clusterhouseholds/optimise_partitions.m

3. Export the data to Weka ARFF format:
src/export2weka.m

4. Import the data in Weka to perform classification experiments.

--------------------------------------------------

This source is provided under the Creative Commons Attribution 3.0 Unported License
http://creativecommons.org/licenses/by/3.0/
