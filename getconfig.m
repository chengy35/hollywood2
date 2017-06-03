function [video_data_dir,video_dir,fullvideoname, videoname,vocabDir,featDir_FV,featDir_LLC,descriptor_path,actionName] = getconfig()
    vocabDir = '/mnt/remote/Hollywood2Data/Vocab'; % Path where dictionary/GMM will be saved.
    featDir_LLC = '/mnt/remote/Hollywood2Data/llc/feats'; % Path where features will be saved
    featDir_FV = '/mnt/remote/Hollywood2Data/fv/feats'; % Path where features will be saved
    descriptor_path = '/mnt/remote/Hollywood2Data/descriptor/'; % change paths here 
    
    if /mntexist(fullfile(descriptor_path),'dir')
            mkdir(fullfile(descriptor_path));
    end

    video_dir = '/mnt/remote/Hollywood2/';
    video_data_dir = '/mnt/remote/Hollywood2Data/';
    load('./train_test_split.mat');
    
    for i = 1 : length(fnames)
        fullvideoname{i,1}=fullfile(video_dir,sprintf('%s.avi',fnames{i}));
        videoname{i,1} = fnames{i};
    end
    actionName = {'AnswerPhone','DriveCar','Eat','FightPerson','GetOutCar','HandShake','HugPerson','Kiss','Run','SitDown','SitUp','StandUp'};       
end