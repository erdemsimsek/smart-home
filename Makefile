# Project Configuration
PROJECTS_DIR := projects
CONFIG_DIR := $(PROJECTS_DIR)/configs

# Build Directories
BUILD_DIR := build/$(ACTIVE_PROJECT)
BUILDROOT_BUILD_DIR := $(BUILD_DIR)

# Buildroot and Linux Source Paths
BUILDROOT_SRC_DIR := buildroot

# Centralized Output Directory Option
BUILDROOT_O_OPTION := O=../$(BUILDROOT_BUILD_DIR)

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
	$(MAKE) -C ${BUILDROOT_SRC_DIR} $(BUILDROOT_O_OPTION) $(ACTIVE_PROJECT)_defconfig

buildroot-menuconfig: check-project
	$(MAKE) -C $(BUILDROOT_SRC_DIR) $(BUILDROOT_O_OPTION) menuconfig

buildroot-saveconfig: check-project
	$(MAKE) -C $(BUILDROOT_SRC_DIR) $(BUILDROOT_O_OPTION) savedefconfig

buildroot-build: check-project
	$(MAKE) -C $(BUILDROOT_SRC_DIR) $(BUILDROOT_O_OPTION)

buildroot-clean: check-project
	$(MAKE) -C $(BUILDROOT_SRC_DIR) $(BUILDROOT_O_OPTION) clean

buildroot-dirclean: check-project
	$(MAKE) -C $(BUILDROOT_SRC_DIR) $(BUILDROOT_O_OPTION) distclean

# --- Dynamic Package Targets ---

# Find all package makefiles in the external tree
PACKAGE_MK_FILES := $(wildcard $(BR2_EXTERNAL)/package/*/*.mk)

# Extract package names from the makefile paths
PACKAGE_NAMES := $(basename $(notdir $(PACKAGE_MK_FILES)))

# Generate targets for each package
$(foreach pkg,$(PACKAGE_NAMES),\
	$(eval buildroot-$(pkg)-build: check-project ; $(MAKE) -C $(BUILDROOT_SRC_DIR) $(BUILDROOT_O_OPTION) BR2_EXTERNAL=$(BR2_EXTERNAL) $(pkg)))
$(foreach pkg,$(PACKAGE_NAMES),\
	$(eval buildroot-$(pkg)-rebuild: check-project ; $(MAKE) -C $(BUILDROOT_SRC_DIR) $(BUILDROOT_O_OPTION) BR2_EXTERNAL=$(BR2_EXTERNAL) $(pkg)-rebuild))
$(foreach pkg,$(PACKAGE_NAMES),\
	$(eval buildroot-$(pkg)-clean: check-project ; $(MAKE) -C $(BUILDROOT_SRC_DIR) $(BUILDROOT_O_OPTION) BR2_EXTERNAL=$(BR2_EXTERNAL) $(pkg)-clean))
$(foreach pkg,$(PACKAGE_NAMES),\
	$(eval buildroot-$(pkg)-dirclean: check-project ; $(MAKE) -C $(BUILDROOT_SRC_DIR) $(BUILDROOT_O_OPTION) BR2_EXTERNAL=$(BR2_EXTERNAL) $(pkg)-dirclean))
# Combined Targets
clean: check-project buildroot-clean
	@echo "Cleaning project..." # Informative message

dirclean: check-project buildroot-dirclean
	@echo "Distcleaning project..." # Informative message

rebuild: dirclean buildroot-build
	@echo "Rebuilding project..."

# Help Target
help:
	@echo "Makefile for Buildroot project"
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  all                    : Build Buildroot, including all enabled packages"
	@echo "  buildroot-defconfig   : Generate .config using the specified defconfig"
	@echo "  buildroot-menuconfig  : Configure Buildroot"
	@echo "  buildroot-saveconfig  : Save Buildroot defconfig"
	@echo "  buildroot-build        : Build Buildroot"
	@echo "  buildroot-clean        : Clean Buildroot build artifacts"
	@echo "  buildroot-dirclean     : Distclean Buildroot (removes downloads and build dirs)"
	@echo ""
	@echo "  Package-Specific Targets (Dynamically Generated):"
	@$(foreach pkg,$(PACKAGE_NAMES), echo "    buildroot-$(pkg)-build    : Build package '$(pkg)'";)
	@$(foreach pkg,$(PACKAGE_NAMES), echo "    buildroot-$(pkg)-rebuild  : Rebuild package '$(pkg)' and its dependencies";)
	@$(foreach pkg,$(PACKAGE_NAMES), echo "    buildroot-$(pkg)-clean    : Clean package '$(pkg)' build artifacts";)
	@$(foreach pkg,$(PACKAGE_NAMES), echo "    buildroot-$(pkg)-dirclean : Distclean package '$(pkg)'";)
	@echo ""
	@echo "  clean                 : Clean the entire project (same as buildroot-clean)"
	@echo "  dirclean              : Distclean the entire project (same as buildroot-dirclean)"
	@echo "  rebuild               : Perform a dirclean followed by a full build"
	@echo "  help                  : Display this help message"

.PHONY: check-project buildroot-defconfig buildroot-menuconfig buildroot-saveconfig \
	buildroot-build buildroot-clean buildroot-dirclean \
	$(foreach pkg,$(PACKAGE_NAMES),buildroot-$(pkg)-build buildroot-$(pkg)-rebuild buildroot-$(pkg)-clean buildroot-$(pkg)-dirclean) \
    clean dirclean rebuild help