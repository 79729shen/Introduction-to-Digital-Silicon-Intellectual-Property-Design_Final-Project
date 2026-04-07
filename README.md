# FPGA Design and Implementation of Electric Guitar Audio Effects  
## 電吉他音訊效果器之 FPGA 設計與實作

<p align="center">
  <img src="https://img.shields.io/badge/Platform-ZedBoard%20Zynq--7000-blue" alt="Platform badge" />
  <img src="https://img.shields.io/badge/HDL-VHDL-orange" alt="HDL badge" />
  <img src="https://img.shields.io/badge/Tools-Vivado%20%7C%20Xilinx%20SDK%20%7C%20MATLAB-green" alt="Tools badge" />
  <img src="https://img.shields.io/badge/Audio-ADAU1761-red" alt="Audio badge" />
</p>

> Final project for **數位矽智產設計導論** (Introduction to Digital Silicon IP Design), National Chung Hsing University  
> 國立中興大學《數位矽智產設計導論》課程期末專題

---

## Quick Links｜快速連結

- [中文版說明](#中文版)
- [English Version](#english)
- [Project Report / 專題報告](./沈龍翔_黃光儀_期末project.pdf)
- [Demo Video / 展示影片](./數位矽智產設計導論_期末project.mp4)
- [Source Archive / 原始碼壓縮檔](./Verilog%20source%20codes.zip)

---

# 中文版

## 專案概述

本專案於國立中興大學《數位矽智產設計導論》課程中完成，目標為在 **ZedBoard Zynq-7000 SoC** 平台上，建立一套可即時運作的 **電吉他多重效果器（multi-effects pedal）**。  
系統以 **PS/PL 協同架構**為核心，透過 **ADAU1761 Audio Codec** 處理類比/數位音訊轉換，並將音訊效果演算法從傳統 DSP / 軟體處理流程，遷移至 **FPGA Programmable Logic (PL)** 實現，以驗證 FPGA 在低延遲即時訊號處理上的優勢。

本系統支援以下 4 類效果：

- **Distortion / Overdrive**
- **Octavelo**（Octaver + Tremolo 的實驗性混合效果）
- **Tremolo**
- **Delay**

使用者可透過板上 **switches / buttons / LEDs** 選擇效果、切換參數，並將多個效果串接成效果鏈，形成具即時互動能力的硬體原型。

---

## 專案特色

### 1. 以 FPGA 實作即時音訊處理
- 將音訊演算法從一般 CPU / DSP 流程搬移到 FPGA PL。
- 驗證硬體平行處理在即時音訊效果器上的可行性。

### 2. PS / PL 協同設計
- **PS（ARM Cortex-A9）**：負責基礎控制、AXI 操作、Codec 初始化與 I2C 設定。
- **PL（FPGA Logic）**：負責音訊效果處理、時脈生成、使用者介面控制與資料流路徑。

### 3. 多效果器鏈（Effects Chain）
系統效果鏈順序如下：

`Distortion / Overdrive → Octavelo → Tremolo → Delay`

此配置符合常見樂器效果器鏈的設計邏輯，並可由使用者依需求開啟 / 關閉各效果模組。

### 4. 低延遲與資源可控
- Bypass 模式延遲約 **960 μs**
- 全效果串接延遲約 **1.1 ms**
- 在 ZedBoard 上保有相當低的 LUT / FF 使用率，且記憶體資源主要集中於 Delay / Octavelo 的 BRAM 緩衝設計

---

## 系統架構

### 音訊資料流

`Line-in → ADAU1761 ADC → I2S → Zed_Audio_Control → AXI → PS → PS_to_PL → Effects Chain in PL → PL_to_PS → PS → Zed_Audio_Control → I2S → ADAU1761 DAC → Line-out`

### 控制路徑

- **AXI4-Lite**：PS / PL 間控制與資料讀寫
- **I2C**：設定 ADAU1761 Audio Codec 寄存器
- **I2S**：音訊資料傳輸
- **Buttons / Switches / LEDs**：板上人機介面

---

## 個人貢獻

本專案為雙人期末專題，我主要聚焦於下列工作：

- **FPGA RTL / VHDL 設計**：將音訊效果演算法轉為硬體邏輯模組
- **SoC 架構整合**：規劃 PS / PL 音訊資料路徑與控制訊號路徑
- **AXI4-Lite / I2C / I2S 介面整合**：完成 Codec、音訊資料、控制匯流排間之整合
- **Delay / Octavelo 記憶體配置**：使用 Dual-port BRAM 建立延遲緩衝架構
- **驗證與量測**：以 MATLAB 模擬、Vivado 合成 / 模擬與示波器量測完成功能驗證

---

## 技術棧

### Hardware / Platform
- ZedBoard
- Zynq-7000 SoC
- ADAU1761 Audio Codec

### HDL / Embedded Tools
- VHDL
- Vivado 2016.2
- Xilinx SDK 2016.2
- AXI4-Lite
- I2C
- I2S
- BRAM

### Verification / Algorithm Prototyping
- MATLAB
- Oscilloscope-based measurement

---

## 實作效果與效能

### 音訊規格
- Sampling Rate: **48.828 kHz**
- Audio Depth: **24-bit**（I2S serial audio）
- Internal Data Path: **32-bit**（AXI / internal processing）

### 效能指標
| 指標 | 數值 |
|---|---:|
| Bypass latency | 約 **960 μs** |
| Full-chain latency | 約 **1.1 ms** |
| Delay buffer size | **20,000 samples** |
| Max delay (approx.) | 約 **400 ms** |

### Post-Implementation Resource Utilization
| Resource | Utilization | Available | Utilization % |
|---|---:|---:|---:|
| LUT | 4465 | 53200 | 8.39% |
| LUTRAM | 68 | 17400 | 0.39% |
| FF | 1911 | 106400 | 1.80% |
| BRAM | 46 | 140 | 32.86% |
| DSP | 2 | 220 | 0.91% |
| IO | 28 | 200 | 14.00% |
| BUFG | 6 | 32 | 18.75% |

---

## 效果模組摘要

### Distortion / Overdrive
- 以非線性 wave-shaping / clipping 產生失真音色
- Overdrive 以 threshold clipping 模擬飽和效果
- Distortion 使用更細緻的分段波形塑形，產生更強烈的 harmonic content

### Tremolo
- 以三角波進行幅度調變（AM）
- 提供多組頻率設定，產生不同速度的音量起伏感

### Delay
- 同時實作 **FIR** 與 **IIR** delay 結構
- 透過 BRAM 緩衝儲存過往樣本，建立單次回聲與遞減式重複回聲

### Octavelo
- 結合 Octaver 與 Tremolo / Delay 概念的實驗性效果
- 支援上八度 / 下八度與不同內部設定

---

## Repository 內容

目前此 repo 對應你上傳的公開檔案如下：

```text
.
├── README.md
├── Verilog source codes.zip
├── 沈龍翔_黃光儀_期末project.pdf
└── 數位矽智產設計導論_期末project.mp4
```

### `Verilog source codes.zip` 內容摘要
> 注意：檔名雖寫為 **Verilog source codes**，但壓縮檔內主要內容實際上是 **VHDL + Vivado / SDK 專案檔**。

```text
Verilog source codes.zip
├── ip_repo/
│   ├── custom packaged IPs
│   │   ├── Distortion
│   │   ├── Delay
│   │   ├── Octaver / Octavelo
│   │   ├── Tremolo
│   │   ├── Control
│   │   ├── Clock Generator
│   │   ├── PS_to_PL
│   │   └── PL_to_PS
│   └── zed_audio_ctrl/
├── Meffects_constants_testing_3.xpr
├── Meffects_constants_testing_3.ip_user_files/
└── Meffects_constants_testing_3.sdk/
    ├── audio/
    │   └── src/
    └── audio_bsp/
```

### 檔案用途
- `沈龍翔_黃光儀_期末project.pdf`：完整期末報告與架構 / 效能 / 驗證說明
- `數位矽智產設計導論_期末project.mp4`：實機操作與效果展示影片
- `Verilog source codes.zip`：Vivado 專案、封裝 IP、SDK 程式與相關檔案

---

## 如何執行專案

### 環境需求
- ZedBoard / Zynq-7000 board
- Vivado 2016.2
- Xilinx SDK 2016.2
- JTAG / USB programming cable
- Guitar or audio source
- Amplifier / speakers / headphones

### 執行步驟
1. 下載或 clone 本 repository。
2. 解壓 `Verilog source codes.zip`。
3. 進入解壓後專案，開啟 `Meffects_constants_testing_3.xpr`。
4. 在 Vivado 中將 IP Repository 指向 `ip_repo`。
5. Launch SDK，開啟對應 workspace。
6. 將 bitstream 燒錄到 ZedBoard。
7. 執行 `audio` application on hardware。
8. 將音源接到 Line-in，將輸出接到 Line-out / Headphones。
9. 使用板上 switches / buttons 操作效果器。

---

## 板上操作方式

### Switches
- **左側 4 個 switches**：啟用 / 關閉 4 個效果模組
- **右側 4 個 switches**：選擇目前效果模組的內部參數設定

### Buttons / LEDs
- 使用按鍵在不同效果之間切換
- 以 LED 顯示當前選取效果
- 中央按鍵可進入 / 離開某效果的設定模式

---

## 建議的 GitHub 展示方式

如果你希望這個 repo 在 GitHub 上更專業，建議：

1. 保留目前的原始壓縮檔作為完整提交版本。
2. 額外建立一份解壓後的 `src/` 或 `vivado_project/` 版本，方便直接瀏覽原始碼。
3. 將 PDF 與 MP4 保留在 repo root 或 `docs/` / `media/` 資料夾中。
4. 若後續要長期維護，建議把自動產生的 cache / log / build artifacts 分離出去。

---

## 團隊與專案性質

- 課程：數位矽智產設計導論
- 類型：期末專題 / Academic Course Project
- 團隊成員：**Long-Xiang Shen（沈龍翔）**, **Kuang Yi Huang（黃光儀）**

---

## 注意事項

- 本 repository 以**學術展示 / 作品集呈現**為主要目的。
- 壓縮檔中保留了部分 Vivado / SDK 自動產生檔案，以確保重現性。
- 部分支援模組 / 設計流程與文獻、教學資源有關，正式二次散布前請自行檢查第三方授權、引用與 tutorial-derived components。

---

## Acknowledgements

This project was informed by FPGA / digital audio effects literature, the Zynq-Book ecosystem, and the ADAU1761 / ZedBoard technical documentation cited in the project report.

---

# English

## Overview

This project was completed as the final project for **Introduction to Digital Silicon IP Design** at National Chung Hsing University. The goal was to build a real-time **FPGA-based electric guitar multi-effects system** on the **ZedBoard Zynq-7000 SoC** platform.

The system uses a **PS/PL co-design architecture** together with the **ADAU1761 Audio Codec**. Instead of relying on a conventional software DSP pipeline, the core audio effects were migrated into **FPGA programmable logic (PL)** to validate the advantages of FPGA for real-time signal processing.

The implemented effects are:

- **Distortion / Overdrive**
- **Octavelo** (an experimental Octaver + Tremolo hybrid effect)
- **Tremolo**
- **Delay**

Users can enable/disable effects, switch configurations, and chain multiple effects in series using the on-board switches, buttons, and LEDs.

---

## Key Features

### 1. Real-time audio processing on FPGA
- Migrates audio effects from CPU/DSP-style software flow into PL hardware.
- Demonstrates low-latency, hardware-accelerated audio processing.

### 2. PS / PL co-design
- **PS (ARM Cortex-A9)** handles initialization, AXI transactions, and codec control.
- **PL** handles the audio effect chain, clocks, and on-board user interface logic.

### 3. Multi-effects chain
The processing order is:

`Distortion / Overdrive → Octavelo → Tremolo → Delay`

This ordering follows common guitar-effects placement practice and supports real-time serial chaining.

### 4. Low latency with practical resource usage
- ~**960 μs** latency in bypass mode
- ~**1.1 ms** latency with all effects enabled
- BRAM-heavy design for time-based effects while maintaining low LUT / FF utilization

---

## System Architecture

### Audio data path

`Line-in → ADAU1761 ADC → I2S → Zed_Audio_Control → AXI → PS → PS_to_PL → Effects Chain in PL → PL_to_PS → PS → Zed_Audio_Control → I2S → ADAU1761 DAC → Line-out`

### Control path

- **AXI4-Lite** for PS/PL interconnection and register-based control
- **I2C** for codec register configuration
- **I2S** for digital audio transport
- **Buttons / Switches / LEDs** for local user interaction

---

## My Contribution

This was a two-person final project. My main contributions focused on:

- **FPGA RTL / VHDL design** for audio effect modules
- **SoC integration** across PS and PL data/control paths
- **AXI4-Lite / I2C / I2S integration** for audio and codec communication
- **Delay / Octavelo memory design** using dual-port BRAM buffers
- **Validation and debugging** with MATLAB simulations, Vivado synthesis/simulation, and oscilloscope measurements

---

## Tech Stack

### Hardware / Platform
- ZedBoard
- Zynq-7000 SoC
- ADAU1761 Audio Codec

### HDL / Embedded Tools
- VHDL
- Vivado 2016.2
- Xilinx SDK 2016.2
- AXI4-Lite
- I2C
- I2S
- BRAM

### Verification / Prototyping
- MATLAB
- Oscilloscope-based measurement

---

## Performance Summary

### Audio specification
- Sampling rate: **48.828 kHz**
- Audio depth: **24-bit** serial audio
- Internal processing path: **32-bit**

### Performance metrics
| Metric | Value |
|---|---:|
| Bypass latency | ~**960 μs** |
| Full-chain latency | ~**1.1 ms** |
| Delay buffer size | **20,000 samples** |
| Maximum delay | ~**400 ms** |

### Post-implementation utilization
| Resource | Utilization | Available | Utilization % |
|---|---:|---:|---:|
| LUT | 4465 | 53200 | 8.39% |
| LUTRAM | 68 | 17400 | 0.39% |
| FF | 1911 | 106400 | 1.80% |
| BRAM | 46 | 140 | 32.86% |
| DSP | 2 | 220 | 0.91% |
| IO | 28 | 200 | 14.00% |
| BUFG | 6 | 32 | 18.75% |

---

## Effect Modules

### Distortion / Overdrive
- Non-linear wave-shaping / clipping for distorted guitar tone
- Overdrive uses threshold clipping to emulate saturation
- Distortion uses more aggressive segmented shaping for richer harmonics

### Tremolo
- Amplitude modulation with triangular wave envelopes
- Multiple selectable modulation rates

### Delay
- Implements both **FIR** and **IIR** delay structures
- Uses BRAM-based sample buffering for time-based echo / reverb-like behavior

### Octavelo
- Experimental hybrid effect combining octaver-style pitch manipulation with time/modulation ideas
- Supports octave up / octave down style variations

---

## Repository Contents

This repository is based on the uploaded project files:

```text
.
├── README.md
├── Verilog source codes.zip
├── 沈龍翔_黃光儀_期末project.pdf
└── 數位矽智產設計導論_期末project.mp4
```

### `Verilog source codes.zip` summary
> Although the archive name says **Verilog**, the implementation inside is primarily **VHDL**, together with Vivado and Xilinx SDK project files.

```text
Verilog source codes.zip
├── ip_repo/
│   ├── custom packaged IPs
│   │   ├── Distortion
│   │   ├── Delay
│   │   ├── Octaver / Octavelo
│   │   ├── Tremolo
│   │   ├── Control
│   │   ├── Clock Generator
│   │   ├── PS_to_PL
│   │   └── PL_to_PS
│   └── zed_audio_ctrl/
├── Meffects_constants_testing_3.xpr
├── Meffects_constants_testing_3.ip_user_files/
└── Meffects_constants_testing_3.sdk/
    ├── audio/
    │   └── src/
    └── audio_bsp/
```

### File roles
- `沈龍翔_黃光儀_期末project.pdf`: full report including architecture, algorithms, validation, and measured results
- `數位矽智產設計導論_期末project.mp4`: hardware demonstration video
- `Verilog source codes.zip`: Vivado project, packaged IP blocks, SDK application, and supporting files

---

## How to Run

### Requirements
- ZedBoard / Zynq-7000 hardware
- Vivado 2016.2
- Xilinx SDK 2016.2
- JTAG / USB programming cable
- Guitar or line-level audio source
- Amplifier / speakers / headphones

### Steps
1. Clone or download this repository.
2. Extract `Verilog source codes.zip`.
3. Open `Meffects_constants_testing_3.xpr` in Vivado.
4. Set the IP repository path to `ip_repo`.
5. Launch the SDK workspace.
6. Program the FPGA with the existing bitstream.
7. Run the `audio` application on hardware.
8. Connect audio input to Line-in and output to Line-out / headphones.
9. Use the board switches and buttons to interact with the effect chain.

---

## On-board Controls

### Switches
- **Left 4 switches**: enable / bypass the four effect blocks
- **Right 4 switches**: select internal options for the currently selected effect

### Buttons / LEDs
- Buttons are used for effect navigation and selection
- LEDs indicate which effect is currently selected
- The center button enters / exits configuration mode

---

## Recommended GitHub Presentation Style

For a more polished public portfolio repository, you may want to:

1. Keep the uploaded archive as the reproducible original submission.
2. Add an unpacked `src/` or `vivado_project/` version for direct code browsing.
3. Keep the PDF report and MP4 demo either in the repo root or under `docs/` / `media/`.
4. Separate generated cache / build artifacts if you plan to maintain the project long term.

---

## Team and Context

- Course: Introduction to Digital Silicon IP Design
- Type: Final course project / academic prototype
- Team members: **Long-Xiang Shen**, **Kuang Yi Huang**

---

## Notes

- This repository is intended primarily for **academic showcase / portfolio presentation**.
- The source archive preserves a number of auto-generated Vivado / SDK files for reproducibility.
- Before redistributing or repackaging the full project, please review any third-party/tutorial-derived components and their licenses.

---

## Acknowledgements

This work was informed by FPGA audio-effects literature, the Zynq-Book ecosystem, and the technical documentation for ZedBoard and ADAU1761 cited in the project report.
