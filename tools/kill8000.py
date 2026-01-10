"""Utility to terminate every Windows process bound to a specific TCP port.

Usage
-----
python kill8000.py            # defaults to port 8000
python kill8000.py 5173       # custom port

The script wraps ``netstat`` + ``taskkill`` so it requires Windows and, in most
cases, Administrator privileges. It intentionally avoids third-party
dependencies so it can run out-of-the-box in this repo.
"""

from __future__ import annotations

import re
import subprocess
import sys
from dataclasses import dataclass
from typing import Iterable, Set


CREATE_NO_WINDOW = getattr(subprocess, "CREATE_NO_WINDOW", 0)


@dataclass
class KillResult:
	pid: int
	success: bool
	message: str


def find_pids_by_port(port: int) -> Set[int]:
	"""Return every PID that owns a socket bound to *port*.

	We scan ``netstat -ano`` output and look for both IPv4 and IPv6 entries that
	contain ``:{port}`` as the local endpoint. Word boundaries make sure we do
	not accidentally match ports like 18000.
	"""

	try:
		output = subprocess.check_output(["netstat", "-ano"], text=True, creationflags=CREATE_NO_WINDOW)
	except FileNotFoundError as exc:  # pragma: no cover - highly unlikely on Win
		raise RuntimeError("netstat command not found in PATH") from exc

	pattern = re.compile(rf":{port}(?!\d)")
	pids: Set[int] = set()

	for line in output.splitlines():
		if pattern.search(line):
			parts = line.split()
			if not parts:
				continue
			try:
				pid = int(parts[-1])
			except ValueError:
				continue
			pids.add(pid)

	return pids


def kill_processes(pids: Iterable[int]) -> list[KillResult]:
	"""Force-terminate each PID using ``taskkill`` and return the results."""

	results: list[KillResult] = []
	for pid in pids:
		try:
			completed = subprocess.run(
				["taskkill", "/PID", str(pid), "/F"],
				text=True,
				capture_output=True,
				creationflags=CREATE_NO_WINDOW,
			)
			success = completed.returncode == 0
			message = (completed.stdout or completed.stderr).strip()
		except FileNotFoundError as exc:  # pragma: no cover - also unlikely
			success = False
			message = f"taskkill command not found: {exc}"

		results.append(KillResult(pid=pid, success=success, message=message))

	return results


def main(args: list[str]) -> int:
	if args:
		try:
			port = int(args[0])
		except ValueError:
			print(f"Invalid port '{args[0]}'. Please pass an integer.", file=sys.stderr)
			return 2
	else:
		port = 8000

	print(f"Scanning for processes bound to port {port} ...")
	pids = find_pids_by_port(port)

	if not pids:
		print(f"No process is currently listening on port {port}.")
		return 0

	print(f"Found {len(pids)} process(es): {', '.join(str(pid) for pid in pids)}")
	results = kill_processes(pids)

	failed = [result for result in results if not result.success]
	for result in results:
		status = "OK" if result.success else "FAIL"
		print(f"[{status}] PID {result.pid}: {result.message}")

	if failed:
		print(
			"Some processes could not be terminated. Try running this script as Administrator.",
			file=sys.stderr,
		)
		return 1

	print("All processes terminated successfully.")
	return 0


if __name__ == "__main__":
	raise SystemExit(main(sys.argv[1:]))
