#!/bin/bash
exec > /var/log/user_data.log 2>&1

apt-get update -y

# ── INSTALL SOFTWARE ──────────────────────────────────────
apt-get install -y \
  nginx \
  php-fpm \
  php-mysql \
  php-curl \
  php-gd \
  php-mbstring \
  php-xml \
  php-xmlrpc \
  php-soap \
  php-intl \
  php-zip \
  mysql-client \
  python3-pymysql \
  nfs-common

# ── MOUNT EFS ─────────────────────────────────────────────
mkdir -p /var/www/wordpress
mount -t nfs4 ${efs_id}.efs.eu-central-1.amazonaws.com:/ /var/www/wordpress
echo "${efs_id}.efs.eu-central-1.amazonaws.com:/ /var/www/wordpress nfs4 defaults,_netdev 0 0" >> /etc/fstab

# ── PERMISSIONS ───────────────────────────────────────────
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

# ── START SERVICES ────────────────────────────────────────
systemctl enable nginx php8.3-fpm
systemctl start nginx php8.3-fpm

# ── SIGNAL ANSIBLE ────────────────────────────────────────
touch /tmp/userdata_complete