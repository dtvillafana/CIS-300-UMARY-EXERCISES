# CIS-300-UMARY-EXERCISES
Exercises to be be used in class

## Student setup — no Nix required

Start with the [student setup guide](STUDENT_SETUP.md). It covers Windows,
macOS, and Linux using graphical applications, plus an instructor-hosted
option for Chromebooks and restricted computers. No terminal, Git, Docker,
or Nix is required for the SQL lessons.

- **SQLite lessons:** DB Browser for SQLite.
- **PostgreSQL companions:** PostgreSQL with pgAdmin's Query Tool.

## Optional developer environment (Nix)

From the repository root, run `nix develop` to get Python 3, SQLite, PostgreSQL, and
DB Browser for SQLite (`sqlitebrowser`). No third-party Python packages are
needed. The flake supports x86_64 and aarch64 Linux and pins dependencies in
`flake.lock`.

```sh
nix develop
sqlitebrowser
```

Use **DB Browser for SQLite** for the SQLite exercises. Create a disposable
database with **New Database**, then use the **Execute SQL** tab to load and
run SQL. Follow the [guided setup](chapters7-8/README.md#start-here) before
starting the Chapter 7–8 lessons. Do not paste SQLite CLI files such as
`load.sql` into the SQL editor.

The [PostgreSQL companion labs](chapters7-8/postgres/README.md) cover the
slides' server-side features without Oracle. The shell includes server/client
tools; students can instead use the installers in the setup guide.
DB Browser for SQLite cannot connect to PostgreSQL.

## Exercises

- `week3/`: joins and relationship cardinalities.
- [`chapters7-8/`](chapters7-8/README.md): guided SQL labs based on the
  Chapter 7 (Introduction to SQL) and Chapter 8 (Advanced SQL) PowerPoints.
