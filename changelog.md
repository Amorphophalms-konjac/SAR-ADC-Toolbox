# 更新日志

按日期记录项目变更，最新内容在前。

## 2026-11-05

### 新增

- 新增 `function/cdac/binaryCDAC.m`，独立计算采样电荷、参考切换电荷和比较器节点电压；使用电容行向量与开关列向量的矩阵内积计算切换电荷，总电容包含 dummy 电容。

### 修改

- `cbwSarADC` 调用独立的 CDAC 函数，并根据比较器节点相对于共模电压的结果更新试探位；返回 MSB 在前的二进制位向量。
- testbench 使用 `bi2de( convRes, 'left-msb' )` 将位向量转换为十进制输出码，再交给数据处理函数。
- `processAdcData` 改用显式 FFT 和点数归一化计算单边每 bin 功率；普通正频率 bin 合并负频率功率，Nyquist bin 不翻倍，DC bin 功率置零，移除时域减均值。
- 频谱输出字段由 `adc.psd` 改为 `adc.spectrum.binPower` 和 `adc.spectrum.frequency`，同步更新 SNDR 计算和绘图；原 `periodogram` 调用保留为注释。
- 频谱纵轴根据 ADC 位数和 FFT 点数估算理想量化噪底，向下取整到 5 dB 间隔作为下限，上限为 5 dBFS。
- 仿真图片导出位置改为项目根目录的 `drawing/adc-dynamic-result.png`，移除 `testbench/` 下的旧结果图，并更新结果图片。
- 修正 MATLAB 编码规范文档的 Markdown 任务列表格式，规则内容不变。

### 验证

- 使用 MATLAB R2025b 加载项目路径并运行 `testbench/simConventionalSarADC.m`，完成转换、指标计算和图片导出。
- 本次验证条件为 12 位单端理想 ADC、1 V 参考电压、1 MHz 采样率、1024 点 FFT；随机选取 `toneBin = 417`，输入频率为 407226.5625 Hz。
- 得到 SNDR = 73.9883 dB、ENOB = 11.9981；DC bin 功率为 0，输出码范围为 0～4095，单边频谱尺寸为 513 × 1，纵轴范围为 −105～5 dBFS。
- 本轮验证为单频点运行；4～5 个输入频点的独立仿真及汇总尚未实现，`genToneBin` 仍使用原来的随机奇数选择方法。

## 2026-11-01

当前为 `dev` 分支上的开发变更，尚未提交或合并至 `main`。

### 新增

- 新增 `genToneBin`，为不小于 4 的二次幂 FFT 长度随机选择奈奎斯特频率以下的奇数 bin。
- 新增 `genSineWave`，根据 FFT 长度、tone bin、样本数、参考电压和共模电压生成正弦采样数据。
- `genSamples` 支持通过 `randomFreqOn` 选择随机频点或指定的 `p.freq`，并返回实际使用的 `samples.toneBin`。
- `.gitignore` 忽略 `local-only/`，个人笔记和编辑器配置不纳入项目提交。

### 修改

- 将配置函数重命名为 `configIdealSingleEndedCbwSarAdcDynamicTest`，明确对应单端理想 CBW SAR ADC 动态测试。
- `synthesizeCDAC` 改为返回电容阵列和开关数组，移除原来返回理想 DAC 函数句柄的实现。
- 二进制电容阵列末尾加入一个单位 dummy 电容；生成器提供单端阵列及 P/N 两侧阵列的构造分支。
- `cbwSarADC` 显式更新各位开关状态，直接根据电容阵列计算试探电压，并将最终开关状态编码为数字码。当前转换模型仍为单端实现。
- `processAdcData` 接收实际输入的 `samples.toneBin`，使用 `periodogram` 计算单边 PSD，使用 Sigma-Delta Toolbox 的 `calculateSNR` 计算 SNDR，并由 SNDR 计算 ENOB。
- 数据处理在理想 DAC 重建后减去记录均值，以去除直流分量；当前处理一组单端相干采样记录。
- 频谱图由 V²/Hz 的 PSD 显示改为每个 FFT bin 的 dBFS 显示，以满幅正弦的均方值 `p.vRef ^ 2 / 8` 为归一化参考。
- SNDR、ENOB 和输入频率通过 `text` 显示在图内左上角，图题简化为 `ADC Output Spectrum`；图内 ENOB 不再重复标注 `bit`。
- 绘图和打印函数增加 `samples` 参数，使用实际 tone bin 计算输入频率，不再读取旧字段 `p.nCycle`。
- 移除打印函数对旧字段 `p.inputAmplitudeDbfs` 的依赖。
- 同步 testbench 中的配置函数名称及数据处理、打印和绘图调用接口。
- 展平原有 `cdac-topologies/binary-cdac/cbw/` 目录层级，电容阵列生成逻辑集中到 `synthesizeCDAC`。
- 移除不必要的省略号续行，并调整部分函数的缩进。

### 移除

- 移除 testbench 内的 `addpath`、`genpath` 及相关路径初始化代码，路径由 MATLAB 运行环境配置。
- 移除空的 `synthesizeBinaryCDAC.m`、`synthesizeFullyDifferentialCbwCDAC.m` 及原单端 DAC 包装实现。
- 清空原 README 内容。

### 验证

- 使用 MATLAB R2025b 直接运行更新后的 `simConventionalSarADC`，完成仿真和频谱图片导出。
- 验证条件：12 位单端理想 ADC、1 V 参考电压、1 MHz 采样率、1024 点 FFT、满幅正弦输入；在运行前使用 `rng( 25 )` 固定随机序列。
- 本次随机选取 `toneBin = 445`，输入频率为 434570.3125 Hz，得到 SNDR = 73.9883 dB、ENOB = 11.9981。
- dBFS 图中基波主峰约为 −0.000003 dBFS；更换频谱显示方式未改变 SNDR 和 ENOB。
- 数据处理的独立数值检查覆盖 5 个相干频点、行/列向量输入，以及 PSD、SNDR 与直接 FFT 计算的一致性；这些检查不代表已完成 ADC 模型的均匀扫频测试。

## 2026-10-30

- 创建项目初始版本，对应首次提交 `0aa2c86`（`Initial commit`）。
