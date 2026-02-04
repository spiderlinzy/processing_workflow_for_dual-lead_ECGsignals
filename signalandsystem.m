clear; clc; close all;
%1
load('ECG_data.mat');
if exist('M', 'var')
    ch1 = M(:, 1); 
    ch2 = M(:, 2);  
else
    error('未找到变量');
end
N = length(ch1);  
total_time = 120;   

%2
Fs = N / total_time;      
fprintf('心电信号采样率：%.1f Hz\n', Fs);

start_time = 10;          
end_time = start_time + 10; 
start_idx = round(start_time * Fs);  
end_idx = round(end_time * Fs);      
t_10s = (start_idx:end_idx-1) / Fs;  
ch1_10s = ch1(start_idx:end_idx-1);  
ch2_10s = ch2(start_idx:end_idx-1);  

figure('Name','10-20秒双通道波形');
subplot(2,1,1);
plot(t_10s, ch1_10s, 'b');
xlabel('时间（s）'); ylabel('幅值（mV）');
title(['通道1 第', num2str(start_time), '-', num2str(end_time), '秒波形']);
grid on; axis tight;

subplot(2,1,2);
plot(t_10s, ch2_10s, 'r');
xlabel('时间（s）'); ylabel('幅值（mV）');
title(['通道2 第', num2str(start_time), '-', num2str(end_time), '秒波形']);
grid on; axis tight;

%3
single_ecg = (ch1 + ch2) / 2;  

t_total = (0:N-1) / Fs; 
figure('Name','2分钟单通道波形');
plot(t_total, single_ecg, 'k');
xlabel('时间（s）'); ylabel('幅值（mV）');
title('单通道2分钟信号');
grid on; axis tight;

%4
Y = fft(single_ecg);               
Y_amp = 2 * abs(Y(1:N/2)) / N; 
f = Fs * (0:N/2-1) / N;  

figure('Name','ECG信号频谱');

subplot(2,1,1);
plot(f, Y_amp, 'b');
xlabel('频率（Hz）'); ylabel('幅值');
title('全频段频谱');
grid on;
ylim([0, max(Y_amp)*1.2]); 

%子图聚焦0~100Hz
subplot(2,1,2);
plot(f, Y_amp, 'b');
xlabel('频率（Hz）'); ylabel('幅值');
title('频谱（聚焦0~100Hz）');
grid on;
xlim([0, 100]); 
ylim([0, max(Y_amp(f<=100))*1.2]); 
%工频干扰
[freq_50, idx_50] = min(abs(f - 50)); 
[freq_60, idx_60] = min(abs(f - 60)); 
F0_notch = 50;  
if Y_amp(idx_50) > Y_amp(idx_60)
    fprintf('检测到50Hz工频干扰较强（幅值：%.4f）\n', Y_amp(idx_50));
    F0_notch = 50;  
else
    fprintf('检测到60Hz工频干扰较强（幅值：%.4f）\n', Y_amp(idx_60));
    F0_notch = 60;  
end
%肌电干扰
f_EMG_range = (f >= 30) & (f <= 300);
f_EMG = f(f_EMG_range);
Y_amp_EMG = Y_amp(f_EMG_range);

if ~isempty(Y_amp_EMG)
    [peaks_EMG, locs_EMG] = findpeaks(Y_amp_EMG, 'MinPeakHeight', 0.05*max(Y_amp_EMG));
    
    if ~isempty(peaks_EMG)
        [sorted_peaks, sort_idx] = sort(peaks_EMG, 'descend');
        num_peaks_to_show = min(3, length(sorted_peaks));
        
        fprintf('检测到的主要肌电干扰频谱位置：\n');
        
        for i = 1:num_peaks_to_show
            idx_EMG = locs_EMG(sort_idx(i));
            freq_EMG = f_EMG(idx_EMG);
            amp_EMG = sorted_peaks(i);
            
            fprintf('峰值 %d: 频率 %6.1f Hz, 幅值 %.4f\n', i, freq_EMG, amp_EMG);
        end
    else
        fprintf('在30-300Hz频段未检测到显著肌电干扰峰值\n');
        fprintf('诊断：肌电干扰不明显，信号质量良好\n');
    end
else
    fprintf('无法分析肌电干扰频段（30-300Hz）\n');
end

hold off;

%5
Fc_high = 0.3;    
Fc_low = 30;   
Q = 20;       

%高通（基线）
order_high = 3 * fix(Fs / Fc_high);                          
b_high = fir1(order_high, Fc_high/(Fs/2), 'high', hamming(order_high+1));
ecg_high = filtfilt(b_high, 1, single_ecg);   

%低通（肌电）
order_low = 3 * fix(Fs / (Fc_low/2));   
b_low = fir1(order_low, Fc_low/(Fs/2), 'low', hamming(order_low+1));
ecg_low = filtfilt(b_low, 1, ecg_high); 

%带阻（工频）
Wo = F0_notch/(Fs/2); 
BW = Wo / Q;   
[b_notch, a_notch] = iirnotch(Wo, BW); 
ecg_denoised = filtfilt(b_notch, a_notch, ecg_low);

fprintf('信号去噪完成\n');

%6
cmp_start = 30; 
cmp_end = cmp_start + 5; 
cmp_start_idx = round(cmp_start * Fs);
cmp_end_idx = round(cmp_end * Fs);
t_5s = (cmp_start_idx:cmp_end_idx-1) / Fs;
ecg_ori_5s = single_ecg(cmp_start_idx:cmp_end_idx-1);
ecg_den_5s = ecg_denoised(cmp_start_idx:cmp_end_idx-1);

figure('Name','5秒去噪前后对比');
subplot(2,1,1);
plot(t_5s, ecg_ori_5s, 'b');
xlabel('时间（s）'); ylabel('幅值（mV）');
title(['去噪前 第', num2str(cmp_start), '-', num2str(cmp_end), '秒波形']);
grid on; axis tight;

subplot(2,1,2);
plot(t_5s, ecg_den_5s, 'r');
xlabel('时间（s）'); ylabel('幅值（mV）');
title(['去噪后 第', num2str(cmp_start), '-', num2str(cmp_end), '秒波形']);
grid on; axis tight;

%7
%检测R波
min_peak_h = 0.2 * max(ecg_denoised);
min_peak_d = 0.4 * Fs; 
[R_peaks, R_locs] = findpeaks(ecg_denoised, ...
    'MinPeakHeight', min_peak_h, ...
    'MinPeakDistance', min_peak_d);
%RR间期和心率
if length(R_locs) < 2
    error('R波检测数量不足');
end
t_R = t_total(R_locs);  
RR_intervals = diff(t_R);  
avg_RR = mean(RR_intervals); 
heart_rate = 60 / avg_RR; 
%变异系数
cv_RR = std(RR_intervals) / avg_RR;   
if cv_RR < 0.05
    rhythm_result = '心律整齐';
else
    rhythm_result = '心律不齐';
end

%结果
fprintf('心率计算结果：\n');
fprintf('检测到R波数量：%d 个\n', length(R_locs));
fprintf('平均RR间期：%.3f 秒\n', avg_RR);
fprintf('心率：%.1f 次/分钟\n', heart_rate);
fprintf('RR间期变异系数：%.3f\n', cv_RR);
fprintf('心律诊断：%s\n', rhythm_result);
%R波标注图
figure('Name','R波检测');
plot(t_total, ecg_denoised, 'k');
hold on; plot(t_R, R_peaks, 'ro', 'MarkerSize', 6);
xlabel('时间（s）'); ylabel('幅值（mV）');
title(['R波检测结果（心率：', num2str(heart_rate, '%.1f'), ' 次/分）']);
legend('去噪后信号', 'R波峰值');
grid on; axis tight;
hold off;