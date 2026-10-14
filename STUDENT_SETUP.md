# Student setup

You do **not** need Nix, Docker, Git, or a terminal for the SQL exercises.
All exercises run locally on your computer. Use two graphical applications:
one for SQLite, another for PostgreSQL.
Python is needed only if you want to run the optional SQL checks.

## 1. Get the exercise files

On the repository's GitHub page choose **Code → Download ZIP**, then extract
the ZIP into a folder you can find, such as Documents. Do not work inside
the ZIP. If your instructor supplied a download, extract that instead.
Keep the folder structure intact; `chapters7-8/` contains the guided lessons.
You may use Git instead if you already know it.

## 2. Choose your setup

| Computer | SQLite lessons | PostgreSQL companions |
| --- | --- | --- |
| Windows | [DB Browser for SQLite](https://sqlitebrowser.org/dl/), Windows installer | [PostgreSQL Windows installer](https://www.postgresql.org/download/windows/), including pgAdmin |
| macOS (Apple Silicon or Intel) | [DB Browser for SQLite](https://sqlitebrowser.org/dl/), macOS download | [PostgreSQL macOS options](https://www.postgresql.org/download/macosx/); choose an installer appropriate for your Mac, plus [pgAdmin](https://www.pgadmin.org/download/) if not bundled |
| Linux | [DB Browser for SQLite](https://sqlitebrowser.org/dl/), distribution package or suitable AppImage | [PostgreSQL packages for your distribution](https://www.postgresql.org/download/linux/) and [pgAdmin](https://www.pgadmin.org/download/) |

Use a current stable PostgreSQL release, not a beta. The SQL companions
require PostgreSQL 11 or newer; a currently supported release is recommended.
Choose installers matching your machine's architecture. On school-managed
devices, ask for an approved local installation rather than trying
to bypass installation restrictions.

**These are different programs:** DB Browser opens a SQLite file on your
computer. pgAdmin connects to a running PostgreSQL server. Installing pgAdmin
alone does not install that server, and DB Browser cannot open PostgreSQL.

## 3. Start the SQLite lessons

1. Open **DB Browser for SQLite** from your application menu.
2. Follow [Chapters 7–8: Start here](chapters7-8/README.md#start-here)
   to create `lab.sqlite3` and run `setup.sql` in **Execute SQL**.
3. Run `SELECT sqlite_version();` and verify **3.39.0 or newer**. This is
   the SQLite engine version, not the DB Browser application version.
4. Work through the numbered lessons and save your own answers in separate
   `.sql` files. Keep the supplied exercise files unchanged.

Use `setup.sql` in the graphical editor, **not `load.sql`**. `load.sql`
contains terminal-only SQLite commands. Each time you reopen the database,
enable foreign keys as described in the lesson README.

## 4. Connect pgAdmin to PostgreSQL

### Your own Windows, macOS, or Linux computer

Install both the **PostgreSQL server** and **pgAdmin** using the links above.
In installers that offer components, retain PostgreSQL Server and pgAdmin;
extra tools such as Stack Builder are not needed for this lab. Save the
database password you choose. Installation may require administrator help.
Follow the platform's instructions to start the PostgreSQL service/server.

1. Open **pgAdmin 4**. Expand **Servers** and connect to your local server
   if it is already listed. Otherwise choose **Register → Server**:
   - Name: any descriptive label, such as `My local PostgreSQL`.
   - Host: `localhost`.
   - Port: normally `5432`, unless you chose another port.
   - Maintenance database: normally `postgres`.
   - Username/password: the database credentials from installation
     (the installer-created administrative username is often `postgres`).
2. If prompted for a pgAdmin master password, remember it is separate from
   the PostgreSQL database password.
3. Right-click **Databases → Create → Database**, name it `cis300_lab`,
   and save. Use only this disposable database for the companions.
4. Select **cis300_lab**, then open **Tools → Query Tool**.
5. Follow the [PostgreSQL guided exercises](chapters7-8/postgres/README.md#run-the-guided-exercises).

Use the local administrative account only for your own disposable lab.
Do not expose the server to the internet or change real accounts/permissions
for the paper-only GRANT/REVOKE tasks.


## Common problems

| Problem | What to check |
| --- | --- |
| pgAdmin says connection refused | PostgreSQL must be installed **and running**. Check host and port; pgAdmin is only a client. |
| Password authentication failed | Use the database password for that server, not your computer login or pgAdmin master password. |
| `relation already exists` | Setup has already run in this database. Use a new empty database, for example `cis300_lab2`, for a clean restart. Do not drop unrelated objects. |
| `current transaction is aborted` | Run `ROLLBACK;` on its own, fix the original error, and retry the exercise from its `BEGIN;`. |
| `currval ... is not yet defined in this session` | Run the worked `nextval` then `currval` in the same Query Tool tab/connection. Reconnecting resets session state. |
| Sequence values differ from the comments | Values advance even when you roll back. Exact predictions assume a fresh database and one run of the examples. |
| SQLite rejects RIGHT/FULL JOIN | Check `SELECT sqlite_version();`; update the SQLite engine bundled with your editor if it is older than 3.39.0. |
