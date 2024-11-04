clc;
clear all;
close all;

%% zbiory danych 
x1 = randn(2,100);
x2 = randn(2,100) + 8;
x3 = randn(2,100);
x3(1,:) = x3(1,:) + 5;
x = [x1, x2, x3];
D = [ones(1,100), 2*ones(1,100), 3*ones(1,100)];

figure;
gscatter(x(1,:), x(2,:), D);
title('zbiory danych');

%% trenowanie
warstwy = [3, 1];
net = selforgmap(warstwy, 'topologyFcn', 'hextop', 'distanceFcn', 'linkdist'); %hextop, gridtop, randtop  |  dist, mandist, boxdist, linkdist
net.trainParam.showWindow = false;
net = train(net, x);

% Tworzenie permutacji wierszy macierzy wag
num_neurons = size(net.IW{1}, 1);
all_permutations = perms(1:num_neurons);
n = size(all_permutations, 1);

% Inicjalizacja do przechowywania najlepszych wyników
accuracy_all = zeros(n, 1);
error_all = zeros(n, 1);
best_accuracy = 0;

for i = 1:n
    % Zastosowanie permutacji wierszy
    permuted_indices = all_permutations(i, :);
    permuted_IW = net.IW{1}(permuted_indices, :);

    % Obliczenie odległości i klasyfikacji
    d = dist(x', permuted_IW');
    [~, ind] = min(d, [], 2);
    
    % Obliczenie dokładności klasyfikacji
    accuracy_all(i) = sum(ind' == D) / 300 * 100;
    error_all(i) = sum(ind' ~= D) / 300 * 100;

    % Aktualizacja najlepszego wyniku, jeśli nowa permutacja jest lepsza
    if accuracy_all(i) > best_accuracy
        best_accuracy = accuracy_all(i);
        best_permutation = permuted_IW;
        best_class_assignments = ind;
    end
end

% Ustawienie najlepszej permutacji w sieci
net.IW{1} = best_permutation;

% Wizualizacja wyników
figure;
hold on;
gscatter(x(1,:), x(2,:), best_class_assignments');
plotsom(net.IW{1}, net.layers{1}.distances);
axis normal;
title('Najlepsza permutacja klas');
hold off;
