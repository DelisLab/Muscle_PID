function h=plotPerson(file)

if nargin<1 || isempty(file)
%     file='person1_standing.bod';
file='person1_standing_orig.bod';
end
S=load(file,'-mat');

P = S.P; t = S.t;
P(:,1)=detrend(P(:,1),'constant');
P(:,2)=detrend(P(:,2),'constant');
P(:,3)=P(:,3)-min(P(:,3));

width = max(P(:,1))-min(P(:,1));
height = max(P(:,3))-min(P(:,3));
set(gcf,'units','centimeters','position',[0 0 18/height*width 18]);


Zok = ones(size(P(:,3)));
%h=patch('Faces', t, 'Vertices', P, 'FaceColor', [1 0.75 0.65], 'EdgeColor', [0.55 0.55 0.55],'SpecularColorReflectance',0,'SpecularExponent',50,'FaceAlpha',0.25,'edgealpha',0.25);

colormap([0.7 0.7 0.7])

h_surf = trisurf(t,P(:,1),P(:,2),P(:,3),Zok,'edgecolor',[0.5 0.5 0.5],'FaceColor','flat','FaceLighting','phong','edgealpha',0.4);
% h_surf = trisurf(t,P(:,1),P(:,2),P(:,3),Zok,'edgecolor','none','FaceColor','flat','FaceLighting','flat');

axis 'equal'; axis 'tight'; axis 'off'
set(gca, 'YDir','normal');

