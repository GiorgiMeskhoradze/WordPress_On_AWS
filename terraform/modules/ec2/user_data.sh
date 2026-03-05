---
# user_data.sh handles: Nginx, PHP, EFS mount, Nginx config
# Ansible handles: WordPress files on EFS, wp-config.php

# ── WAIT FOR USER DATA ────────────────────────────────────
- name: Wait for user_data to complete
  wait_for:
    path: /tmp/userdata_complete
    timeout: 300

# ── SYSTEM ────────────────────────────────────────────────
- name: Update apt cache
  apt:
    update_cache: yes

# ── WORDPRESS ─────────────────────────────────────────────
- name: Create WordPress directory
  file:
    path: "{{ wp_install_dir }}"
    state: directory
    owner: www-data
    group: www-data
    mode: '0755'

- name: Download WordPress
  get_url:
    url: https://wordpress.org/latest.tar.gz
    dest: /tmp/wordpress.tar.gz

- name: Extract WordPress
  unarchive:
    src: /tmp/wordpress.tar.gz
    dest: /tmp/
    remote_src: yes

- name: Copy WordPress files to install dir
  copy:
    src: /tmp/wordpress/
    dest: "{{ wp_install_dir }}/"
    remote_src: yes
    owner: www-data
    group: www-data

# ── WP-CONFIG ─────────────────────────────────────────────
- name: Deploy wp-config.php from template
  template:
    src: wp-config.j2
    dest: "{{ wp_install_dir }}/wp-config.php"
    owner: www-data
    group: www-data
    mode: '0640'