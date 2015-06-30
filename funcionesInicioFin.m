
clear all;
clc;

[y, Fs] = audioread('noSonoro-3.wav');          
tamanoDeVentana = 128;
noDeVentanas = length(y)/tamanoDeVentana;

