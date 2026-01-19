# VojkanBroforceMods Makefile
# Minimal MSBuild wrapper - leverages Scripts/BroforceModBuild.targets for installation

# Detect OS and set MSBuild path
ifeq ($(OS),Windows_NT)
    MSBUILD := /mnt/c/Program Files/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin/MSBuild.exe
else
    MSBUILD := msbuild
endif

MSBUILD_FLAGS := /p:Configuration=Release /verbosity:minimal /nologo

# LAUNCH variable controls both kill and launch behavior
# Usage: make cobro LAUNCH=no
ifeq ($(LAUNCH),no)
	LAUNCH_FLAGS := /p:CloseBroforceOnBuild=false /p:LaunchBroforceOnBuild=false
else
	LAUNCH_FLAGS := /p:CloseBroforceOnBuild=true /p:LaunchBroforceOnBuild=true
endif

# Default target shows help
.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "VojkanBroforceMods Build System"
	@echo ""
	@echo "Main targets:"
	@echo "  make build              Build all projects (kill game, build, launch)"
	@echo "  make build-no-launch    Build all without disrupting running game"
	@echo "  make clean              Clean all projects"
	@echo "  make rebuild            Clean and rebuild all"
	@echo ""
	@echo "Individual projects:"
	@echo "  make cobro              Build Cobro"
	@echo "  make jack-broton        Build Jack Broton"
	@echo ""
	@echo "Options:"
	@echo "  LAUNCH=no               Don't kill or launch game"
	@echo ""
	@echo "Examples:"
	@echo "  make cobro                  Kill game, build, launch"
	@echo "  make cobro LAUNCH=no        Build without disrupting running game"
	@echo "  make build-no-launch        Build all without disrupting game"

.PHONY: build
build: cobro jack-broton

.PHONY: build-no-launch
build-no-launch:
	$(MAKE) build LAUNCH=no

.PHONY: clean
clean:
	"$(MSBUILD)" "Cobro/Cobro/Cobro.csproj" /t:Clean $(MSBUILD_FLAGS)
	"$(MSBUILD)" "Jack Broton/Jack Broton/Jack Broton.csproj" /t:Clean $(MSBUILD_FLAGS)

.PHONY: rebuild
rebuild: clean
	$(MAKE) build LAUNCH=no

# Individual project targets
.PHONY: cobro
cobro:
	"$(MSBUILD)" "Cobro/Cobro/Cobro.csproj" $(MSBUILD_FLAGS) $(LAUNCH_FLAGS)

.PHONY: jack-broton
jack-broton:
	"$(MSBUILD)" "Jack Broton/Jack Broton/Jack Broton.csproj" $(MSBUILD_FLAGS) $(LAUNCH_FLAGS)
