# 本地编译并安装 Biu.app 到 /Applications。
# 通过 BIU_LOCAL_INSTALL=1 让 electron-builder 走 dir target，
# 跳过 dmg/zip 压缩与代码签名，仅产出当前架构的 .app 目录。

ARCH := $(shell uname -m | sed 's/x86_64/x64/;s/aarch64/arm64/')
APP  := Biu.app
DEST := /Applications

.PHONY: help install build deps clean

help:
	@echo "Targets:"
	@echo "  make install   Build $(APP) and install to $(DEST)"
	@echo "  make build     Build $(APP) only (output under dist/artifacts)"
	@echo "  make deps      Install npm dependencies via pnpm"
	@echo "  make clean     Remove dist/ and .electron/"

install: build
	@APP_PATH=$$(find dist/artifacts -maxdepth 2 -name '$(APP)' -type d -print -quit); \
	if [ -z "$$APP_PATH" ]; then \
		echo "✗ $(APP) not found under dist/artifacts"; exit 1; \
	fi; \
	if pgrep -x Biu > /dev/null 2>&1; then \
		echo "✗ Biu is running — quit it first"; exit 1; \
	fi; \
	echo "→ Installing $$APP_PATH → $(DEST)/$(APP)"; \
	rm -rf "$(DEST)/$(APP)"; \
	cp -R "$$APP_PATH" "$(DEST)/"; \
	xattr -dr com.apple.quarantine "$(DEST)/$(APP)" 2>/dev/null || true; \
	echo "✓ Installed. Launch: open $(DEST)/$(APP)"

build: deps
	BIU_LOCAL_INSTALL=1 CSC_IDENTITY_AUTO_DISCOVERY=false pnpm exec rsbuild build

deps: node_modules

node_modules: pnpm-lock.yaml package.json
	pnpm install --frozen-lockfile --config.engine-strict=false
	@touch node_modules

clean:
	rm -rf dist .electron
