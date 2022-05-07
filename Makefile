include ./assets/setup

Platform := $(shell uname)
Latest := $(shell wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')
Evaluation := $(shell [[ "$(Platform)" =~ "Darwin" ]])

node: $(Evaluation)
	@chmod a+x "$(CWD)/assets/node-js"
	@eval "$(CWD)/assets/node-js"
	@node --version

build: upgrade
	@cargo build && true

upgrade: setup
	@rustup toolchain install --force "stable"

cargo: setup
	@cargo install "evcxr_repl" 		# --force
	@cargo install "cargo-edit" 		# --force
	@cargo install "cargo-show" 		# --force
	@cargo install "cargo-get" 			# --force

	@cargo install "cargo-workspaces"	# --force

setup: informational
	@curl --proto "=https" -sSf https://sh.rustup.rs | bash -s -- -y
	@source "$(HOME)/.cargo/env"

informational:
	@echo -n "{" > .build-information.json
	@echo -n "\"UNAME\": \"$(UNAME)\"," >> .build-information.json
	@echo -n "\"SHELL\": \"$(SHELL)\"," >> .build-information.json
	@echo -n "\"CWD\": \"$(CWD)\"," >> .build-information.json
	@echo -n "\"Directory\": \"$(Directory)\"," >> .build-information.json
	@echo -n "\"Remote\": \"$(Remote)\"," >> .build-information.json
	@echo -n "\"Branch\": \"$(Branch)\"," >> .build-information.json
	@echo -n "\"Branches\": \"$(Branches)\"," >> .build-information.json
	@echo -n "\"Remotes\": \"$(Remotes)\"," >> .build-information.json
	@echo -n "\"Dirty\": \"$(Dirty)\"," >> .build-information.json
	@echo -n "\"Version\": \"$(Version)\"," >> .build-information.json
	@echo -n "\"Build\": \"$(Build)\"," >> .build-information.json
	@echo -n "\"Major\": \"$(Major)\"," >> .build-information.json
	@echo -n "\"Minor\": \"$(Minor)\"," >> .build-information.json
	@echo -n "\"Patch\": \"$(Patch)\"," >> .build-information.json
	@echo -n "\"Major-Upgrade\": \"$(Major-Upgrade)\"," >> .build-information.json
	@echo -n "\"Minor-Upgrade\": \"$(Minor-Upgrade)\"," >> .build-information.json
	@echo -n "\"Patch-Upgrade\": \"$(Patch-Upgrade)\"," >> .build-information.json
	@echo -n "\"Major-Build-Upgrade\": \"$(Major-Build-Upgrade)\"," >> .build-information.json
	@echo -n "\"Minor-Build-Upgrade\": \"$(Minor-Build-Upgrade)\"," >> .build-information.json
	@echo -n "\"Patch-Build-Upgrade\": \"$(Patch-Build-Upgrade)\"," >> .build-information.json
	@echo -n "\"Node\": \"$(Node)\"," >> .build-information.json
	@echo -n "\"Deployment-Packages\": \"$(sort $(dir $(wildcard ./packages/*/)))\",">> .build-information.json
	@echo -n "}" >> .build-information.json

.PHONY: build