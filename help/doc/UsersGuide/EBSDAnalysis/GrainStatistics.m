%% Working with Grains
% How to index grains and access shape properties.
%
%% Open in Editor
%
%% Contents
%
%% 
% Grains have several intrinsic properties, which can be used for
% statistical, shape as well as for spatial analysis
%
%%
% Let us first import some EBSD data and reconstruct grainss

plotx2east
mtexdata forsterite
ebsd = ebsd(inpolygon(ebsd,[5 2 10 5]*10^3));
grains = calcGrains(ebsd)

plot(ebsd)
hold on
plotBoundary(grains,'linewidth',2)
hold off


%% Accessing individual grains
% The variabe |grains| is essentially a large vector of grains. Thus when
% applying a function like <Grain2d.area.html area> to this variabe we
% obtain a vector of the same lenght with numbers representing the area of
% each grain

grain_area = area(grains);

%%
% As a first rather simple application we could colorize the grains
% according to their area, i.e., according to the numbers stored in
% |grain_area|. This can be done by the option |property|.

plot(grains,'property',grain_area)

%%
% As a second application we can ask for the largest grain within our data
% set. The maximum value and its position within a vector is found by the
% Matlab command |max|.

[max_area,max_id] = max(grain_area)

%%
% The number |max_id| is the position of the grain with maximum area within
% the variabe |grains|. We can access this specific grain by direct
% indexing

grains(max_id)

%%
% and so we can plot it

hold on
plotBoundary(grains(max_id),'linecolor','red')
hold off

%%
% Note that this way of addressing individuell grains can be generalized to
% many grains. E.g. assume we are interested in the largest 5 grains. Then
% we can sort the vector |grain_area| and take the indices of the 5 largest
% grains.

[sorted_area,sorted_id] = sort(grain_area,'descend');

large_grain_id = sorted_id(1:5);

hold on
plotBoundary(grains(large_grain_id),'linecolor','green','linewidth',1.5)
hold off


%% Indexing by a Condition 
% By the same syntax as above we can also single out grains that satisfy a
% certain condition. I.e., to access are grains that are at least half as
% large as the largest grain we can do

condition = grain_area > max_area/2;

hold on
plotBoundary(grains(condition),'linecolor','red','linewidth',1.5)
hold off

%%
% This is a very powerfull way of accessing grains as the condition can be
% build up using any grain property. As an example let us consider the
% phase. We can access it by the command <GrainSet.get.html get>

phase = get(grains,'phase');

%%
% Now we can access or grains of the first phase Forsterite by the
% condition

condition = phase == 1;
plot(grains(condition))

%%
% To make the above more directly you can use the mineral name for indexing

grains('forsterite')


%%
% Logical indexing allows also for more complex queries, e.g. selecting all
% grains perimeter larger then 6000 and at least 600 measurements within

condition = perimeter(grains)>6000 & grainSize(grains) >= 600;

selected_grains = grains(condition)

plot(selected_grains)

%% Indexing by orientation or position
% In order to select a grain by its spatial coordinates the command
% <GrainSet.findByLocation.html findByLocation> can be used

position = [12000,4000];

plot(grains);

hold on

plotBoundary(findByLocation(grains,position),'linewidth',2,'linecolor','r')

plot(position(1),position(2),'marker','s','markerfacecolor','k',...
  'markersize',10,'markeredgecolor','w')
hold off

%%
% In order to select all grains with a certain orientation once can use the
% command <GrainSet.findByOrientation.html findByOrientation>

 grains_selected = findByOrientation(grains('fo'),...
  orientation('Euler',350*degree,50*degree,100*degree,CS{1}),...
  10*degree)

plot(grains_selected)



%% Grain-size Analysis
% Lets go back to the grain size and analyze its distribution. TO this end
% we consider the complete data set.

mtexdata forsterite
grains = calcGrains(ebsd)

%%
% and compute the vector of grain areas

ar = area(grains);

%%
% The following script compute the distribution of grain areas within the
% data set.

% define the binning of the areas
bins = linspace(0,max(ar)+eps,15);

% find for each area the binId
[~,binId] = histc(ar,bins);

% compute the sum of areas belonging to the same bin
cumArea = zeros(1,numel(bins)-1);
for i = 1:numel(bins)-1
  cumArea(i) = sum(ar(binId == i)) ./ sum(ar);
end

% plot the result as a bar plot
binCenter = 0.5*(bins(1:end-1)+bins(2:end));
bar(binCenter,cumArea,'BarWidth',1)
xlim([bins(1),bins(end)])
xlabel('Grain Area')
ylabel('relative volume')


%%
% Beside the area there are various other geometric properties that can be
% computed for grains, e.g., the <Grain2d.perimeter.html perimeter>,
% the <GrainSet.diameter.html diameter>, the <Grain2d.equivalentradius.html
% equivalentradius>, the <Grain2d.equivalentperimeter.html
% equivalentperimeter>, the <Grain2d.aspectratio.html aspectratio>,
% and the <Grain2d.shapefactor.html shapefactor>. The following is a simple
% scatter plot of shapefactor against aspactratio to check for correlation.
%

sf = shapefactor(grains);
as = aspectratio(grains);

% the size of the dots corresponds to the area of the grains
scatter(sf, as, 50*ar./max(ar) )


%% Spatial Dependencies
% One interessting question would be, wether a polyphase system has
% dependence in the spatial arrangement or not, therefor we can count the
% transitions to a neighbour grain

ph = get(grains,'phase');

[J, T, p ] = joinCount(grains,ph)

