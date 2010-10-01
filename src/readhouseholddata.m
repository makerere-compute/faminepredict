fid = fopen('famine_aug_2010.csv');
C = textscan(fid,'%d%d%d%d%d%d%d%s%s%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','Delimiter',',');
sex = C{2};
maritalstatus = C{4};
education  = C{6};
occupation = floor(C{7}/100);
district = C{9};
substrata = C{10};
landsize = C{11};
livestock = C{12};
hhsize = C{13};
caloriesseason1 = C{17};
caloriesseason2 = C{18};
prodseason1 = C{20};
prodseason2 = C{21};
income = C{23};
hhlabourseason1 = C{24};
hhlabourseason2 = C{25};
agricshock = C{27};
age = C{28};
distancetogarden = C{29};
distancetoroad = C{30};
famine = C{31};


load rfe_struct;
load ndvi_struct;

nrecords = size(C{1},1);
districtimagefiles = dir('~/data/landsat/districts/*.jpg');

%wronglandsizeidx = find(landsize>5);
%landsize(wronglandsizeidx) = landsize(wronglandsizeidx)/100;

badrecords = [];
%badrecords = [badrecords; find(caloriesseason1<500)];
%badrecords = [badrecords; find(caloriesseason1>10000)];
%badrecords = [badrecords; find(caloriesseason2<500)];
%badrecords = [badrecords; find(caloriesseason2>10000)];
badrecords = find((prodseason1 ./ prodseason2) < (1/10));
badrecords = [badrecords; find((prodseason1 ./ prodseason2) > 10)];
badrecords = find((caloriesseason1 ./ caloriesseason2) < (1/10));
badrecords = [badrecords; find((caloriesseason1 ./ caloriesseason2) > 10)];
%badrecords = [badrecords; find(isnan(prodseason1))];
%badrecords = [badrecords; find(isnan(prodseason2))];
%badrecords = [badrecords; find(prodseason1==0)];
%badrecords = [badrecords; find(prodseason2==0)];
badrecords = [badrecords; find(landsize>5)];
badrecords = [badrecords; find(prodseason1>5000)];
badrecords = [badrecords; find(prodseason2>5000)];
badrecords = [badrecords; find(isnan(caloriesseason1))];

goodrecords = setdiff(1:nrecords,badrecords);

vegindex = zeros(nrecords,72);
rfeindex = zeros(nrecords,72);

%district = cell(nrecords,1);
%distrows = [t];

for i=1:nrecords
    d = district{i};
    vegindex(i,:) = ndvi.(d);
    rfeindex(i,:) = rfe.(d);
end

sex = sex(goodrecords);
maritalstatus = maritalstatus(goodrecords);
education  = education (goodrecords);
occupation = occupation(goodrecords);
age = age(goodrecords);
hhsize = hhsize(goodrecords);
landsize = landsize(goodrecords);
distancetogarden = distancetogarden(goodrecords);
distancetoroad = distancetoroad(goodrecords);
caloriesseason1 = caloriesseason1(goodrecords);
caloriesseason2 = caloriesseason2(goodrecords);
prodseason1 = prodseason1(goodrecords);
prodseason2 = prodseason2(goodrecords);
livestock = livestock(goodrecords);
income = income(goodrecords);
agricshock = agricshock(goodrecords);
hhlabourseason1 = hhlabourseason1(goodrecords);
hhlabourseason2 = hhlabourseason2(goodrecords);
famine = famine(goodrecords);
vegindex = vegindex(goodrecords,:);
rfeindex = rfeindex(goodrecords,:);
district = district(goodrecords);
substrata = substrata(goodrecords);
nrecords = length(goodrecords);

districtlist = fields(rfe);
ndistricts = size(districtlist,1);

districtidx = zeros(nrecords,1);
for i=1:ndistricts
    districtidx(find(strcmp(district,districtlist{i}))) = i;   
end

