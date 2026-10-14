# CIS-300-UMARY-EXERCISES
Exercises to be be used in class

## Development environment

From the repository root, run `nix develop` to get Python 3, SQLite, PostgreSQL, and
DB Browser for SQLite (`sqlitebrowser`). No third-party Python packages are
needed. The flake supports x86_64 and aarch64 Linux and pins dependencies in
`flake.lock`.

```sh
nix develop
cd chapters7-8
python3 check.py
python3 -m unittest test_embedded.py
```

The [PostgreSQL companion labs](chapters7-8/postgres/README.md) cover the
slides' server-side features without Oracle. The shell includes server/client
tools; the companion README explains how to start a private disposable server.

## Exercises

- `week3/`: joins and relationship cardinalities.
- [`chapters7-8/`](chapters7-8/README.md): guided SQL labs based on the
  Chapter 7 (Introduction to SQL) and Chapter 8 (Advanced SQL) PowerPoints.
