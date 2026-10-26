import re, sys

text = open(sys.argv[1], encoding="utf-8", errors="ignore").read()

def status(name):
    m = re.search(rf"\* {name}\s*\n\s*(\S+)", text)
    return m.group(1) if m else "missing"

drc, lvs, ant = status("DRC"), status("LVS"), status("Antenna")
print(f"  Antenna: {ant}   LVS: {lvs}   DRC: {drc}")
ok = drc.startswith("Passed") and lvs.startswith("Passed")
sys.exit(0 if ok else 1)
