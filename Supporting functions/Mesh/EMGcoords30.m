function [X,Y,Z]=EMGcoords30()

% including the RA and IC
Xd=[-0.199 0.199 -0.241 0.241 -0.208 0.208 -0.141 0.141 -0.165 0.165 -0.157 0.157 -0.127 0.127 -0.141 0.141 -0.0715 0.0715 -0.096 0.096 -0.120 0.120 -0.18 0.18 -0.22 0.22 -0.25 0.25 -0.255 0.255];
Yd=[-0.010 -0.010 -0.090 -0.090 -0.030 -0.030 -0.120 -0.120 0.035 0.035 -0.090 -0.090 0.070 0.070 -0.120 -0.120 -0.105 -0.105 0.085 0.085 -0.038 -0.038 -0.008 -0.008 -0.02 -0.02 -0.062 -0.062 -0.02 -0.02];
Zd=[0.330 0.330 0.260 0.260 0.330 0.330 0.289 0.289 0.500 0.500 0.596 0.596 0.650 0.650 0.93 0.93 1.228 1.228 1.350 1.350 1.454 1.454 1.4 1.4 1.4 1.4 1.191 1.191 1.275 1.275];

Xnd=[-0.199 -0.199 -0.210 -0.210 -0.199 -0.199 -0.113 -0.113 -0.165 -0.165 -0.125 -0.125 -0.127 -0.127 -0.113 -0.113 -0.143 -0.143 -0.096 -0.096 -0.140 -0.140 -0.265 -0.265 -0.265 -0.265 -0.29 -0.29 -0.265 -0.265];
Ynd=[-0.005 -0.005 -0.112 -0.112 -0.005 -0.005 -0.129 -0.129 0.035 0.035 -0.090 -0.090 0.080 0.080 -0.129 -0.129 -0.110 -0.110 0.090 0.090 -0.045 -0.045 -0.036 -0.036 -0.036 -0.036 -0.055 -0.055 -0.036 -0.036];
Znd=[0.330 0.330 0.270 0.270 0.330 0.330 0.300 0.300 0.541 0.541 0.591 0.591 0.629 0.629 0.300 0.300 1.228 1.228 1.350 1.350 1.460 1.460 1.314 1.314 1.314 1.314 1.191 1.191 1.314 1.314];

X=[Xd,Xnd];
Y=[Yd,Ynd];
Z=[Zd,Znd];