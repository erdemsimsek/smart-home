#!/bin/sh

# Disable conflicting network services
chmod +x ${TARGET_DIR}/etc/init.d/S40iwd
chmod +x ${TARGET_DIR}/etc/init.d/S45connman
chmod +x ${TARGET_DIR}/etc/init.d/S40network

# Other post-build commands...