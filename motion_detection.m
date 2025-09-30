function [motionDetected, motionPerPixel] = motion_detection(image, model)
    % Preprocessing
    image = rgb2gray(im2double(image));
    
    % Mask out tree regions
    a = 62;
    image(1:a,1:352) = 0;
    for j = a:1:a+20
        for k=1:1:352
            if 1/4*k+35>j
                image(j,k) = 0;
            end
        end
    end
    image(130:155,220:352) = 0;

    % 3x3 averaging filter
    w = ones(3)/9;
    image(:,:) = imfilter(image(:,:), w, 'replicate');

    % Normalized squared deviation from the background model (for every pixel)
    motionPerPixel = ((image-model.mu)./model.sigma).^2;
    
    % Metric quantifying motion within the image
    motionSum = sum(motionPerPixel, "all")/(size(image,1)*size(image,2));

    if motionSum > model.T % Comparison with model threshold
        motionDetected = true;
    else
        motionDetected = false;
    end
end