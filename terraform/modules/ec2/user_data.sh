#!/bin/bash
apt-get update -y

# ── INSTALL SOFTWARE ──────────────────────────────────────
apt-get install -y nginx php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip amazon-efs-utils

# ── MOUNT EFS ─────────────────────────────────────────────
mkdir -p /var/www/wordpress
mount -t efs ${efs_id}:/ /var/www/wordpress

# persist mount after reboot
echo "${efs_id}:/ /var/www/wordpress efs defaults,_netdev 0 0" >> /etc/fstab

# ── NGINX CONFIG ──────────────────────────────────────────
# set correct permissions
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

# ── START SERVICES ────────────────────────────────────────
systemctl enable nginx php-fpm
systemctl start nginx php-fpm
systemctl restart nginx php-fpm