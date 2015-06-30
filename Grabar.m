
clear;

msjNombre = 'Ingrese el nombre del archivo para la grabación: ';
msjIteraciones = 'Ingrese el número de ensayos: ';

Fs=8000;
bits=16;
nChannels=1;
T = 2;

recorder = audiorecorder(Fs,bits,nChannels);
fileName = input(msjNombre, 's');
itNum = input(msjIteraciones);

for itActual = 1:1:itNum
  input(strcat('Presione Enter para comenzar a grabar, iteración: ',num2str(itActual)));    
  disp('Proceso de grabación iniciado');
  recordblocking(recorder, 2);
  disp('Grabación Concluida :P');
  play(recorder);
  audioData = getaudiodata(recorder,'double');  
  %plot(audioData);
  exitName = strcat(fileName,'-',num2str(itActual),'.wav');  
  %disp(itActual);
  %disp(itNum);
  %disp(exitName);
  audiowrite(exitName,audioData,Fs); 
end




