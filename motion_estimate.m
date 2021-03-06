
% Need a list of all folders
flist = filenames(fullfile('/Users/zacharyanderson/Documents/ACNlab/MWMH/projects/b1108/data/MWMH/bids_directory/sub-*/ses-1/dwi'));

for i = 1:length(flist)
    % spm is a little weird about how it wants folders input
    cd(flist{i})
    % select images to estimate motion for. This will work on the data on
    % quest. The next three lines are spm commands that output motion
    % estimates and motion corrected images. They take ~5-10 min per sub.
    % Not ideal. They may also take longer on quest. I'd probably submit
    % each job individually to a different node on the short partition.
    %P = spm_select('ExtList', pwd, '^sub', 1:69);
    %spm_realign(P);
    %spm_reslice(P);
    
    % Get the filename for the appropriate motion file
    file = filenames('rp*');
    
    % This is my way of calculating FD based on Power (2012). There's
    % probably a better/more concise way.
    dat = readmatrix(file{1});
    dat(:,4:6) = dat(:,4:6) * 50;
    
    for j = 2:length(dat)
        dx(j,1) = dat(j-1,1) - dat(j,1);
        dy(j,1) = dat(j-1,2) - dat(j,2);
        dz(j,1) = dat(j-1,3) - dat(j,3);
        dp(j,1) = dat(j-1,4) - dat(j,4);
        dr(j,1) = dat(j-1,5) - dat(j,5);
        dy(j,1) = dat(j-1,6) - dat(j,6);
    end
    
    FD_temp = abs(dx) + abs(dy) + abs(dz) + abs(dp) + abs(dr) + abs(dy);
    FD(i,1) = mean(FD_temp);
    
    writematrix(FD,'/Users/zacharyanderson/Documents/GitHub/MWMH_motion_DTI/FD_ses1.csv')
end
