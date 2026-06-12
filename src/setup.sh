#!/usr/bin/env bash

# Install system deps
apt-get update -y
apt-get install -y --no-install-recommends graphviz git ssh curl

# Clean system deps
apt-get autoclean -y
apt-get clean -y
apt-get autoremove -y
rm -rf /var/lib/{apt,dpkg,cache,log}/

# Setup git
git --version && \
    git config --global init.defaultBranch main && \
    git config --global init.defaultBranch

# Install pip packages
pip install diagrams==0.25.1

# Clean pip cache
rm -rf ~/.cache/pip/*