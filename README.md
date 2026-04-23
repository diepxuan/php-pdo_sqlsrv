# PHP-EXT - DiepXuan PHP Extension Packages

Build system thong nhat cho PHP PECL extensions.
Xem [ARCHITECTURE.md](ARCHITECTURE.md) de hieu cau truc.

## Extensions

| Extension | PECL | PHP | Description |
|-----------|------|-----|-------------|
| **sqlsrv** | [sqlsrv](https://pecl.php.net/package/sqlsrv) | 8.1+ | Microsoft Drivers for PHP for SQL Server (SQLSRV) |
| **pdo_sqlsrv** | [pdo_sqlsrv](https://pecl.php.net/package/pdo_sqlsrv) | 8.1+ | Microsoft Drivers for PHP for SQL Server (PDO_SQLSRV) |
| **runkit7** | [runkit7](https://pecl.php.net/package/runkit7) | 7.2+ | PHP runkit7 extension |

## Dependencies

### sqlsrv / pdo_sqlsrv

- **Build:** unixodbc-dev, unixodbc, msodbcsql18, php-dev
- **Runtime:** msodbcsql18

### runkit7

- **Build:** php-dev
- **Runtime:** (none)

## Distributions

- **Debian:** 10 (Buster), 11 (Bullseye), 12 (Bookworm)
- **Ubuntu:** 18.04 (Bionic), 20.04 (Focal), 22.04 (Jammy), 24.04 (Noble), 24.10 (Oracular), 25.04 (Plucky)

## Building

```bash
cd src/
bash build.sh
```

Environment variables:
- `repository` - Xac dinh module (e.g., `diepxuan/php-sqlsrv`)
- `GPG_KEY`, `GPG_KEY_ID` - Package signing

## Installation

```bash
# Add PPA
echo "deb https://ppa.diepxuan.com <codename> main" | sudo tee /etc/apt/sources.list.d/diepxuan.list

# Install
sudo apt update
sudo apt install php-sqlsrv php-pdo-sqlsrv php-runkit7
```
