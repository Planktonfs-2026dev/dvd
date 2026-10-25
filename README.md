# 4-bit Array Multiplier
TEST
- Attempt 1: CLOCK_PERIOD = 4.0 ns, setup slack -0.011395329447034534 ns at nom_slow_1p08V_125C; LVS and DRC passed
- Attempt 2: CLOCK_PERIOD = 4.5 ns, flow completed with LVS, DRC and setup passing
- SKY130 attempt at 4.5 ns: setup violations at ss_100C_1v60 corners; period increased
- Final passing run: CLOCK_PERIOD = 7.0 ns on SKY130 (ss corners). Failed attempts logged as pnr/run_*ns.log.
- Final passing run: CLOCK_PERIOD = 7.0 ns, SKY130 ss corners, LVS and DRC clean. Failed attempts are in pnr/run_*ns.log.
