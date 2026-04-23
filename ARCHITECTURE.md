# PHP-EXT - Cau Truc Build System

**Repository:** `src/php-ext` (git@github.com:diepxuan/php-ext.git)
**Chuc nang:** Build system thong nhat cho PHP PECL extensions

---

## 1. Tong Quan

`php-ext` la build system thong nhat, build 3 PHP extensions tu 1 repo duy nhat:

| Module | PECL Package | Description |
|--------|-------------|-------------|
| `sqlsrv` | [sqlsrv](https://pecl.php.net/package/sqlsrv) | Microsoft Drivers for PHP for SQL Server (SQLSRV) |
| `pdo_sqlsrv` | [pdo_sqlsrv](https://pecl.php.net/package/pdo_sqlsrv) | Microsoft Drivers for PHP for SQL Server (PDO_SQLSRV) |
| `runkit7` | [runkit7](https://pecl.php.net/package/runkit7) | PHP runkit7 extension |

---

## 2. Co Cau File

```
src/php-ext/
├── src/
│   ├── build.sh                    # Build script chuyen dung
│   └── debian/
│       ├── changelog               # Changelog mac dinh (php-runkit7)
│       ├── control.in              # Control template mac dinh (cho runkit7)
│       ├── runkit7.control.in      # Control template cho runkit7
│       ├── sqlsrv.control.in       # Control template cho sqlsrv
│       ├── pdo_sqlsrv.control.in   # Control template cho pdo_sqlsrv
│       ├── php-sqlsrv.substvars    # Metadata cho sqlsrv
│       ├── php-pdo-sqlsrv.substvars # Metadata cho pdo_sqlsrv
│       ├── php-runkit7.substvars   # Metadata cho runkit7
│       ├── php-sqlsrv.rules        # Build rules cho sqlsrv
│       ├── php-pdo_sqlsrv.rules    # Build rules cho pdo_sqlsrv
│       └── rules                   # Rules mac dinh
```

---

## 3. Build Script - Co Che Hoat Dong

### 3.1 Module Selection

`build.sh` lay module name tu repository name:

```bash
env module $(echo $project | sed 's/^php-//g')
```

Vi du:
- `diepxuan/php-sqlsrv` → `module=sqlsrv`
- `diepxuan/php-pdo_sqlsrv` → `module=pdo_sqlsrv`
- `diepxuan/php-runkit7` → `module=runkit7`

### 3.2 Control File Selection

Script chon control file theo thu tu:

```bash
# Neu co module-specific control.in → dung cai do
[[ -f $(realpath $debian_dir/$module.control.in) ]] &&
    cat $(realpath $debian_dir/$module.control.in) | tee $controlin

# Sau do replace placeholders
sed -i -e "s|_PROJECT_|$_project|g" $controlin
sed -i -e "s|_MODULE_|$module|g" $controlin
```

**Ket qua:**
- `sqlsrv` → `sqlsrv.control.in` (neu khong co → `control.in`)
- `pdo_sqlsrv` → `pdo_sqlsrv.control.in` (neu khong co → `control.in`)
- `runkit7` → `runkit7.control.in` (neu khong co → `control.in`)

### 3.3 Build Rules Selection

```bash
[[ -f "$debian_dir/php-$module.rules" ]] && cat "$debian_dir/php-$module.rules" >>"$rules"
```

---

## 4. Module Metadata (substvars)

### sqlsrv (`php-sqlsrv.substvars`)

```
Build-Depends: unixodbc-dev, unixodbc, msodbcsql18, php-dev
Depends: msodbcsql18
Description: Microsoft Drivers for PHP for SQL Server (SQLSRV)
```

### pdo_sqlsrv (`php-pdo-sqlsrv.substvars`)

```
Build-Depends: unixodbc-dev, unixodbc, msodbcsql18, php-dev
Depends: msodbcsql18
Description: Microsoft Drivers for PHP for SQL Server (PDO_SQLSRV)
```

### runkit7 (`php-runkit7.substvars`)

```
Build-Depends: php-dev
Description: runkit7 module for PHP
```

---

## 5. Quy Tac Lam Viec

### 5.1 Khi Them Extension Moi

1. Them file `debian/<module>.control.in` (neu can template rieng)
2. Them file `debian/php-<module>.substvars`
3. Them file `debian/php-<module>.rules` (neu can build rules rieng)
4. Khong sua `control.in` mac dinh (dung cho runkit7)

### 5.2 Khi Sua Dependency

- **Chung cho moi module:** Sua `control.in`
- **Rieng cho tung module:** Sua `<module>.control.in`

### 5.3 Khi Build

- Set environment variable `repository` de build script xac dinh module:
  ```
  repository: diepxuan/php-sqlsrv    → build sqlsrv
  repository: diepxuan/php-pdo_sqlsrv → build pdo_sqlsrv
  repository: diepxuan/php-runkit7   → build runkit7
  ```

---

## 6. Dependency Theo Module

| Module | Build Deps | Runtime Deps |
|--------|-----------|--------------|
| sqlsrv | unixodbc-dev, unixodbc, msodbcsql18, php-dev | msodbcsql18 |
| pdo_sqlsrv | unixodbc-dev, unixodbc, msodbcsql18, php-dev | msodbcsql18 |
| runkit7 | php-dev | (none) |

---

## 7. Distributions Ho Tro

| Module | Debian | Ubuntu | PHP Versions |
|--------|--------|--------|-------------|
| sqlsrv | 10, 11, 12 | 18.04, 20.04, 22.04, 24.04, 24.10, 25.04 | 8.1, 8.2, 8.3, 8.4 |
| pdo_sqlsrv | 10, 11, 12 | 18.04, 20.04, 22.04, 24.04, 24.10, 25.04 | 8.1, 8.2, 8.3, 8.4 |
| runkit7 | 10, 11, 12 | 18.04, 20.04, 22.04, 24.04, 24.10 | 7.2, 7.3, 7.4, 8.0, 8.1, 8.2, 8.3 |

---

## 8. Repo Cu vs Repo Moi

### Repo cu (submodule)

| Repo | URL | Trang thai |
|------|-----|-----------|
| `src/diepxuan/php-sqlsrv` | github.com/diepxuan/php-sqlsrv | **Da mo rong** → `php-ext` |
| `src/diepxuan/php-pdo_sqlsrv` | github.com/diepxuan/php-pdo_sqlsrv | **Da mo rong** → `php-ext` |
| `src/diepxuan/php-runkit7` | github.com/diepxuan/php-runkit7 | **Da mo rong** → `php-ext` |

### Repo moi (thong nhat)

| Repo | URL | Trang thai |
|------|-----|-----------|
| `src/php-ext` | github.com/diepxuan/php-ext | **Active** - Build system thong nhat |

---

## 9. Quan Trong

- **Moi work trong `src/php-ext`.**
- **Khong lam viec trong `src/diepxuan/php-sqlsrv` hay `src/diepxuan/php-pdo_sqlsrv`.**
- **Moi module co file rieng trong `src/debian/`.**
- **Khong sua `control.in` chung neu khong can.**
