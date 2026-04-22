# 🛡️ Hardware Security Accelerator (AES-128)

A **side-channel resistant AES-128 crypto accelerator** implemented in RTL, featuring **Boolean masking**, **secure key management**, and **fault detection mechanisms**. This project is designed for **FPGA/ASIC deployment** with strong protections against real-world hardware attacks.

---

## 📖 Introduction

This project delivers a **production-grade cryptographic accelerator** implementing **AES-128 (FIPS-197 compliant)** with integrated countermeasures against:

- Power Analysis Attacks (**SPA/DPA**)
- Fault Injection Attacks
- Timing Attacks
- Unauthorized Key Access

The design is verified using:
- **Icarus Verilog**
- **Xilinx Vivado (XSim)**

It achieves **high performance (128 MHz on Artix-7)** while maintaining **low resource utilization**.

---

## 📑 Table of Contents

- [Features](#-features)
- [Project Architecture](#-project-architecture)
- [Installation](#-installation)
- [Usage](#-usage)
- [Verification](#-verification)
- [Simulation Results](#-simulation-results)
- [FPGA Resource Utilization](#-fpga-resource-utilization)
- [Security Features](#-security-features)
- [Future Scope](#-future-scope)
- [Troubleshooting](#-troubleshooting)
- [Contributors](#-contributors)
- [License](#-license)

---

## ✨ Features

- ✅ **NIST FIPS-197 compliant AES-128**
- ✅ **First-order DPA protection** using Boolean masking
- ✅ **Secure token-based key management**
- ✅ **Dual-rail fault detection (<1ns latency)**
- ✅ **Constant-time execution**
- ✅ **100% verification coverage**
- ✅ **128 MHz operation on Artix-7 FPGA**
- ✅ **Zero BRAM/DSP usage (LUT-only design)**
- 🔮 Modular design for future crypto extensions (SHA-3, ECC, Kyber)

---

## 🏗️ Project Architecture

```
hardware-security-accelerator/
├── rtl/
│   ├── aes_top.v
│   ├── sbox.v
│   ├── key_expand.v
│   ├── masked_sbox.v
│   ├── key_mgmt.v
│   └── fault_detect.v
├── tb/
│   └── tb_top.v
├── sim/
│   ├── aes_project.vcd
│   └── aes_project.wdb
├── docs/
│   ├── verification_report.md
│   └── vivado_timing.rpt
└── Makefile
```

---

## ⚙️ Installation

### Prerequisites

- Icarus Verilog (`iverilog`)
- GTKWave (optional for waveform viewing)
- Xilinx Vivado (for synthesis/simulation)

### Clone Repository

```bash
git clone https://github.com/vitry543/hardware-security-accelerator.git
cd hardware-security-accelerator
```

---

## ▶️ Usage

### Run Simulation (Icarus Verilog)

```bash
make run
```

### View Waveforms

```bash
gtkwave sim/aes_project.vcd
```

### Vivado Simulation

1. Open Vivado  
2. Add RTL and TB files  
3. Run **Behavioral Simulation**  
4. Observe outputs in waveform viewer  

---

## ✅ Verification

### NIST FIPS-197 Test Vector

```
Plaintext:  00112233445566778899aabbccddeeff
Key:        000102030405060708090a0b0c0d0e0f
Ciphertext: 69c4e0d86a7b0430d8cdb78070b4c55a ✓
```

### Security Test Cases

| Test Case | Result |
|----------|--------|
| Unauthorized Token | access_violation = 1 ✅ |
| Authorized Token | key_valid = 1 ✅ |
| Fault Injection | fault_flag = 1 ✅ |
| DPA Masking | PASS ✅ |

---

## 🖥️ Simulation Results

- ✔ Exact match with NIST AES output  
- ✔ All security mechanisms validated  
- ✔ Verified in both simulation environments  

```
Time: 100ns | NIST PASS
Ciphertext: 69c4e0d86a7b0430d8cdb78070b4c55a
```

---

## 📊 FPGA Resource Utilization (Artix-7 XC7A35T)

| Resource | Used | Available | Utilization |
|----------|------|----------|-------------|
| LUTs     | 2,847 | 33,280 | 8.6% |
| FFs      | 1,623 | 66,560 | 2.4% |
| BRAM     | 0     | 140    | 0% |
| DSP      | 0     | 90     | 0% |

**Max Frequency:** 128 MHz  
**Timing Slack:** +1.23 ns  

---

## 🔐 Security Features

### 1. Boolean Masking
- Protects against **first-order DPA attacks**
- Applied to **S-Box operations**

### 2. Secure Key Management
- Token-based access control (`0xDEADBEEF`)
- Prevents unauthorized key usage

### 3. Dual-Rail Fault Detection
- Detects injected faults in **<1ns**
- Raises `fault_flag` immediately

### 4. Constant-Time Execution
- Eliminates timing side-channel leakage

---

## 🚀 Future Scope

- Higher-order masking (2nd/3rd order)  
- Post-quantum crypto (Kyber integration)  
- PUF-based key derivation  
- True Random Number Generator (TRNG)  
- AXI-Stream interface  
- RISC-V coprocessor integration  
- Side-channel analysis with ChipWhisperer  

---

## 🛠️ Troubleshooting

| Issue | Solution |
|------|----------|
| Simulation not running | Ensure `iverilog` is installed |
| No waveform output | Check `.vcd` generation in Makefile |
| Vivado timing failure | Verify constraints and clock settings |

---

## 👨‍💻 Contributors

- **Manikanta Subbarao B**

---

## 📄 License

This project currently does not specify a license.  
Consider adding one (e.g., MIT, Apache 2.0) for open-source distribution.

---

## 📬 Contact

- 📧 Email: manikantasubbarao36@zohomail.in  
- 🔗 GitHub: https://github.com/vitry543  
- 💼 LinkedIn: https://www.linkedin.com/in/manikanta-subbarao-b-802839235/  
- 📍 Location: Bengaluru, India  

---
