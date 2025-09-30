% Preprocessing
w = ones(3)/9; % 3x3 averaging filter

for i = 1200:-1:1 % The loop is reversed for performance
    f(:,:,i) = rgb2gray(im2double(imread(sprintf('./data/frame%d.jpg',i))));
    
    % Mask out tree regions
    a = 62;
    f(1:a,1:352,i) = 0;
    for j = a:1:a+20
        for k=1:1:352
            if 1/4*k+35>j
                f(j,k,i) = 0;
            end
        end
    end
    f(130:155,220:352,i) = 0;
    f(:,:,i) = imfilter(f(:,:,i), w, 'replicate');
end

% Model parameters (trained on 80% of the dataset)
mu = mean(f(1:240,1:352,1:960),3);
sigma = std(f(1:240,1:352,1:960),0,3);
sigma(sigma == 0) = 1; % Avoid division by zero
T = 0.15;

% Save model
model = struct();
model.mu = mu; % Mean
model.sigma = sigma; % Standard deviation
model.T = T; % Threshold
save model.mat model