import re, glob, sys

run = sorted(glob.glob("runs/*/"), key=lambda p: __import__("os").path.getmtime(p))[-1]
files = [f for f in glob.glob(run + "**/*.rpt", recursive=True)
         if "Startpoint" in open(f, errors="ignore").read()]

best = None  # (slack, file, block_text)
for f in files:
    text = open(f, errors="ignore").read()
    # split into timing blocks, each starting at a "Startpoint"
    for block in re.split(r"(?=Startpoint:)", text)[1:]:
        m = re.search(r"([-\d.]+)\s+slack \((MET|VIOLATED)\)", block)
        if not m:
            continue
        slack = float(m.group(1))
        if best is None or slack < best[0]:
            best = (slack, f, block)

if best is None:
    print("No timing blocks found. Check the run folder with: find", run, "-name '*.rpt'")
    sys.exit(1)

slack, f, block = best
start = re.search(r"Startpoint:\s*(\S+)", block).group(1)
end = re.search(r"Endpoint:\s*(\S+)", block).group(1)
cells = re.findall(r"(sky130_fd_sc_hd__\S+)", block)
print(f"Report:      {f}")
print(f"Slack:       {slack} ns")
print(f"Startpoint:  {start}")
print(f"Endpoint:    {end}")
print(f"Cells on path ({len(cells)}):")
for c in cells:
    print("  ", c)
open("critical_path.txt", "w").write(block)
print("\nFull block saved to pnr/critical_path.txt")
