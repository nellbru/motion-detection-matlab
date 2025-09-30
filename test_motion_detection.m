clear
clc

load('model.mat'); % Load model parameters
load('labels.mat'); % Load ground truth
motion = zeros(1,1200);
realMotionCount = 0;
modelMotionCount = 0;
diff = 0;

for i = 1:1200 % Test on the full dataset
    image = imread(sprintf('./data/frame%d.jpg',i));
    
    [motionDetected, motionPerPixel] = motion_detection(image, model);
    motion(i) = sum(motionPerPixel(:));
    
    figure(1)
    subplot(2,2,1)
    imshow(image)
    title('Source image');
    
    subplot(2,2,2)
    imshow(log(motionPerPixel+1),[])
    title('Motion per pixel (log scale)') % Metric quantifying motion pixel per pixel
    colorbar();

    if motionDetected
        xlabel('Motion detected','Color','red');
    else
        xlabel('No motion detected','Color','black');
    end
    
    subplot(2,1,2);
    plot(log(motion+1));
    title('Motion over time'); % Metric quantifying motion within the whole image
    xlabel('Time'); ylabel('Motion (log scale)');
    drawnow
    
    if motionDetected
        modelMotionCount = modelMotionCount+1;
    end

    if labels(i)
        realMotionCount = realMotionCount+1;
    end

    if motionDetected ~= labels(i)
        diff = diff+1;
    end
end

realMotionCount
modelMotionCount
diff
accuracy = (1200-diff)/1200