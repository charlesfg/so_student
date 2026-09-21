cat << 'EOF' >> ~/.customize_environment
#!/bin/bash
set -e

# Remove dpkg man-page exclusion filters
rm -f /etc/dpkg/dpkg.cfg.d/excludes
rm -f /etc/dpkg/dpkg.cfg.d/01_nodoc

# Ensure the man database package and core tools are present
apt-get update -y
apt-get install -y --reinstall man-db manpages manpages-posix
apt-get install -y \
    build-essential \
    gcc \
    gdb \
    make \
    git \
    nano


# SELECTIVE UNMINIMIZATION:
# Add only the specific packages whose manual pages you need:
TARGET_PACKAGES=(
    coreutils
    bash
    git
    curl
    tar
    grep
    sed
    gcc
    awk
)

apt-get install -y --reinstall "${TARGET_PACKAGES[@]}"

# Rebuild the man index cache
mandb -q
EOF