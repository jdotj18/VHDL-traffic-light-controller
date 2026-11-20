# CEG3155 Lab 3: Traffic Light Controller

A traffic light controller for the intersection of a main street and a side street, written in structural VHDL and targeting the Digilent Nexys A7-100T (CEG3155 Digital Systems II, uOttawa).

The main street stays green by default. Once its minimum green time (`MSC_MAX` seconds) has passed and a car is waiting on the side street (`CAPTEUR`), the controller runs yellow on the main street and then gives the side street its green (`SSC_MAX` seconds) and yellow before returning to the main street.

## Design

The design is split into a controller and a datapath.

**Controller (`fsm_controller`):** a Moore FSM with four Gray-coded states held in two D flip-flops.

| State | Code | Main street | Side street |
|-------|------|-------------|-------------|
| MG    | 00   | Green       | Red         |
| MY    | 01   | Yellow      | Red         |
| SG    | 11   | Red         | Green       |
| SY    | 10   | Red         | Yellow      |

**Datapath (`datapath`):**
- Two 4-bit green counters, one for the main street and one for the side street
- 2-to-1 muxes that use `SEL` to choose which counter and which max value to compare
- A 4-bit equality comparator that raises `CE` when the green time has expired
- A yellow timer that raises `MST` after 3 s (main street) or `SST` after 2 s (side street)

**Support blocks:**
- `clk_divider`: 1 Hz enable tick from the 100 MHz clock
- `debouncer`: cleans up the sensor push button (10 ms sampling)

Every block is built structurally from the basic components (`dFF`, `regN`, `fullAdder`, `addSubN`, `mux2N`).

## Layout

```
sources/       design files (top level: diagram_final_lab3.vhd)
sim/           one testbench per component (tb_<name>.vhd)
constraints/   Nexys A7-100T pin assignments (nexys_a7_lab3.xdc)
```

## Board I/O (Nexys A7-100T)

| Signal        | Board          |
|---------------|----------------|
| `CLOCK`       | 100 MHz oscillator |
| `RESETBAR`    | CPU RESET button (active low) |
| `LOAD_FSM`    | SW0 (run enable) |
| `MSC_MAX[3:0]`| SW4–SW1 |
| `SSC_MAX[3:0]`| SW8–SW5 |
| `CAPTEUR`     | BTNU (car sensor) |
| `MSTL[2:0]`   | RGB LED LD16 (green / yellow (blue) / red) |
| `SSTL[2:0]`   | RGB LED LD17 (green / yellow (blue) / red) |

## Running it

**Vivado**
1. Create an RTL project for part `xc7a100tcsg324-1`.
2. Add everything in `sources/` as design sources and `constraints/nexys_a7_lab3.xdc` as a constraint.
3. Add the files in `sim/` as simulation sources. Set the testbench you want as the simulation top and run Behavioral Simulation.
4. To program the board, set `diagram_final_lab3` as the top module, generate the bitstream, and program the device.


The top-level testbench overrides the `G_TICK` and `G_DEB` generics so that one "second" lasts 1 µs, which lets a full light cycle finish in about 18 µs of simulated time.
