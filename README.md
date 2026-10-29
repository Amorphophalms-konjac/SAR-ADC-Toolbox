# SAR ADC Toolbox

基于 MATLAB 的 SAR ADC 行为仿真工具箱，用于研究逐次逼近转换过程，以及 ADC 输出频谱和动态性能。当前实现理想单端传统二进制权重（Conventional Binary-Weighted，CBW）SAR ADC。

## 功能

- 由二进制权重 CDAC、理想比较器和逐次逼近算法构成，按样本完成转换。
- 相干采样正弦激励，支持配置分辨率、参考电压、采样率和输入幅度。
- 单边功率谱密度（PSD）分析，计算 SNDR 和 ENOB。
- 在命令窗口输出仿真参数与动态性能，绘制频谱并导出图片。

## 快速开始

先在终端下载仓库：

```bash
git clone https://github.com/Amorphophalms-konjac/SAR-ADC-Toolbox.git
cd SAR-ADC-Toolbox
```

在 MATLAB 中将当前文件夹切换到克隆得到的 `SAR-ADC-Toolbox`，执行：

```matlab
run( 'testbench/simConventionalSarADC.m' );
```

脚本会自动加载所需路径，默认执行 12 位 ADC 的动态测试，使用 1 MHz 采样率采集 1024 个样本，输入正弦幅度为 −1 dBFS、频率约为 124.023 kHz。运行后生成输出频谱图，并在命令窗口输出仿真参数、SNDR 和 ENOB。仿真结果保留在 MATLAB 工作区，图片保存至 `testbench/adc-dynamic-result.png`。

也可以通过 GitHub 的 **Code → Download ZIP** 下载，解压后在 MATLAB 中打开实际的解压目录。

## 环境要求

建议使用 MATLAB R2020a 或更新版本，以支持图片导出使用的 `exportgraphics`。当前示例无需额外工具箱。

## 配置与文档

修改 [configDynamicTest.m](sim-config/configDynamicTest.m) 可调整 ADC 分辨率、参考电压、采样率、FFT 长度、输入正弦周期数和幅度。配置通过结构体 `p` 在各模块间传递。

输入频率由 `p.nCycle * p.sampleRate / p.fftLen` 决定。当前频谱分析不加窗，要求 FFT 长度为偶数，输入周期数为整数且满足 `0 < p.nCycle < p.fftLen / 2`；建议周期数与 FFT 长度互质。ENOB 按 `(SNDR - 1.76) / 6.02` 计算，未进行输入幅度补偿。

主要代码入口：

- [仿真脚本](testbench/simConventionalSarADC.m)：生成输入、执行转换并处理结果。
- [SAR ADC 模型](models/cbwSarADC.m)：从最高位到最低位逐位试探数字码。
- [CDAC 生成接口](function/cdac-topologies/synthesizeCDAC.m)：返回理想单端 CBW CDAC 函数句柄。
- [动态性能分析](function/data-processing/processAdcData.m)：重构输出电压并计算 PSD、SNDR 和 ENOB。

当前固定使用理想单端结构，每个输入样本对应一次完整转换，尚未引入位时钟。电容失配、寄生、全差分 CDAC、码密度测试、采样噪声及比较器非理想效应等尚未实现；配置中的 `nCap` 和 `mismatchStd` 当前未参与模型计算。

修改或新增 MATLAB 代码前，请阅读 [MATLAB 编码规范](coding-style/coding-sytle.md)。

## 许可证

本项目采用 [MIT License](https://github.com/Amorphophalms-konjac/SAR-ADC-Toolbox/blob/main/LICENSE)。使用、修改或分发代码时，请保留版权声明与许可声明。
