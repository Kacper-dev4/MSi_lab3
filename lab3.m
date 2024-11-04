clear all 
clc

data = load("Data_microarray.mat");
x = load("X.mat");
x = x.x;

data = data.Data;

% x1 = randn(2,100);
% 
% x2 = randn(2,100)+8;
% 
% x3 = randn(2,100);
% x3(1,:) = x3(1,:)+5;
% 
% x = [x1,x2,x3];
% 
% save('X.mat','x')

D = [ones(1,100),ones(1,100)+1,ones(1,100)+2];

% newson
% selforgmap

 net = selforgmap([3,1],'topologyFcn','hextop', 'distanceFcn', 'linkdist');
 net.trainParam.showWindow = false;
 net = train(net,x);


% Tworzenie permutacji wierszy macierzy wag
liczbaNeuronow = size(net.IW{1}, 1);
permutacje = perms(1:liczbaNeuronow);


[ile,~] = size(permutacje);



najwyszaJakosc = 0;

error = ones(1,ile);

 for i=1:ile
 
 permutowaneIndeksy = permutacje(i,:);
 permutacjaIW = net.IW{1}(permutowaneIndeksy,:);

 d = dist(x',permutacjaIW');
 [odle, indeks] = min(d,[],2);

 error(i) = sum(indeks' ~= D) / (300) * 100;
 jakosc = sum(indeks' == D)/(300) * 100; % accuracy, czy coś
 
    if jakosc > najwyszaJakosc
        najwyszaJakosc = jakosc;
        najlepszyIndeks = indeks;
    end

 end
% hextop
% gridtop
% randtop
figure
 hold on
 plot(x(1,1:100),x(2,1:100),'*','Color','r');
 plot(x(1,101:200),x(2,101:200),'*','Color','g');
 plot(x(1,201:300),x(2,201:300),'*','Color','b');
 plotsom(net.IW{1,1}, net.layers{1}.distances);
 hold off

% dist 
% mondist
% hexdist

% D2 = [ones(1,100),ones(1,100)+1,ones(1,100)+2,ones(1,100)+3,ones(1,100)+4];
% 
% net2 = selforgmap([5,1],'topologyFcn','hextop', 'distanceFcn', 'linkdist');
% net2.trainParam.showWindow = false; 
%  net2 = train(net2,x);
% 
% % || net = train(net,x);
% 
%  d2 = dist(x',net2.iw{1}');
%  [~, indeks2] = min(d2,[],2);
%  %error = sum(K ~= A') / (300) * 100;
% 
%  jakosc2 = sum(indeks2 ~= D2')/(300) * 100; % accuracy, czy coś
% 
% % hextop
% % gridtop
% % randtop
% figure
%  hold on
%  plot(x(1,1:100),x(2,1:100),'*','Color','r');
%  plot(x(1,101:200),x(2,101:200),'*','Color','g');
%  plot(x(1,201:300),x(2,201:300),'*','Color','b');
%  plotsom(net2.IW{1,1}, net2.layers{1}.distances);
% 
%  indeks2Podmiana = indeks2;
% 
%  indeks2Podmiana(indeks2Podmiana == 2) = 1;
%  indeks2Podmiana(indeks2Podmiana == 3) = 2;
%  indeks2Podmiana(indeks2Podmiana == 4) = 2;
%  indeks2Podmiana(indeks2Podmiana == 5) = 1;
