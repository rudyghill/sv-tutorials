#!/usr/bin/env bash
# screenshots.sh
# Render teaching screenshots of an RTL file with silicon
# (https://github.com/Aloxaf/silicon).
#
#   ./screenshots.sh <file.sv> [outdir]     (outdir defaults to img)
#
# Comments are stripped first, so line 1 of every image is the first line of
# code. Three images are written, all of the full stripped file:
#   <name>_full.png    no highlight
#   <name>_ports.png   module header and port list highlighted
#   <name>_logic.png   module body highlighted
set -euo pipefail

# Highlight ranges, as line numbers in the STRIPPED code (what the image shows).
# Leave empty to auto-detect; set e.g. PORT_LINES="1-7" to override. Both can
# also be set from the environment: PORT_LINES=1-7 ./screenshots.sh ...
PORT_LINES="${PORT_LINES:-}"
LOGIC_LINES="${LOGIC_LINES:-}"

# Extra flags passed to every silicon call, e.g. "--theme Nord"
SILICON_ARGS=(-l sv)

src="${1:?usage: $0 <file.sv> [outdir]}"
outdir="${2:-img}"
name="$(basename "${src%.*}")"

command -v silicon >/dev/null || { echo "silicon not found: https://github.com/Aloxaf/silicon"; exit 1; }
mkdir -p "$outdir"

code="$(mktemp)"
trap 'rm -f "$code"' EXIT

# Strip // and /* */ comments. Lines that were only comments are dropped, runs
# of blank lines collapse to one, and leading/trailing blank lines are removed.
awk '
{
    line = $0; out = ""
    while (line != "") {
        if (in_block) {
            i = index(line, "*/")
            if (i == 0) { line = ""; break }
            line = substr(line, i + 2); in_block = 0
        } else {
            s = index(line, "//"); b = index(line, "/*")
            if (s && (!b || s < b)) { out = out substr(line, 1, s - 1); line = "" }
            else if (b) { out = out substr(line, 1, b - 1); line = substr(line, b + 2); in_block = 1 }
            else { out = out line; line = "" }
        }
    }
    sub(/[ \t]+$/, "", out)
    if (out == "") {
        # keep a real blank line (between code), drop a comment-only one
        if ($0 ~ /^[ \t]*$/ && seen_code) pending_blank = 1
        next
    }
    if (pending_blank) print ""
    pending_blank = 0; seen_code = 1
    print out
}' "$src" > "$code"

# Auto-detect: ports run from the "module" line to the first ");" after it;
# logic is the non-blank lines between there and "endmodule".
read -r ports_auto logic_auto < <(awk '
    !ps && /^[ \t]*module[ \t(]/   { ps = NR }
    ps && !pe && /\);/             { pe = NR; next }
    pe && /^[ \t]*endmodule/       { em = NR; exit }
    pe && !/^[ \t]*$/              { if (!ls) ls = NR; le = NR }
    END {
        if (!ps || !pe || !ls) { print "? ?"; exit }
        print ps "-" pe, ls "-" le
    }' "$code")

PORT_LINES="${PORT_LINES:-$ports_auto}"
LOGIC_LINES="${LOGIC_LINES:-$logic_auto}"
if [[ "$PORT_LINES" == "?" || "$LOGIC_LINES" == "?" ]]; then
    echo "Could not auto-detect ports/logic in $src; set PORT_LINES and LOGIC_LINES"
    exit 1
fi

silicon "${SILICON_ARGS[@]}" -o "$outdir/${name}_full.png"  "$code"
silicon "${SILICON_ARGS[@]}" -o "$outdir/${name}_ports.png" --highlight-lines "$PORT_LINES"  "$code"
silicon "${SILICON_ARGS[@]}" -o "$outdir/${name}_logic.png" --highlight-lines "$LOGIC_LINES" "$code"

echo "ports: lines $PORT_LINES, logic: lines $LOGIC_LINES"
echo "Wrote $outdir/${name}_{full,ports,logic}.png"
