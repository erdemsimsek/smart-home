# Project Configuration
PROJECTS_DIR := projects
CONFIG_DIR := $(PROJECTS_DIR)/configs

# Build Directories
BUILD_DIR := build/$(ACTIVE_PROJECT)
BUILDROOT_BUILD_DIR := $(BUILD_DIR)

# Buildroot and Linux Source Paths
BUILDROOT_SRC_DIR := buildroot

# Centralized Output Directory Option
BUILDROOT_O_OPTION := O=$(BUILDROOT_BUILD_DIR)

# Check if the ACTIVE_PROJECT is set and the config directory exists
check-project:
	@echo "Active Project: '$(ACTIVE_PROJECT)'"
	@if [ -z "$(ACTIVE_PROJECT)" ]; then \
		echo "Error: ACTIVE_PROJECT environment variable is not set."; \
		exit 1; \
	fi

# Build Targets
all: check-project buildroot-build

# Buildroot Targets
buildroot-defconfig: check-project
	$(MAKE) -C ${BUILDROOT_SRC_DIR} ../${BUILDROOT_O_OPTION} ${ACTIVE_PROJECT}_defconfig

buildroot-menuconfig: check-project
	$(MAKE) -C $(BUILDROOT_SRC_DIR) ../${BUILDROOT_O_OPTION} menuconfig

buildroot-saveconfig: check-project
	$(MAKE) -C $(BUILDROOT_SRC_DIR) ../${BUILDROOT_O_OPTION} savedefconfig

buildroot-build: check-project
	$(MAKE) -C $(BUILDROOT_SRC_DIR) ../${BUILDROOT_O_OPTION}

buildroot-clean: check-project
	$(MAKE) -C $(BUILDROOT_SRC_DIR) ../${BUILDROOT_O_OPTION} clean

buildroot-dirclean: check-project
	$(MAKE) -C $(BUILDROOT_SRC_DIR) ../${BUILDROOT_O_OPTION} distclean

# Combined Targets
clean: check-project buildroot-clean

dirclean: check-project buildroot-dirclean

rebuild: dirclean all

# Help Target
help:
	@echo "Makefile for $(PROJECTS_DIR)"
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  all             : Build Buildroot, Linux, and Application"
	@echo "  buildroot-defconfig: Generate .config using the specified defconfig"
	@echo "  buildroot-menuconfig: Configure Buildroot"
	@echo "  buildroot-saveconfig: Save Buildroot defconfig"
	@echo "  buildroot-build   : Build Buildroot"
	@echo "  buildroot-clean   : Clean Buildroot"
	@echo "  buildroot-dirclean: Distclean Buildroot"