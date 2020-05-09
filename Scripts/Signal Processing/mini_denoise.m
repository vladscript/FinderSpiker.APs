% Function to denoise signal bye wavelet analysys
% It use the 'sym8' and the degree increases
% until the autocorrelation finds a local minimum
% Input:
%   xd: signal
% Ouput
%   xdenoised: denoised signal
%   noisex:     noise=xd-xdenoised
function [xdenoised,noisex]=mini_denoise(xd)
    dbw=1;          % Degree (Order )Wavelet
    gradacf=-10;
    acf_pre=1;
    ondeleta='sym8'; % Sort of Wavelet
    fprintf('>>Denoising:')
    while ~or(gradacf>=0,dbw>9)
        fprintf('.');
        %         [xdenoised,~,~,~,~] = cmddenoise(xd,ondeleta,dbw);
        xdenoised=waveletdenoise(xd,ondeleta,dbw);
        noise=xd-xdenoised;
        acf=autocorr(noise,1);
        acf_act=abs(acf(end));
        gradacf=acf_act-acf_pre;
        acf_pre=acf_act;    % update ACF value
        dbw=dbw+1;          % Increase wavelet level
    end
    fprintf('done.\n');
    dbw_opt=dbw-2; % Beacuse it detected +1 and increased it anyway +1
    %     [xdenoised,~,~,~,~] = cmddenoise(xd,ondeleta,dbw_opt);
    xdenoised=waveletdenoise(xd,ondeleta,dbw_opt);
    noisex=xd-xdenoised;
end    