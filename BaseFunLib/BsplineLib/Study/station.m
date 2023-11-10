clc;close all;clear all
a = [2011,2012,2013,2014,2015,2016,2017,2018,2019,2020];  %ºá×ø±ê
b = [-0.0027,-0.0424,-0.0546,-0.0105,-0.0101,-0.0593,-0.0054,-0.0532,-0.0015,-0.0709]; %KAMN
values = spcrv([[a(1) a a(end)];[b(1) b b(end)]],3);
plot(values(1,:),values(2,:),'g');
hold on
plot(a,b,'.g');
hold on 