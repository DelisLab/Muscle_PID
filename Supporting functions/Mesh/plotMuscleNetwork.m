function plotMuscleNetwork(width,nodesize,module,colour,bin)
% This function plots the muscle network with the given properties given in
% figureMuscleNetwork
%
% INPUT
% width         the width of the edges
%               [muscles x muscles]
% muscles       number of muscles
% nodesize      the size of the nodes
%               [muscles]
% module        results of the optimal community structure
%               [muscles]
% colour        the colour for the different modules
%               default: colour={[0.6 0 1] [1 0.4 0.4] [1 0 0] [0 1 1] [0 0 1] [0 0.6 1] [1 0.7 0.7] [0 0 0.4]};
%               number of colours >= number of modules
% bin           binary network = 1; default: weighted network = 0;
%               for the thickness of the edges of the muscle network
%
% Jennifer Kerkman - Vrije Universiteit Amsterdam
% j.n.kerkman@vu.nl
% 12 May 2016

if nargin<5 || isempty(bin), bin=0; end
if nargin<4 || isempty(colour), colour={[1 0 0] [0 0 1] [0 1 1] [0 1 0] [0 0 0.4] [0 0.6 1] [1 0.7 0.7] [0.5 0.5 0.5] [0.85 0.85 0.85] [0.8 0.8 0.8] [0.95 0.95 0.95] [0.99 0.95 0.90] [0.82 0.95 0.6]...
        [1 0.25 0.5] [0.3 0.4 0.5] [0.25 0.5 0.75] [0.1 0.9 0.8] [0.35 0.45 0.65] [0.99 0.69 0.69]}; end
if nargin<3 || isempty(module), module=zeros(size(width,1),1); end
if nargin<2 || isempty(nodesize), nodesize=repmat(10,9,1); end

if length(nodesize)==36
    [X,Y,Z]=EMGcoords36;
elseif length(nodesize)==8
    [X,Y,Z]=EMGcoords8;
elseif length(nodesize)==11
    [X,Y,Z]=EMG_coords11;
elseif length(nodesize)==30
     [X,Y,Z]=EMGcoords30;
elseif length(nodesize)==9
    [X,Y,Z]=EMGcoords9;                         % the coordinates of the position of the muscles/nodes
elseif length(nodesize)==40
    [X,Y,Z]=EMGcoords40;
end
plotPerson; % plots the body file

% view(180,5)
% lightangle(210,15)
% material dull
hold on

if bin==1
    width=width/5;
end


Z = Z+0.035;

% LINES
for i=1:size(width,1)       % 1:number of muscles
    for j=1:size(width,2)
        if width(i,j)~=0
            if module(1)==0
                line(X([i,j]),Y([i,j])+0.4,Z([i,j]),'LineWidth',width(i,j),'Color','k');
            elseif module(1)~=0 && module(i) == module(j) 
                line(X([i,j]),Y([i,j])+0.4,Z([i,j]),'LineWidth',width(i,j),'Color','k');
%                 line(X([i,j]),Y([i,j]),Z([i,j]),'LineWidth',width(i,j),'Color',colour{module(i)});
            else
                line(X([i,j]),Y([i,j])+0.4,Z([i,j]),'LineWidth',width(i,j),'Color','k');
            end
        end
    end
end

% MARKERS
for i=1:size(width,1)       % 1:number of muscles
    if module==0;
        plot3(X(i),Y(i)+0.5,Z(i),'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',nodesize(i))
    else
        plot3(X(i),Y(i)+0.5,Z(i),'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',colour{module(i)},'MarkerSize',nodesize(i))
    end
end

view(180,5)
axis vis3d

hold off;

% li=lightangle(50,20); 
% li=lightangle(50,-20); 
% lighting phong