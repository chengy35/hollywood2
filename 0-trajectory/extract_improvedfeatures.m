% TODO: Change the paths and improved trajectory binary paths
function [obj,trj,hog,hof,mbhx,mbhy] = extract_improvedfeatures(videofile)   
    [~,nameofvideo,~] = fileparts(videofile);
    txtFile = fullfile('~/remote/Data/temp/tmpfiles',sprintf('%1.6f',tic())); % path of the temporary file
    % Here the path should be corrected
    system(sprintf('~/lib/improved_trajectory/debug/DenseTrackStab %s > %s',videofile,txtFile));
    data = dlmread(txtFile);
    delete(txtFile);
    obj = data(:,1:10);
    trj = data(:,11:40);
    hog = data(:,41:41+95);    
    hof = data(:,41+96:41+96+107);
    mbhx  = data(:,41+96+108:41+96+108+95);
    mbhy  = data(:,41+96+108+96:41+96+108+96+95);
end

