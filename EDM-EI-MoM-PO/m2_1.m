%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         阻抗矩阵可视化                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%结果预期
%        | .                |
%        |    .             |
%        |       .          |
%        |          .       |
%        |             .    |
%        |                . |
%
%
clear;
clc
load('Z_MOM_1.mat');
c = imag(Z_MOM_1)*sqrt(-1);
d = 1-c./max(max(c));
imshow(d);