function [gmm] = getGMMAndBOW(fullvideoname,vocabDir,descriptor_path,video_dir,totalnumber,gmmSize)
    pcaFactor = 0.5;
    totalnumber = 256000;
    gmmsize = 256;
    
    if ~exist(fullfile(vocabDir,'mbh'),'dir')
        mkdir(fullfile(vocabDir,'mbh'));
    end
    vocabDir = [vocabDir '/mbh/'];

    sampleFeatFile = fullfile(vocabDir,'featfile.mat');
    modelFilePath = fullfile(vocabDir,'gmmvocmodel.mat');
    if exist(modelFilePath,'file')
        load(modelFilePath);
        return;
    end
    start_index = 1;
    end_index = 1;
    if ~exist(sampleFeatFile,'file') 
        mbhAll = zeros(totalnumber,96*2);
        num_videos = size(fullvideoname,1);
        num_samples_per_vid = round(totalnumber / num_videos);
        warning('getGMMAndBOW : update num_videos only to include training videos')
        for i = 1:num_videos       
            timest = tic();        
            [~,partfile,~] = fileparts(fullvideoname{i});
            descriptorFile = fullfile(descriptor_path,sprintf('%s.mat',partfile));      
                if exist(descriptorFile,'file')
                    load(descriptorFile);
                else
                    fprintf('%s not exist !!!',descriptorFile);
                    [obj,trj,hog,hof,mbhx,mbhy] = extract_improvedfeatures(fullvideoname{index}) ;
                    save(descriptorFile,'obj','trj','hog','hof','mbhx','mbhy');
                end
                mbhx = sqrt(mbhx);mbhy = sqrt(mbhy);
                rnsam = randperm(size(mbhx,1));
                if numel(rnsam) > num_samples_per_vid
                    rnsam = rnsam(1:num_samples_per_vid);
                end
                end_index = start_index + numel(rnsam) - 1;
                mbhAll(start_index:end_index,:) = [mbhx(rnsam,:) mbhy(rnsam,:)];
                start_index = start_index + numel(rnsam);        
                timest = toc(timest);
                fprintf('%d/%d -> %s --> %1.2f sec\n',i,num_videos,fullvideoname{(i)},timest);  
        end

        if end_index ~= totalnumber
            mbhAll(end_index+1:totalnumber,:) = [];
        end
            fprintf('start computing pca\n');
            gmm.pcamap.mbh = princomp(mbhAll);
            fprintf('start saving descriptors\n');
            save(sampleFeatFile,'mbhAll','gmm','-v7.3');
    else
        load(sampleFeatFile);
    end

    fprintf('start create gmm \n');
    mbhProjected = mbhAll * gmm.pcamap.mbh(:,1:size(gmm.pcamap.mbh,1)*pcaFactor);
    [gmm.means.mbh, gmm.covariances.mbh, gmm.priors.mbh] = vl_gmm(mbhProjected', gmmsize);
    fprintf('start saving gmm\n');
    save(modelFilePath,'gmm');     
end