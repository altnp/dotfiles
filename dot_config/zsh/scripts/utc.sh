#!/bin/zsh

utc() {
	python3 - <<'PY'
from datetime import datetime, timezone

now_local = datetime.now().astimezone()
now_utc = datetime.now(timezone.utc)

tz_label = now_local.tzname() or "Local"

offset = now_local.utcoffset()
hours = (offset.total_seconds() / 3600) if offset else 0
hours_str = f"{hours:g}"

def format_line(label, dt):
    date = dt.strftime("%Y-%m-%d")
    time_12 = dt.strftime("%I:%M:%S %p")
    time_24 = dt.strftime("%H:%M:%S")
    print(f"{label}: {date} {time_12} ({time_24})")

format_line("UTC", now_utc)
format_line(tz_label, now_local)
print(f"Diff: {hours_str}")
PY
}
