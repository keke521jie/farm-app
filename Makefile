SHELL := /bin/bash
HIDE ?= @

-include MakeUtil.mk

export HOMEBREW_NO_AUTO_UPDATE=true

.PHONY: build test

fix:
	$(HIDE)dart format . --line-length 120
	$(HIDE)dart fix --apply

test:
	$(HIDE)flutter test --no-sound-null-safety

runner-build:
	$(HIDE)ls lib/Local.dart || cp lib/Local.dart.tmpl lib/Local.dart
	$(HIDE)dart run build_runner clean
	$(HIDE)dart run build_runner build --delete-conflicting-outputs

runner-watch:
	$(HIDE)ls lib/Local.dart || cp lib/Local.dart.tmpl lib/Local.dart
	$(HIDE)dart run build_runner clean
	$(HIDE)dart run build_runner watch --delete-conflicting-outputs
