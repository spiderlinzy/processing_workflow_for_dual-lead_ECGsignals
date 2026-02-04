# 心电信号处理与心率诊断系统（ECG Signal Processing and Heart Rate Diagnosis System）
基于MATLAB开发的双导联心电信号分析工具，实现信号去噪、频谱分析、心率计算及心律诊断功能，适用于医学信号入门学习。

A MATLAB-based analysis tool for dual-lead ECG signals, realizing signal denoising, spectrum analysis, heart rate calculation and rhythm diagnosis, suitable for medical signal entry-level learning.

## 项目概述（Project Overview）
### 核心目标（Core Objectives）
- 读取双导联心电数据，完成采样率计算与双通道信号合并
- 分析心电信号频谱特征，定位肌电干扰与工频干扰
- 设计针对性滤波器组合，有效抑制三类主要干扰
- 实现R波检测、心率计算与心律整齐度诊断
- Read dual-lead ECG data, complete sampling rate calculation and dual-channel signal merging
- Analyze spectral characteristics of ECG signals to locate EMG interference and power frequency interference
- Design targeted filter combinations to effectively suppress three main types of interference
- Realize R-wave detection, heart rate calculation and rhythm regularity diagnosis

### 技术栈（Technology Stack）
- 开发环境（Development Environment）：MATLAB
- 核心技术（Core Technologies）：傅里叶变换（FFT）、数字滤波、峰值检测、信号频谱分析
- Development Environment: MATLAB
- Core Technologies: Fast Fourier Transform (FFT), Digital Filtering, Peak Detection, Signal Spectrum Analysis

## 实验原理（Experimental Principles）
### 1. 心电信号基础（ECG Signal Basics）
- 信号特征：幅度0.1mv-5mv，频率范围0.5Hz-40Hz，包含P波、QRS波群、T波等核心成分
- 关键指标：RR间期（相邻R波间隔）、PR间期等，为心率与心律诊断提供依据
- Signal Characteristics: Amplitude 0.1mv-5mv, frequency range 0.5Hz-40Hz, including core components such as P wave, QRS complex, T wave
- Key Indicators: RR interval (interval between adjacent R waves), PR interval, etc., providing basis for heart rate and rhythm diagnosis

### 2. 主要干扰类型（Main Interference Types）
| 干扰类型（Interference Type） | 频率范围（Frequency Range） | 抑制方案（Suppression Scheme） |
| --- | --- | --- |
| 基线漂移（Baseline Drift） | 0.15-0.3Hz | 0.3Hz高通滤波器 |
| 肌电干扰（EMG Interference） | 20-5000Hz（主要30-300Hz） | 30Hz低通滤波器 |
| 工频干扰（Power Frequency Interference） | 50Hz/60Hz | 带阻滤波器（Notch Filter） |

### 3. 核心算法（Core Algorithms）
- 双通道合并：采用通道均值法降低单通道噪声
- 频谱分析：通过FFT将时域信号转换为频域，识别干扰频率
- 零相位滤波：使用filtfilt函数避免信号相位失真
- R波检测：基于findpeaks函数，通过设置峰值高度与间距实现精准定位
- 心率计算：由平均RR间期推导（心率=60/平均RR间期）
- 心律诊断：通过RR间期变异系数（CVRR<0.05为心律整齐）判断
- Dual-channel Merging: Channel mean method to reduce single-channel noise
- Spectrum Analysis: Convert time-domain signals to frequency-domain via FFT to identify interference frequencies
- Zero-phase Filtering: Use filtfilt function to avoid signal phase distortion
- R-wave Detection: Based on findpeaks function, achieve accurate positioning by setting peak height and distance
- Heart Rate Calculation: Derived from average RR interval (Heart Rate = 60/Average RR Interval)
- Rhythm Diagnosis: Judged by RR interval coefficient of variation (CVRR<0.05 indicates regular rhythm)

## 功能特点（Functional Features）
1. **数据处理（Data Processing）**：支持.mat格式心电数据读取，自动完成采样率计算与双通道合并
2. **频谱分析（Spectrum Analysis）**：可视化全频段及聚焦频段频谱，自动检测工频与肌电干扰峰值
3. **智能去噪（Intelligent Denoising）**：组合滤波器精准抑制三类干扰，去噪后波形特征保留完整
4. **诊断功能（Diagnosis Function）**：自动检测R波数量、计算心率，诊断心律整齐度
5. **可视化展示（Visualization）**：生成双通道波形、单通道波形、频谱图、去噪前后对比图及R波检测图
1. Data Processing: Supports reading .mat format ECG data, automatically completes sampling rate calculation and dual-channel merging
2. Spectrum Analysis: Visualizes full-band and focused-band spectra, automatically detects power frequency and EMG interference peaks
3. Intelligent Denoising: Combined filters accurately suppress three types of interference, preserving complete waveform features after denoising
4. Diagnosis Function: Automatically detects R-wave count, calculates heart rate, and diagnoses rhythm regularity
5. Visualization: Generates dual-channel waveform, single-channel waveform, spectrum diagram, denoising comparison diagram and R-wave detection diagram

## 快速开始（Quick Start）
### 1. 环境准备（Environment Preparation）
- 安装MATLAB（建议R2018b及以上版本）
- 准备心电数据文件（ECG_data.mat），确保数据变量为双列矩阵（双通道信号）
- Install MATLAB (R2018b or higher recommended)
- Prepare ECG data file (ECG_data.mat), ensure data variable is a two-column matrix (dual-channel signal)

### 2. 运行步骤（Running Steps）
1. 下载项目代码文件（ECG_Processing.m）
2. 将代码文件与数据文件（ECG_data.mat）放在同一目录下
3. 在MATLAB中打开代码文件，点击运行按钮
4. 查看命令行输出结果与自动生成的可视化图表
1. Download the project code file (ECG_Processing.m)
2. Place the code file and data file (ECG_data.mat) in the same directory
3. Open the code file in MATLAB and click the run button
4. View the command line output results and automatically generated visualization charts

## 输出结果说明（Output Description）
### 1. 命令行输出（Command Line Output）
- 心电信号采样率（ECG signal sampling rate）
- 干扰检测结果（工频干扰频率与幅值、肌电干扰峰值位置）
- 心率诊断结果（R波数量、平均RR间期、心率、RR间期变异系数、心律诊断结论）
- ECG signal sampling rate
- Interference detection results (power frequency interference frequency and amplitude, EMG interference peak positions)
- Heart rate diagnosis results (R-wave count, average RR interval, heart rate, RR interval coefficient of variation, rhythm diagnosis conclusion)

### 2. 可视化图表（Visualization Charts）
- 10秒双通道信号波形图
- 2分钟单通道合并信号波形图
- 全频段与聚焦0-100Hz频谱图
- 5秒信号去噪前后对比图
- R波检测标注图
- 10-second dual-channel signal waveform diagram
- 2-minute single-channel merged signal waveform diagram
- Full-band and focused 0-100Hz spectrum diagram
- 5-second signal denoising comparison diagram
- R-wave detection annotation diagram

## 注意事项（Notes）
1. 确保数据文件格式正确，变量名与代码中一致（默认变量名M）
2. 若需处理其他数据，需修改代码中数据读取部分与总时长参数
3. 可根据实际需求调整滤波器截止频率、R波检测阈值等参数
4. 运行时请关闭MATLAB中其他占用内存的程序，避免影响处理效率
1. Ensure the data file format is correct and the variable name is consistent with that in the code (default variable name M)
2. To process other data, modify the data reading part and total duration parameter in the code
3. Filter cutoff frequencies, R-wave detection thresholds and other parameters can be adjusted according to actual needs
4. Close other memory-intensive programs in MATLAB during operation to avoid affecting processing efficiency

## 许可证（License）
本项目仅供学习与非商业用途使用。
This project is for learning and non-commercial use only.
