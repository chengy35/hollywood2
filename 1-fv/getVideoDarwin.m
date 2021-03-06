function getVideoDarwin(fullvideoname,featDir_FV,descriptor_path)
    if ~exist(fullfile(featDir_FV,'wall'),'dir')
        mkdir(fullfile(featDir_FV,'wall'));
    end
    for i = 1:length(fullvideoname) % 1-16 actions
            [~,partfile,~] = fileparts(fullvideoname{i});
            allfeatFile = fullfile(featDir_FV,sprintf('/all/%d.mat',i));
            wFile = fullfile(featDir_FV,'wall',sprintf('%s.mat',partfile));  
            if exist(wFile,'file') == 2
                fprintf('%s exist! \n',wFile);
                continue;
            end
            fprintf('%s\n',allfeatFile);
            if exist(allfeatFile,'file') == 2
                timest = tic();
                data = dlmread(allfeatFile);
                data = reshape(data,dimension,size(data,1)/dimension)';
                w = genRepresentation(data,1);
                dlmwrite(wFile,w');
                clear data;
                clear w;
                timest = toc(timest);
                fprintf('%d/%d -->%s----> %1.2f sec\n',i,length(fullvideoname),wFile,timest);
            end
    end
end