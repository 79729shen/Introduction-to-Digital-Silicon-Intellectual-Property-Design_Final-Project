# FPGA Design and Implementation of Electric Guitar Audio Effects  
## 電吉他音訊效果器之 FPGA 設計與實作

<p align="center">
  <img src="https://img.shields.io/badge/Platform-ZedBoard%20%7C%20Zynq--7000-blue" alt="Platform badge" />
  <img src="https://img.shields.io/badge/HDL-VHDL-orange" alt="HDL badge" />
  <img src="https://img.shields.io/badge/Toolchain-Vivado%202016.2%20%7C%20Xilinx%20SDK%202016.2-green" alt="Toolchain badge" />
  <img src="https://img.shields.io/badge/Audio-ADAU1761-red" alt="Audio badge" />
  <img src="https://img.shields.io/badge/Architecture-PS%2FPL%20Co--Design-purple" alt="Architecture badge" />
</p>

> **Course project / 課程專題**  
> Final project for **Introduction to Digital Silicon IP Design** at **National Chung Hsing University**.  
> 國立中興大學 **《數位矽智產設計導論》** 課程期末專題。

This repository contains a complete FPGA-based electric guitar multi-effects system built on **ZedBoard / Zynq-7000**, using the **ADAU1761 audio codec**, **PS/PL co-design**, and a custom **VHDL** effect chain for real-time audio processing.  
本儲存庫保存了一套以 **ZedBoard / Zynq-7000** 為平台、搭配 **ADAU1761 音訊編解碼器**、採用 **PS/PL 協同設計** 與自製 **VHDL** 效果鏈之即時 FPGA 電吉他多重效果器系統。

> **Repository note / 儲存庫說明**  
> Although the uploaded archive is named **“Verilog source codes”**, the actual implementation in this project is primarily **VHDL**, together with a complete **Vivado + Xilinx SDK** project tree.  
> 雖然上傳壓縮檔名稱為 **「Verilog source codes」**，但專案實際實作內容以 **VHDL** 為主，並包含完整的 **Vivado + Xilinx SDK** 專案樹。

---

## Quick Links | 快速導覽

- [Overview | 專案概述](#overview--專案概述)
- [System Architecture | 系統架構](#system-architecture--系統架構)
- [Effects and Options | 效果模組與設定](#effects-and-options--效果模組與設定)
- [Board Controls | 板上操作](#board-controls--板上操作)
- [Repository Layout | 儲存庫結構](#repository-layout--儲存庫結構)
- [Build and Run | 建置與執行](#build-and-run--建置與執行)
- [Performance | 效能摘要](#performance--效能摘要)
- [References | 參考資料](#references--參考資料)

### Project Files | 專案檔案快速連結

- [Vivado Project (`Meffects_constants_testing_3.xpr`)](./Meffects_constants_testing_3.xpr)
- [Top-level Block Design HDL (`effects_loop.vhd`)](./Meffects_constants_testing_3.ip_user_files/bd/effects_loop/hdl/effects_loop.vhd)
- [SDK Entry Point (`main.c`)](./Meffects_constants_testing_3.sdk/audio/src/main.c)
- [Streaming Loop (`audio_loop.c`)](./Meffects_constants_testing_3.sdk/audio/src/audio_loop.c)
- [User Control IP (`control.vhd`)](./ip_repo/VL_user_control_1.0/control.vhd)
- [Constraints (`cost.xdc`)](./Meffects_constants_testing_3.srcs/constrs_1/new/cost.xdc)
- [Implemented Bitstream (`effects_loop_wrapper.bit`)](./Meffects_constants_testing_3.runs/impl_1/effects_loop_wrapper.bit)
- [Prebuilt ELF (`audio.elf`)](./Meffects_constants_testing_3.sdk/audio/Debug/audio.elf)
- [Project Report PDF](./沈龍翔_黃光儀_期末project.pdf)
- [README PDF](./README.pdf)

---

## Overview | 專案概述

This project implements a **real-time FPGA guitar multi-effects platform**. The architecture combines the **ARM Processing System (PS)** of the Zynq SoC with **Programmable Logic (PL)** blocks that process the audio stream in hardware. The current implementation integrates four effects in series:

1. **Distortion / Overdrive**
2. **Octaver / Octavelo**
3. **Tremolo**
4. **Delay**

本專題實作了一套 **即時 FPGA 電吉他多重效果器平台**。系統架構結合 Zynq SoC 的 **ARM Processing System (PS)** 與 **Programmable Logic (PL)**，讓音訊資料在硬體效果鏈中即時處理。目前設計串接四種效果器：

1. **Distortion / Overdrive**
2. **Octaver / Octavelo**
3. **Tremolo**
4. **Delay**

The uploaded source tree shows that the repository is not only a “source-only” archive: it preserves the **full Vivado project**, **generated implementation results**, **packaged custom IP**, **SDK application code**, and **project documentation**.  
從上傳的原始碼樹可以看出，本儲存庫並不只是「單純原始碼壓縮檔」，而是保留了 **完整 Vivado 專案**、**實作輸出結果**、**封裝後的自訂 IP**、**SDK 應用程式碼** 以及 **專題文件**。

### Project Information | 專案資訊

| Item | Details |
|---|---|
| Project title | **FPGA Design and Implementation of Electric Guitar Audio Effects**<br>**電吉他音訊效果器之 FPGA 設計與實作** |
| Type | Academic final project / 課程期末專題 |
| Course | Introduction to Digital Silicon IP Design / 數位矽智產設計導論 |
| Team members | **Long-Xiang Shen（沈龍翔）**, **Kuang Yi Huang（黃光儀）** |
| Advisor / Professor | **Dr. Chih-Peng Fan** |
| Platform | **ZedBoard** with **Zynq-7000 SoC** |
| Audio front-end | **ADAU1761** codec |
| Main HDL | **VHDL** |
| Toolchain | **Vivado 2016.2**, **Xilinx SDK 2016.2** |

### Code-Verified Highlights | 根據原始碼確認的設計重點

- **Fixed hardware effect order / 固定硬體效果順序**  
  The top-level generated block design in [`effects_loop.vhd`](./Meffects_constants_testing_3.ip_user_files/bd/effects_loop/hdl/effects_loop.vhd) wires the chain as:  
  `PS_to_PL -> Distortion -> octaver -> trem -> delay -> PL_to_PS`  
  `effects_loop.vhd` 中的頂層方塊設計明確將效果鏈固定為：  
  `PS_to_PL -> Distortion -> octaver -> trem -> delay -> PL_to_PS`

- **Left-channel runtime path / 左聲道運作路徑**  
  [`audio_loop.c`](./Meffects_constants_testing_3.sdk/audio/src/audio_loop.c) reads `I2S_DATA_RX_L_REG`, writes the sample to `PS_TO_PL`, reads the processed result back from `PL_TO_PS`, and transmits to `I2S_DATA_TX_L_REG`. The runtime data path is therefore **left-channel / mono-oriented** in the current software loop.  
  [`audio_loop.c`](./Meffects_constants_testing_3.sdk/audio/src/audio_loop.c) 會讀取 `I2S_DATA_RX_L_REG`、將樣本寫入 `PS_TO_PL`、再從 `PL_TO_PS` 取回處理後資料，最後送往 `I2S_DATA_TX_L_REG`，因此目前軟體執行路徑是 **左聲道／偏單聲道** 的處理模式。

- **Board UI implemented in custom logic / 板上操作介面由自訂邏輯負責**  
  [`control.vhd`](./ip_repo/VL_user_control_1.0/control.vhd) maps **Switches[0:3]** to effect enable bits, uses **Switches[4:7]** as the option bus for the currently selected effect, and controls navigation through **left / center / right buttons** plus LEDs.  
  [`control.vhd`](./ip_repo/VL_user_control_1.0/control.vhd) 將 **Switches[0:3]** 對應為效果啟用位元，並使用 **Switches[4:7]** 作為目前選取效果器的參數設定匯流排，再透過 **左／中／右按鈕** 與 LED 實現選單操作。

- **Clock helpers are explicit / 時脈輔助模組獨立可見**  
  [`MCLK_gen.vhd`](./ip_repo/VL_user_MCLK_gen_1.0/MCLK_gen.vhd) divides the incoming PS clock by 2 to generate the codec master clock domain, while [`clk_slow.vhd`](./ip_repo/VL_user_clk_slow_1.0/sources_1/new/clk_slow.vhd) provides slow-rate clocks for tremolo modulation and UI navigation.  
  [`MCLK_gen.vhd`](./ip_repo/VL_user_MCLK_gen_1.0/MCLK_gen.vhd) 會將輸入的 PS 時脈除以 2，以產生 codec 所需主時脈域；[`clk_slow.vhd`](./ip_repo/VL_user_clk_slow_1.0/sources_1/new/clk_slow.vhd) 則提供 tremolo 與使用者介面所需的低頻時脈。

- **Time-based effects use BRAM buffering / 時域效果使用 BRAM 緩衝**  
  Both `delay.vhd` and `octaver.vhd` instantiate BRAM-based sample buffers with **20,000-sample** depth, which explains the relatively high BRAM utilization in the implementation report.  
  `delay.vhd` 與 `octaver.vhd` 都使用 **20,000 筆樣本深度** 的 BRAM 緩衝，因此也解釋了後端實作報告中 BRAM 使用率相對較高的原因。

---

## System Architecture | 系統架構

### Audio Path | 音訊資料路徑

```text
Line-In
  -> ADAU1761 ADC
  -> I2S / zed_audio_ctrl
  -> AXI
  -> PS
  -> PS_to_PL
  -> Distortion
  -> Octaver / Octavelo
  -> Tremolo
  -> Delay
  -> PL_to_PS
  -> PS
  -> AXI / zed_audio_ctrl
  -> I2S
  -> ADAU1761 DAC
  -> Line-Out / Headphone-Out
```

### PS / PL Partitioning | PS / PL 分工

| Block | Responsibility |
|---|---|
| PS (ARM Cortex-A9) | Initializes I2C and codec registers in [`main.c`](./Meffects_constants_testing_3.sdk/audio/src/main.c), performs AXI read/write transactions, and manages the streaming loop.<br>在 [`main.c`](./Meffects_constants_testing_3.sdk/audio/src/main.c) 中負責 I2C 與 codec 初始化、執行 AXI 讀寫交易，並持續進行音訊串流迴圈。 |
| PL effect chain | Applies distortion, octave shifting, tremolo, and delay in hardware, sample by sample, in the fixed order exposed by the block design.<br>依照方塊設計所定義的固定順序，在硬體中逐樣本套用 distortion、octave shifting、tremolo 與 delay。 |
| zed_audio_ctrl IP | Bridges audio serial data and AXI-side registers, and participates in I2S-oriented codec interfacing.<br>負責音訊序列資料與 AXI 暫存器之間的橋接，並參與 I2S 與 codec 的介面控制。 |
| User control IP | Handles on-board buttons, switches, and LED feedback for effect selection and option editing.<br>處理板上按鍵、撥桿與 LED 指示，用於效果選擇與參數編輯。 |
| BRAM-based buffers | Store delayed samples for `delay` and `octaver` style effects.<br>提供 `delay` 與 `octaver` 類效果所需的延遲樣本儲存空間。 |

### Protocols | 主要介面與協定

| Protocol | Role |
|---|---|
| **AXI4-Lite** | Used for PS/PL register-mapped sample transfer and peripheral access.<br>用於 PS/PL 之間的記憶體映射暫存器存取，以及音訊樣本傳遞。 |
| **I2C** | Used by the PS to configure ADAU1761 registers.<br>由 PS 用來設定 ADAU1761 的控制暫存器。 |
| **I2S** | Used for digital audio transport between FPGA logic and the audio codec.<br>用於 FPGA 邏輯與音訊 codec 之間的數位音訊傳輸。 |

### Clocking Notes | 時脈設計重點

| File | Observation |
|---|---|
| [`MCLK_gen.vhd`](./ip_repo/VL_user_MCLK_gen_1.0/MCLK_gen.vhd) | A simple divide-by-2 clock generator. In the generated PS wrapper, `FCLK_CLK0` is configured at **100 MHz**, so this block yields an approximately **50 MHz** MCLK domain for the audio side.<br>此模組為簡單的除 2 時脈產生器。由產生出的 PS wrapper 可知 `FCLK_CLK0` 設為 **100 MHz**，因此此模組會得到約 **50 MHz** 的 MCLK 音訊時脈域。 |
| [`clk_slow.vhd`](./ip_repo/VL_user_clk_slow_1.0/sources_1/new/clk_slow.vhd) | Generates **380 Hz / 190 Hz / 95 Hz / 48 Hz / 12 Hz / 1.5 Hz** derived clocks used by tremolo and the control UI.<br>產生 **380 Hz / 190 Hz / 95 Hz / 48 Hz / 12 Hz / 1.5 Hz** 等低頻時脈，供 tremolo 與控制介面使用。 |

---

## Effects and Options | 效果模組與設定

### Effect Order and Enable Mapping | 效果鏈順序與啟用位元

| Enable bit | Effect |
|---|---|
| `En(0)` | Distortion / Overdrive |
| `En(1)` | Octaver / Octavelo |
| `En(2)` | Tremolo |
| `En(3)` | Delay |

> **Naming note / 命名說明**  
> The source code names the second effect block **`octaver`**, while the report and some documentation refer to the effect as **Octavelo**. In this README, both names are shown together to reduce ambiguity.  
> 原始碼中的第二個效果模組名稱為 **`octaver`**，但在報告與部分文件中則稱作 **Octavelo**。本 README 同時保留兩種稱呼，以避免混淆。

### 1) Distortion / Overdrive

**Source / 原始碼**: [`Distortion.vhd`](./ip_repo/VL_user_Distortion_1.0/sources_1/new/Distortion.vhd)

The distortion block uses several non-linear mappings, ranging from simple threshold clipping to a much more aggressive piecewise waveshaping table.  
Distortion 模組使用多種非線性映射方式，從簡單門檻 clipping 到更激烈的分段 waveshaping 都有包含。

| Option | Description |
|---|---|
| `1000` | Weak overdrive / 弱過載：clips around ±70000 with softer saturation behavior |
| `0100` | Strong overdrive / 強過載：clips around ±70000 but remaps to larger output magnitude |
| `0010` | Overdrive / 一般過載：clips around ±50000 |
| `0001` | Distortion / 失真：piecewise nonlinear shaping table for harsher harmonic content / 以大量分段映射產生更強烈的諧波失真 |

### 2) Octaver / Octavelo

**Source / 原始碼**: [`octaver.vhd`](./ip_repo/VL_user_octaver_1.0/sources_1/new/octaver.vhd)

This block uses BRAM buffering together with different read-pointer stepping rates to create octave-up, octave-down, and more experimental textures.  
此模組透過 BRAM 緩衝與不同讀取指標移動速度，實現升八度、降八度與較實驗性的聲音質地。

| Option | Type | Description |
|---|---|---|
| `1000` | FIR | 1 octave up, max delay = 3000 samples / 升一個八度，最大延遲 3000 samples |
| `1100` | FIR | 1 octave up, max delay = 8000 samples / 升一個八度，最大延遲 8000 samples |
| `1110` | FIR | 1 octave up, max delay = 15000 samples / 升一個八度，最大延遲 15000 samples |
| `1111` | IIR | 1 octave up, max delay = 5000 samples / 升一個八度，最大延遲 5000 samples |
| `0111` | IIR | 1 octave up, max delay = 10000 samples / 升一個八度，最大延遲 10000 samples |
| `0011` | IIR | 1 octave up, max delay = 19999 samples / 升一個八度，最大延遲 19999 samples |
| `0100` | FIR | 2 octaves up, max delay = 3000 samples / 升兩個八度，最大延遲 3000 samples |
| `0010` | FIR | 1 octave down, max delay = 8000 samples / 降一個八度，最大延遲 8000 samples |
| `0001` | FIR | 2 octaves up, max delay = 500 samples, “robot sound” style / 升兩個八度、最大延遲 500 samples，偏機械化音色 |

### 3) Tremolo

**Source / 原始碼**: [`trem.vhd`](./ip_repo/VL_user_trem_1.0/sources_1/new/trem.vhd)

The tremolo block modulates amplitude using low-frequency triangular waveforms.  
Tremolo 模組透過低頻三角波進行振幅調變。

| Option | Description |
|---|---|
| `1000` | 1.6 Hz tremolo / 1.6 Hz 顫音 |
| `0100` | 3.2 Hz tremolo / 3.2 Hz 顫音 |
| `0010` | 6.35 Hz tremolo / 6.35 Hz 顫音 |
| `0001` | 0.8 Hz tremolo / 0.8 Hz 顫音 |

### 4) Delay

**Source / 原始碼**: [`delay.vhd`](./ip_repo/VL_user_delay_1.0/sources_1/new/delay.vhd)

The delay block combines BRAM-based sample storage with both FIR and IIR-style feedback paths. Some modes use a variable `count`-based delay length for longer evolving echoes.  
Delay 模組使用 BRAM 儲存過去樣本，並同時包含 FIR 與 IIR 類型的回授架構；某些模式會透過 `count` 改變延遲長度，以形成更長、更動態的回聲效果。

| Option | Type | Description |
|---|---|---|
| `1000` | IIR | Long feedback delay (`T-1`) / 長延遲回授模式（`T-1`） |
| `1100` | IIR | Faster / shorter delay (`T/2-1`) / 較快、較短的延遲（`T/2-1`） |
| `1110` | IIR | Slight reverb-like response with lower feedback / 較輕微、偏 reverb 感的回授 |
| `0100` | IIR | Long evolving delay using variable `count` / 以可變 `count` 形成較長且動態的延遲 |
| `0010` | FIR | Single-tap long delay using variable `count` / 以可變 `count` 形成單次回聲型長延遲 |

### Effect Module Summary | 效果模組摘要

| Module | Implementation note |
|---|---|
| Distortion | Uses threshold clipping and large piecewise output mapping for nonlinear tone shaping.<br>使用門檻 clipping 與大量分段輸出映射來形成非線性音色。 |
| Octaver / Octavelo | Uses BRAM and pointer-rate manipulation to emulate octave shifts and hybrid textures.<br>透過 BRAM 與位址指標速度變化模擬升降八度與混合型音色。 |
| Tremolo | Uses triangular low-frequency modulation for periodic amplitude change.<br>以三角低頻波做週期性振幅調變。 |
| Delay | Uses BRAM-backed delay lines with FIR/IIR options and feedback-based echo behavior.<br>使用 BRAM 延遲線並提供 FIR/IIR 選項與回授型回聲行為。 |

---

## Board Controls | 板上操作

### Physical Mapping | 實體控制對應

Based on [`cost.xdc`](./Meffects_constants_testing_3.srcs/constrs_1/new/cost.xdc) and [`control.vhd`](./ip_repo/VL_user_control_1.0/control.vhd):  
依據 [`cost.xdc`](./Meffects_constants_testing_3.srcs/constrs_1/new/cost.xdc) 與 [`control.vhd`](./ip_repo/VL_user_control_1.0/control.vhd) 可知：

| Control | Function |
|---|---|
| `Switches[0:3]` | Enable or bypass the four effects / 啟用或旁路四個效果模組 |
| `Switches[4:7]` | Select option bits for the currently selected effect / 選擇目前效果器的參數設定位元 |
| `butn_in[0]` | Left button / 左鍵 |
| `butn_in[1]` | Center button / 中鍵 |
| `butn_in[2]` | Right button / 右鍵 |
| `Leds[0:3]` | Show which effect is currently selected in the menu / 顯示目前選單中被選取的效果器 |
| `Leds[4:7]` | Present in the design, but selection UI primarily uses the first four LEDs / 設計中存在，但主要選單邏輯以前四顆 LED 為主 |

### Menu Logic | 選單邏輯

| State | Behavior |
|---|---|
| Selection mode / 選取模式 | Left and right buttons scroll through the 4 effect blocks. LEDs indicate the current selection. |
| Edit mode / 編輯模式 | Pressing the center button toggles into parameter-edit mode. In this mode, `Switches[4:7]` are routed to the selected effect’s option bus. |
| Enable control / 啟用控制 | Effect activation itself is independent: `Switches[0:3]` directly drive the enable bits for the four effect modules. |

---

## Repository Layout | 儲存庫結構

### Top-Level Layout | 根目錄結構

The current GitHub repository layout, consistent with the uploaded screenshot, is a **full Vivado project tree** rather than a minimal source-only repository.  
目前 GitHub 上的儲存庫結構（與你提供的截圖一致）屬於 **完整 Vivado 專案樹**，而不是精簡版的 source-only repository。

```text
.
├── Meffects_constants_testing_3.cache/
├── Meffects_constants_testing_3.hw/
├── Meffects_constants_testing_3.ip_user_files/
├── Meffects_constants_testing_3.runs/
├── Meffects_constants_testing_3.sdk/
├── Meffects_constants_testing_3.srcs/
├── Meffects_constants_testing_3.xpr
├── ip_repo/
├── README.md
├── README.pdf
└── 沈龍翔_黃光儀_期末project.pdf
```

### Directory Roles | 主要資料夾用途

| Path | Purpose |
|---|---|
| `Meffects_constants_testing_3.xpr` | Main Vivado project file / Vivado 主專案檔 |
| `Meffects_constants_testing_3.ip_user_files/` | Generated block design products, HDL wrapper, and IP-related outputs / 產生後的 block design 產物、HDL wrapper 與 IP 相關輸出 |
| `Meffects_constants_testing_3.srcs/` | Source and constraint tree used by Vivado / Vivado 使用的原始碼與約束檔樹 |
| `Meffects_constants_testing_3.runs/` | Synthesis / implementation runs, reports, and bitstream / 合成與實作結果、報告與 bitstream |
| `Meffects_constants_testing_3.sdk/` | Xilinx SDK workspace, BSP, audio application, and hardware export / SDK workspace、BSP、音訊應用程式與硬體匯出 |
| `ip_repo/` | Packaged custom IP blocks used by the design / 本設計使用的自訂封裝 IP |
| `README.pdf` | PDF documentation snapshot / PDF 格式說明文件 |
| `沈龍翔_黃光儀_期末project.pdf` | Full final report / 完整期末專題報告 |

### Important Files for Reviewers | 供檢閱者快速定位的關鍵檔案

| File | Why it matters |
|---|---|
| [`effects_loop.vhd`](./Meffects_constants_testing_3.ip_user_files/bd/effects_loop/hdl/effects_loop.vhd) | Shows the actual top-level interconnect and effect ordering / 顯示實際頂層互連與效果器排列順序 |
| [`main.c`](./Meffects_constants_testing_3.sdk/audio/src/main.c) | SDK entry point that initializes I2C and codec configuration / SDK 入口程式，負責 I2C 與 codec 初始化 |
| [`audio_loop.c`](./Meffects_constants_testing_3.sdk/audio/src/audio_loop.c) | Minimal streaming loop between codec, PS, and PL / codec、PS 與 PL 之間的核心串流迴圈 |
| [`control.vhd`](./ip_repo/VL_user_control_1.0/control.vhd) | Implements button/switch/LED user interface logic / 實作按鍵、撥桿與 LED 使用者介面邏輯 |
| [`Distortion.vhd`](./ip_repo/VL_user_Distortion_1.0/sources_1/new/Distortion.vhd) | Distortion/overdrive implementation / Distortion/overdrive 實作 |
| [`octaver.vhd`](./ip_repo/VL_user_octaver_1.0/sources_1/new/octaver.vhd) | Octaver/Octavelo implementation / Octaver/Octavelo 實作 |
| [`trem.vhd`](./ip_repo/VL_user_trem_1.0/sources_1/new/trem.vhd) | Tremolo implementation / Tremolo 實作 |
| [`delay.vhd`](./ip_repo/VL_user_delay_1.0/sources_1/new/delay.vhd) | Delay implementation / Delay 實作 |
| [`cost.xdc`](./Meffects_constants_testing_3.srcs/constrs_1/new/cost.xdc) | Board pin mapping and constraints / 板級腳位對應與約束 |
| [`effects_loop_wrapper.bit`](./Meffects_constants_testing_3.runs/impl_1/effects_loop_wrapper.bit) | Pre-generated FPGA bitstream / 已產生的 FPGA bitstream |
| [`audio.elf`](./Meffects_constants_testing_3.sdk/audio/Debug/audio.elf) | Prebuilt executable for the ARM side / ARM 端已編譯執行檔 |
| [`effects_loop_wrapper_utilization_placed.rpt`](./Meffects_constants_testing_3.runs/impl_1/effects_loop_wrapper_utilization_placed.rpt) | Post-implementation resource usage report / 後端實作後資源使用報告 |

---

## Software Runtime and AXI Map | 軟體執行流程與 AXI 位址

### Runtime Flow | 執行流程

The software side is intentionally lightweight. [`main.c`](./Meffects_constants_testing_3.sdk/audio/src/main.c) performs the following steps:

1. Initialize PS I2C controller  
2. Configure the audio codec  
3. Enter an infinite audio streaming loop  

軟體端設計相對精簡。[`main.c`](./Meffects_constants_testing_3.sdk/audio/src/main.c) 執行流程如下：

1. 初始化 PS 端 I2C 控制器  
2. 設定 audio codec  
3. 進入無限音訊串流迴圈  

In [`audio_loop.c`](./Meffects_constants_testing_3.sdk/audio/src/audio_loop.c), each audio sample is moved through the system as:

```text
Codec RX (left channel) -> PS writes PS_TO_PL -> PL effect chain -> PS reads PL_TO_PS -> Codec TX (left channel)
```

### AXI Memory Map | AXI 記憶體映射

The following base addresses are defined in `xparameters.h` in the SDK BSP:  
以下基底位址定義於 SDK BSP 的 `xparameters.h` 中：

| Peripheral | Base address | Purpose |
|---|---:|---|
| `PL_TO_PS_0` | `0x43C10000` | Processed sample is read back by PS / PS 從此讀回處理後樣本 |
| `PS_TO_PL_0` | `0x43C20000` | Raw sample is written from PS into PL / PS 從此將輸入樣本送入 PL |
| `ZED_AUDIO_CTRL_0` | `0x43C30000` | Audio controller / codec-side register block / 音訊控制器與 codec 相關暫存器 |

---

## Build and Run | 建置與執行

### Recommended Environment | 建議環境

- **ZedBoard**
- **Vivado 2016.2**
- **Xilinx SDK 2016.2**
- USB/JTAG programming connection
- Audio source connected to **Line-In**
- Amplifier / speakers / headphones connected to **Line-Out** or **Headphones**

### Reproduction Steps | 重現步驟

1. **Clone or download this repository**  
   下載或 clone 此 repository。

2. **Open the Vivado project**  
   Open [`Meffects_constants_testing_3.xpr`](./Meffects_constants_testing_3.xpr) in Vivado 2016.2。  
   以 Vivado 2016.2 開啟 [`Meffects_constants_testing_3.xpr`](./Meffects_constants_testing_3.xpr)。

3. **Set the local IP repository**  
   Add [`ip_repo/`](./ip_repo) to the project IP repository path.  
   將 [`ip_repo/`](./ip_repo) 加入專案的 IP Repository 路徑。

4. **Validate the block design if needed**  
   Ensure the block design resolves all packaged IP correctly。  
   視需要重新驗證 block design，確認所有封裝 IP 都能正確被辨識。

5. **Use the provided bitstream or regenerate**  
   A pre-generated bitstream is already present at [`Meffects_constants_testing_3.runs/impl_1/effects_loop_wrapper.bit`](./Meffects_constants_testing_3.runs/impl_1/effects_loop_wrapper.bit)。  
   若不想重新跑 implementation，可直接使用現成的 bitstream：[`Meffects_constants_testing_3.runs/impl_1/effects_loop_wrapper.bit`](./Meffects_constants_testing_3.runs/impl_1/effects_loop_wrapper.bit)。

6. **Launch Xilinx SDK**  
   Open the SDK workspace contained in [`Meffects_constants_testing_3.sdk/`](./Meffects_constants_testing_3.sdk)。  
   啟動 Xilinx SDK，開啟 [`Meffects_constants_testing_3.sdk/`](./Meffects_constants_testing_3.sdk) 中的 workspace。

7. **Program the board and run the application**  
   Program the FPGA, then run the `audio` application on hardware。  
   將 bitstream 燒錄至板子後，在硬體上執行 `audio` 專案。

8. **Connect audio I/O and test the controls**  
   Feed a guitar or line-level source into Line-In, connect output to Line-Out / headphone, then use switches and buttons to select effects and options。  
   將吉他或 line-level 音源接到 Line-In，輸出接 Line-Out / 耳機，再透過撥桿與按鍵操作效果器與內部設定。

### Practical Note | 實務備註

Because this repository already contains generated run outputs, SDK artifacts, and packaged IP, it is closer to an **archival / reproducible hand-in repository** than a minimal open-source source tree.  
由於此儲存庫已包含生成後的 run outputs、SDK 成果與封裝 IP，因此它更接近 **可重現的課程繳交版專案**，而非極度精簡的開源原始碼樹。

---

## Performance | 效能摘要

### Audio / Implementation Notes | 音訊與實作重點

| Item | Summary |
|---|---|
| Audio codec | ADAU1761 on ZedBoard / ZedBoard 板載 ADAU1761 |
| Stream width | 32-bit AXI-side path with 24-bit audio payload usage inside effect logic / AXI 端為 32-bit 路徑，效果器邏輯主要使用其中 24-bit 音訊資料 |
| Runtime channel | Left channel in the current C streaming loop / 目前 C 串流迴圈以左聲道為主 |
| Delay buffer depth | 20,000 samples in delay / octaver BRAM-based buffers / delay 與 octaver BRAM 緩衝深度為 20,000 samples |
| Sampling rate | Approximately 48 kHz class; the report explains an effective rate around **48.828 kHz** from the FPGA-derived clocking arrangement / 約 48 kHz 等級；報告中依 FPGA 時脈安排推導出約 **48.828 kHz** 的有效取樣率 |
| Measured latency | ~**960 μs** in bypass mode, ~**1.1 ms** with full effect chain enabled / bypass 約 **960 μs**，全效果鏈約 **1.1 ms** |

### Post-Implementation Resource Utilization | 後端實作資源使用率

The following figures match the implementation report in:  
以下數值對應於 implementation report：  
[`Meffects_constants_testing_3.runs/impl_1/effects_loop_wrapper_utilization_placed.rpt`](./Meffects_constants_testing_3.runs/impl_1/effects_loop_wrapper_utilization_placed.rpt)

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| Slice LUTs | 4465 | 53200 | 8.39% |
| LUT as Memory | 68 | 17400 | 0.39% |
| Register as Flip-Flop | 1911 | 106400 | 1.80% |
| Slice Registers (total) | 2068 | 106400 | 1.94% |
| Block RAM Tile | 46 | 140 | 32.86% |
| DSPs | 2 | 220 | 0.91% |
| Bonded IOB | 28 | 200 | 14.00% |
| BUFGCTRL | 6 | 32 | 18.75% |

### What the Numbers Suggest | 這些數字代表什麼

- **Low logic cost / 邏輯資源成本低**  
  LUT / FF / DSP usage is relatively modest, which is reasonable for a small real-time signal-processing prototype。  
  LUT / FF / DSP 使用量相對保守，符合小型即時音訊訊號處理原型的特性。

- **BRAM-heavy by design / BRAM 使用較高屬設計使然**  
  The most visible resource cost comes from BRAM, because delay-based effects explicitly store past samples in on-chip memories。  
  資源中最顯著的是 BRAM，原因在於 delay 類效果必須把歷史樣本存進片上記憶體。

- **Latency remains practical / 延遲仍具實用性**  
  The measured end-to-end latency remains around the 1 ms class even with the full chain enabled, which is appropriate for interactive guitar processing。  
  即使全效果鏈啟用，量測到的端對端延遲仍約為 1 ms 等級，對即時吉他處理而言相當實用。

---

## Notes and Limitations | 注意事項與限制

| Topic | Note |
|---|---|
| Language naming | The archive name says “Verilog”, but the HDL implementation is primarily **VHDL**.<br>壓縮檔名稱雖寫為「Verilog」，但 HDL 實作主要是 **VHDL**。 |
| Effect ordering | Effects can be enabled or bypassed individually, but the hardware chain order is fixed in the top-level design.<br>各效果可獨立啟用或旁路，但硬體串接順序在頂層設計中已固定。 |
| Channel handling | The current software loop is left-channel oriented; stereo expansion would require code and data-path updates.<br>目前軟體迴圈偏向左聲道處理；若要完整 stereo，需再修改程式與資料路徑。 |
| Generated files | The repository intentionally includes many generated Vivado / SDK files for reproducibility.<br>本 repository 刻意保留大量 Vivado / SDK 生成檔，以利重現。 |
| License | No explicit open-source license file is included in the uploaded repository.<br>上傳的儲存庫中目前未看到明確的開源授權檔。 |

---

## References | 參考資料

### Official Platform Documentation | 官方平台文件

- [Digilent ZedBoard Reference Manual](https://digilent.com/reference/programmable-logic/zedboard/reference-manual)
- [AMD Zynq-7000 SoC Overview](https://www.amd.com/en/products/adaptive-socs-and-fpgas/soc/zynq-7000.html)
- [Analog Devices ADAU1761 Product Page](https://www.analog.com/en/products/adau1761.html)
- [ADAU1761 Datasheet (PDF)](https://www.analog.com/media/en/technical-documentation/data-sheets/adau1761.pdf)
- [Vivado Design Suite 2016.2 Release Notes / Documentation](https://docs.amd.com/v/u/2016.2-English/ug973-vivado-release-notes-install-license)

### GitHub Documentation | GitHub 文件

- [Basic writing and formatting syntax](https://docs.github.com/github/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
- [About README files and relative links](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)

---

## Suggested Citation / Repository Description | 建議的儲存庫簡述

> **EN**: FPGA-based electric guitar multi-effects system on ZedBoard / Zynq-7000 using ADAU1761, VHDL custom IP, PS/PL co-design, and a real-time chain of distortion, octaver, tremolo, and delay.  
> **中文**：以 ZedBoard / Zynq-7000 與 ADAU1761 為平台，透過 VHDL 自製 IP 與 PS/PL 協同設計實作的 FPGA 即時電吉他多重效果器，內含 distortion、octaver、tremolo 與 delay 效果鏈。

