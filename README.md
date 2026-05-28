# 🎲 Dice Game - VHDL Implementation

<a id="overview"></a>
## Overview
A hardware implementation of the **Craps dice game** using VHDL with a structural architecture consisting of an FSM controller and independent datapath components.

## 📋 Table of Contents
- [Overview](#overview)
- [Project Structure](#project-structure)
- [Game Rules](#game-rules)
- [Entity Interface](#entity-interface)
- [Architecture](#architecture)
- [Simulation](#simulation)
- [Author](#author)


<a id="project-structure"></a>
## 📁 Project Structure

```
Craps Game/  
├── 📂 SRC  
│   ├── 📜 runner.sh 
│   ├── 📂 RTL  
│   │   ├── 🎲 DiceGame.vhd  
│   │   ├── 📂 Controller  
│   │   │   └──⚙️ FSM.vhd  
│   │   └── 📂 DataPath  
│   │      ├── ➕ Adder.vhd    
│   │      ├── ⚖️ Comparator.vhd  
│   │      ├── 💾 PointReg.vhd  
│   │      ├── 📟 7-Seg.vhd  
│   │      └── 🔍 Testlogic.vhd  
│   └── 📂 TB  
│      ├── 🧪 TB_Adder.vhd  
│      ├── 🧪 TB_Comparator.vhd  
│      ├── 🧪 TB_counter.vhd  
│      ├── 🧪 TB_DiceGame.vhd  
│      ├── 🧪 TB_FSM.vhd  
│      ├── 🧪 TB_PointReg.vhd  
│      ├── 🧪 TB_SevenSEg.vhd  
│      └── 🧪 TB_TestLogic.vhd  
└── 📂 WaveForms  
```

<a id="game-rules"></a>
## 🎯 Game Rules

This implementation follows the standard **Craps** dice game rules based on the VHDL code.


### 📊 Win/Loss Detection Signals

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #4CAF50; color: white;">
      <th style="padding: 10px; text-align: left;">Condition</th>
      <th style="padding: 10px; text-align: left;">Detection Signal</th>
      <th style="padding: 10px; text-align: left;">Result</th>
     </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 8px;">Sum = 7</td>
      <td style="padding: 8px;"><code>D7 = '1'</code></td>
      <td style="padding: 8px;">Lose on subsequent rolls</td>
     </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px;">Sum = 7 or 11</td>
      <td style="padding: 8px;"><code>D711 = '1'</code></td>
      <td style="padding: 8px; color: green; font-weight: bold;">WIN on first roll 🎉</td>
     </tr>
    <tr>
      <td style="padding: 8px;">Sum = 2, 3, or 12</td>
      <td style="padding: 8px;"><code>D2312 = '1'</code></td>
      <td style="padding: 8px; color: red; font-weight: bold;">LOSE on first roll 💀</td>
     </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px;">Sum = Point (saved value)</td>
      <td style="padding: 8px;"><code>eq = '1'</code></td>
      <td style="padding: 8px; color: green; font-weight: bold;">WIN on subsequent rolls ✅</td>
     </tr>
  </tbody>
</table>


### 🎲 FSM States

The controller has **5 states**:

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #2196F3; color: white;">
      <th style="padding: 10px; text-align: left;">State</th>
      <th style="padding: 10px; text-align: left;">Description</th>
      <th style="padding: 10px; text-align: left;">Outputs</th>
     </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 8px;"><code>WAITING</code></td>
      <td style="padding: 8px;">Waiting for player to press roll button</td>
      <td style="padding: 8px;">All outputs = 0</td>
     </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px;"><code>FIRST_ROLL</code></td>
      <td style="padding: 8px;">First dice roll of the game</td>
      <td style="padding: 8px;"><code>roll_en = 1</code> (while button pressed)</td>
     </tr>
    <tr>
      <td style="padding: 8px;"><code>OTHERROLLS</code></td>
      <td style="padding: 8px;">Subsequent rolls after point is set</td>
      <td style="padding: 8px;"><code>roll_en = 1</code> (while button pressed)</td>
     </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px;"><code>WIN_STATE</code></td>
      <td style="padding: 8px;">Game won, victory displayed</td>
      <td style="padding: 8px;"><code>win = 1</code></td>
     </tr>
    <tr>
      <td style="padding: 8px;"><code>LOSE_STATE</code></td>
      <td style="padding: 8px;">Game lost, defeat displayed</td>
      <td style="padding: 8px;"><code>lose = 1</code></td>
     </tr>
  </tbody>
</table>


### 🔄 State Transition

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #FF9800; color: white;">
      <th style="padding: 10px; text-align: center;">Current State</th>
      <th style="padding: 10px; text-align: center;">Condition</th>
      <th style="padding: 10px; text-align: center;">Next State</th>
      <th style="padding: 10px; text-align: center;">Action</th>
     </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 8px;"><code>WAITING</code></td>
      <td style="padding: 8px;"><code>roll_btn = '1'</code></td>
      <td style="padding: 8px;"><code>FIRST_ROLL</code></td>
      <td style="padding: 8px;">Start game</td>
     </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px;"><code>FIRST_ROLL</code></td>
      <td style="padding: 8px;"><code>D711 = '1'</code></td>
      <td style="padding: 8px;"><code>WIN_STATE</code></td>
      <td style="padding: 8px;">Win on first roll (7 or 11)</td>
     </tr>
    <tr>
      <td style="padding: 8px;"><code>FIRST_ROLL</code></td>
      <td style="padding: 8px;"><code>D2312 = '1'</code></td>
      <td style="padding: 8px;"><code>LOSE_STATE</code></td>
      <td style="padding: 8px;">Lose on first roll (2,3,12)</td>
     </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px;"><code>FIRST_ROLL</code></td>
      <td style="padding: 8px;"><code>otherwise</code></td>
      <td style="padding: 8px;"><code>OTHERROLLS</code></td>
      <td style="padding: 8px;">Save point, continue game</td>
     </tr>
    <tr>
      <td style="padding: 8px;"><code>OTHERROLLS</code></td>
      <td style="padding: 8px;"><code>eq = '1'</code></td>
      <td style="padding: 8px;"><code>WIN_STATE</code></td>
      <td style="padding: 8px;">Win by matching point</td>
     </tr>
    <tr style="background-color: #f9f9f9;">
      <td style="padding: 8px;"><code>OTHERROLLS</code></td>
      <td style="padding: 8px;"><code>D7 = '1'</code></td>
      <td style="padding: 8px;"><code>LOSE_STATE</code></td>
      <td style="padding: 8px;">Lose by rolling 7</td>
     </tr>
    <tr>
      <td style="padding: 8px;"><code>OTHERROLLS</code></td>
      <td style="padding: 8px;"><code>otherwise</code></td>
      <td style="padding: 8px;"><code>OTHERROLLS</code></td>
      <td style="padding: 8px;">Continue rolling</td>
     </tr>
  </tbody>
</table>


### 🎲 First Roll Outcomes

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #9C27B0; color: white;">
      <th style="padding: 10px; text-align: center;">Sum</th>
      <th style="padding: 10px; text-align: center;">Dice Combinations</th>
      <th style="padding: 10px; text-align: center;">Result</th>
     </tr>
  </thead>
  <tbody>
    <tr style="background-color: #e8f5e9;">
      <td style="padding: 8px; text-align: center;"><b>7</b></td>
      <td style="padding: 8px;">1+6, 2+5, 3+4, 4+3, 5+2, 6+1</td>
      <td style="padding: 8px; text-align: center;">🎉 <b style="color: green;">WIN</b></td>
     </tr>
    <tr style="background-color: #e8f5e9;">
      <td style="padding: 8px; text-align: center;"><b>11</b></td>
      <td style="padding: 8px;">5+6, 6+5</td>
      <td style="padding: 8px; text-align: center;">🎉 <b style="color: green;">WIN</b></td>
     </tr>
    <tr style="background-color: #ffebee;">
      <td style="padding: 8px; text-align: center;"><b>2</b></td>
      <td style="padding: 8px;">1+1</td>
      <td style="padding: 8px; text-align: center;">💀 <b style="color: red;">LOSE</b></td>
     </tr>
    <tr style="background-color: #ffebee;">
      <td style="padding: 8px; text-align: center;"><b>3</b></td>
      <td style="padding: 8px;">1+2, 2+1</td>
      <td style="padding: 8px; text-align: center;">💀 <b style="color: red;">LOSE</b></td>
     </tr>
    <tr style="background-color: #ffebee;">
      <td style="padding: 8px; text-align: center;"><b>12</b></td>
      <td style="padding: 8px;">6+6</td>
      <td style="padding: 8px; text-align: center;">💀 <b style="color: red;">LOSE</b></td>
     </tr>
    <tr style="background-color: #fff3e0;">
      <td style="padding: 8px; text-align: center;"><b>4</b></td>
      <td style="padding: 8px;">1+3, 2+2, 3+1</td>
      <td style="padding: 8px; text-align: center;">📌 Save as <b>POINT</b> → Continue</td>
     </tr>
    <tr style="background-color: #fff3e0;">
      <td style="padding: 8px; text-align: center;"><b>5</b></td>
      <td style="padding: 8px;">1+4, 2+3, 3+2, 4+1</td>
      <td style="padding: 8px; text-align: center;">📌 Save as <b>POINT</b> → Continue</td>
     </tr>
    <tr style="background-color: #fff3e0;">
      <td style="padding: 8px; text-align: center;"><b>6</b></td>
      <td style="padding: 8px;">1+5, 2+4, 3+3, 4+2, 5+1</td>
      <td style="padding: 8px; text-align: center;">📌 Save as <b>POINT</b> → Continue</td>
     </tr>
    <tr style="background-color: #fff3e0;">
      <td style="padding: 8px; text-align: center;"><b>8</b></td>
      <td style="padding: 8px;">2+6, 3+5, 4+4, 5+3, 6+2</td>
      <td style="padding: 8px; text-align: center;">📌 Save as <b>POINT</b> → Continue</td>
     </tr>
    <tr style="background-color: #fff3e0;">
      <td style="padding: 8px; text-align: center;"><b>9</b></td>
      <td style="padding: 8px;">3+6, 4+5, 5+4, 6+3</td>
      <td style="padding: 8px; text-align: center;">📌 Save as <b>POINT</b> → Continue</td>
     </tr>
    <tr style="background-color: #fff3e0;">
      <td style="padding: 8px; text-align: center;"><b>10</b></td>
      <td style="padding: 8px;">4+6, 5+5, 6+4</td>
      <td style="padding: 8px; text-align: center;">📌 Save as <b>POINT</b> → Continue</td>
     </tr>
  </tbody>
</table>


### 🎲 Subsequent Rolls Outcomes

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #607D8B; color: white;">
      <th style="padding: 10px; text-align: center;">Condition</th>
      <th style="padding: 10px; text-align: center;">Result</th>
      <th style="padding: 10px; text-align: center;">Action</th>
     </tr>
  </thead>
  <tbody>
    <tr style="background-color: #e8f5e9;">
      <td style="padding: 8px;">Sum = <b>Point</b> (saved value)</td>
      <td style="padding: 8px;">✅ <b style="color: green;">WIN</b></td>
      <td style="padding: 8px;"><code>win = 1</code> → Game ends</td>
     </tr>
    <tr style="background-color: #ffebee;">
      <td style="padding: 8px;">Sum = <b>7</b></td>
      <td style="padding: 8px;">❌ <b style="color: red;">LOSE</b></td>
      <td style="padding: 8px;"><code>lose = 1</code> → Game ends</td>
     </tr>
    <tr style="background-color: #fff3e0;">
      <td style="padding: 8px;">Other sums (4,5,6,8,9,10 except point)</td>
      <td style="padding: 8px;">🔄 <b>Continue</b></td>
      <td style="padding: 8px;">Roll again → Stay in <code>OTHERROLLS</code></td>
     </tr>
  </tbody>
</table>


### 🔄 Complete Game Flow Diagram

```
                    ┌─────────────────────────────────────┐
                    │            PRESS RESET              │
                    │         (reset_btn = 1)             │
                    └─────────────────┬───────────────────┘
                                      │
                                      ▼
                    ┌─────────────────────────────────────┐
                    │             WAITING STATE           │
                    │      (waiting for roll_btn)         │
                    └─────────────────┬───────────────────┘
                                      │
                                      │ roll_btn = 1
                                      │
                                      ▼
                    ┌─────────────────────────────────────┐
                    │           FIRST_ROLL STATE          │
                    │         (press and release)         │
                    └─────────────────┬───────────────────┘
                                      │
                                      │
            ┌─────────────────────────┼─────────────────────────┐
            │                         │                         │
            │                         │                         │
            ▼                         ▼                         ▼
    ┌────────────────┐       ┌────────────────┐         ┌────────────────┐
    │   D711 = 1     │       │   D2312 = 1    │         │   otherwise    │
    │   (7 or 11)    │       │   (2,3,12)     │         │                │
    └───────┬────────┘       └───────┬────────┘         └───────┬────────┘
            │                        │                          │
            │                        │                          │
            ▼                        ▼                          ▼
    ┌────────────────┐       ┌────────────────┐         ┌────────────────┐
    │   WIN_STATE    │       │   LOSE_STATE   │         │  SAVE POINT    │
    │    win = 1     │       │    lose = 1    │         │  store_p = 1   │
    └────────────────┘       └────────────────┘         └───────┬────────┘
                                                                │
                                                                │
                                                                ▼
                                                       ┌─────────────────┐
                                                       │ OTHERROLLS STATE│
                                                       │   (roll again)  │
                                                       └────────┬────────┘
                                                                │
                                                                │
                                          ┌─────────────────────┼──────────────────────┐
                                          │                     │                      │
                                          │                     │                      │
                                          ▼                     ▼                      ▼
                                 ┌────────────────┐     ┌────────────────┐     ┌────────────────┐
                                 │    eq = 1      │     │    D7 = 1      │     │   otherwise    │
                                 │ (sum = point)  │     │   (sum = 7)    │     │                │
                                 └───────┬────────┘     └───────┬────────┘     └───────┬────────┘
                                         │                      │                      │
                                         │                      │                      │
                                         ▼                      ▼                      │
                                 ┌────────────────┐     ┌────────────────┐             │
                                 │   WIN_STATE    │     │   LOSE_STATE   │             │
                                 │    win = 1     │     │    lose = 1    │             │
                                 └────────────────┘     └────────────────┘             │
                                                                                       │
                                                                                       │
                                                                                       ▼
                                                                               ┌────────────────┐
                                                                               │   CONTINUE     │
                                                                               │  (roll again)  │
                                                                               └────────────────┘

```

### 💡 Important Implementation Notes

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <tbody>
    <tr style="background-color: #f0f0f0;">
      <td style="padding: 8px; font-weight: bold;">Counter Range</td>
      <td style="padding: 8px;">1 to 6 (binary: 001 to 110) - No zero value</td>
     </tr>
    <tr>
      <td style="padding: 8px; font-weight: bold;">Dice Capture</td>
      <td style="padding: 8px;">Values are captured on <b>button release</b> (<code>roll_btn_prev = '1' and roll_btn = '0'</code>)</td>
     </tr>
    <tr style="background-color: #f0f0f0;">
      <td style="padding: 8px; font-weight: bold;">Point Register</td>
      <td style="padding: 8px;">Stores first roll sum (4-bit: values 4,5,6,8,9,10)</td>
     </tr>
    <tr>
      <td style="padding: 8px; font-weight: bold;">7-Segment Display</td>
      <td style="padding: 8px;">Active low outputs (common anode)</td>
     </tr>
    <tr style="background-color: #f0f0f0;">
      <td style="padding: 8px; font-weight: bold;">Reset Behavior</td>
      <td style="padding: 8px;">Active-high reset (<code>reset = '1'</code> initializes all registers)</td>
     </tr>
    <tr>
      <td style="padding: 8px; font-weight: bold;">Clock Edge</td>
      <td style="padding: 8px;">All sequential logic uses <b>rising edge</b> (<code>rising_edge(clk)</code>)</td>
     </tr>
  </tbody>
</table>

---

<br>

<a id="entity-interface"></a>
## 🔌 Entity Interface

**CrapsGame (Top Level)**

<table border="1" cellpadding="8" cellspacing="0">
  <thead>
    <tr style="background-color: #f0f0f0;">
      <th>Port</th>
      <th>Direction</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>clk</td>
      <td style="text-align: center;">in</td>
      <td>std_logic</td>
      <td>System clock</td>
    </tr>
    <tr>
      <td>reset</td>
      <td style="text-align: center;">in</td>
      <td>std_logic</td>
      <td>Active-high reset</td>
    </tr>
    <tr>
      <td>roll</td>
      <td style="text-align: center;">in</td>
      <td>std_logic</td>
      <td>Roll button (active-high)</td>
    </tr>
    <tr>
      <td>seg1</td>
      <td style="text-align: center;">out</td>
      <td>std_logic_vector(6 downto 0)</td>
      <td>7-segment display for die 1</td>
    </tr>
    <tr>
      <td>seg2</td>
      <td style="text-align: center;">out</td>
      <td>std_logic_vector(6 downto 0)</td>
      <td>7-segment display for die 2</td>
    </tr>
    <tr>
      <td>win_led</td>
      <td style="text-align: center;">out</td>
      <td>std_logic</td>
      <td>Win indicator LED</td>
    </tr>
    <tr>
      <td>lose_led</td>
      <td style="text-align: center;">out</td>
      <td>std_logic</td>
      <td>Lose indicator LED</td>
    </tr>
  </tbody>
</table>

<br>

<a id="architecture"></a>
## 🏗️ Architecture

```
DiceGame (Top Level)
│
├── Counter (x2)
│   └── 3-bit counter (counts 1 to 6)
│
├── Adder
│   └── Adds two dice values (3-bit → 4-bit sum)
│
├── Point Register
│   └── Stores the point value from first roll
│
├── Comparator
│   └── Compares current sum with stored point
│
├── Test Logic
│   ├── D7    (sum = 7)
│   ├── D711  (sum = 7 or 11)
│   └── D2312 (sum = 2, 3, or 12)
│
├── Seven Segment (x2)
│   └── Decodes dice value to 7-segment display
│
└── FSM Controller
    ├── States: WAITING → FIRST_ROLL → OTHERROLLS → WIN/LOSE
    └── Outputs: roll_en, store_p, win, lose
```

<a id="simulation"></a>
## 🚀 Simulation

**Prerequisites**  
+ [ghdl](https://ghdl.github.io/ghdl/) - VHDL Compiler and simulator
+ [Gtkwave](https://gtkwave.sourceforge.net/) - WaveForms viewer (optional)

**Code Running**  

Run the complete TestBench:  

```
cd SRC
./CodeRunner.sh
```
This will:  
 + Compile every RTL file in dependency order
 + Compile the TestBench
 + Generate Waveform file
 + Runs the simulation for the time shown in the table below :

  
   <table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
  <thead>
    <tr style="background-color: #4CAF50; color: white;">
      <th style="padding: 10px; text-align: left;">#</th>
      <th style="padding: 10px; text-align: left;">Name</th>
      <th style="padding: 10px; text-align: left;">Nanoseconds (ns)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="padding: 8px; text-align: left;">1</td>
      <td style="padding: 8px; text-align: left;">Counter Test</td>
      <td style="padding: 8px; text-align: left; background-color: #f0f0f0;">500 ns</td>
    </tr>
    <tr>
      <td style="padding: 8px; text-align: left;">2</td>
      <td style="padding: 8px; text-align: left;">Seven Segment Test</td>
      <td style="padding: 8px; text-align: left; background-color: #f0f0f0;">100 ns</td>
    </tr>
    <tr>
      <td style="padding: 8px; text-align: left;">3</td>
      <td style="padding: 8px; text-align: left;">Adder Test</td>
      <td style="padding: 8px; text-align: left; background-color: #f0f0f0;">100 ns</td>
    </tr>
    <tr>
      <td style="padding: 8px; text-align: left;">4</td>
      <td style="padding: 8px; text-align: left;">Point Register Test</td>
      <td style="padding: 8px; text-align: left; background-color: #f0f0f0;">200 ns</td>
    </tr>
    <tr>
      <td style="padding: 8px; text-align: left;">5</td>
      <td style="padding: 8px; text-align: left;">Comparator Test</td>
      <td style="padding: 8px; text-align: left; background-color: #f0f0f0;">100 ns</td>
    </tr>
    <tr>
      <td style="padding: 8px; text-align: left;">6</td>
      <td style="padding: 8px; text-align: left;">Test Logic Test</td>
      <td style="padding: 8px; text-align: left; background-color: #f0f0f0;">200 ns</td>
    </tr>
    <tr>
      <td style="padding: 8px; text-align: left;">7</td>
      <td style="padding: 8px; text-align: left;">FSM Controller Test</td>
      <td style="padding: 8px; text-align: left; background-color: #f0f0f0;">500 ns</td>
    </tr>
    <tr style="background-color: #e0e0e0; font-weight: bold;">
      <td style="padding: 8px; text-align: left;">8</td>
      <td style="padding: 8px; text-align: left;">Complete System Test</td>
      <td style="padding: 8px; text-align: left; background-color: #ffe0b3;">1000 ns</td>
    </tr>
  </tbody>
  <tfoot>
    <tr style="background-color: #f9f9f9;">
      <td colspan="2" style="padding: 8px; text-align: right; font-weight: bold;">Total:</td>
      <td style="padding: 8px; text-align: left; font-weight: bold; background-color: #e0e0e0;">2700 ns</td>
    </tr>
  </tfoot>
</table>

 #### The remarkable thing is that the CodeRunner will automatically show you every WaveForm just press **Enter** after each time you close the WaveForm tab to see the next WaveForm

<a id="author"></a>
## 👤 Author
VHDL Craps Game Implemented by [Pouyamaleki](github.com/Pouyamaleki)
