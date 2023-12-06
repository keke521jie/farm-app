SHELL := /bin/bash
HIDE ?= @

install:
	$(HIDE)curl https://storage.flutter-io.cn/flutter_infra_release/releases/stable/macos/flutter_macos_3.13.7-stable.zip -o /Applications/flutter_macos_3.13.7-stable.zip
	$(HIDE)unzip -q /Applications/flutter_macos_3.13.7-stable.zip -d /Applications
	$(HIDE)rm -rf /usr/local/bin/dart && ln -s /Applications/flutter/bin/dart /usr/local/bin/
	$(HIDE)sudo gem install -n /usr/local/bin fastlane -NV && sudo  fastlane install_plugins
	$(HIDE)brew install gettext

sync:
	$(HIDE)flutter pub get .
	$(HIDE)cd ios && pod install

check-lint:
	$(HIDE)./script/check-lint.sh

gen:
	$(HIDE)./script/generate.sh com.hswl007.farm-adhoc enterprise

gencert-com.hswl007.farm: app_identifier := "com.hswl007.farm"
gencert-com.hswl007.farm: team_id := "3H6QPJUZ9X"
gencert-com.hswl007.farm:
	$(HIDE)fastlane match development --git_url git+ssh://git@github.com/brain/ios-certificates --git_branch ${team_id} --app_identifier ${app_identifier} --readonly --team_id ${team_id}
	$(HIDE)fastlane match appstore --git_url git+ssh://git@github.com/brain/ios-certificates --git_branch ${team_id} --app_identifier ${app_identifier} --readonly --team_id ${team_id}
	$(HIDE)fastlane match adhoc --git_url git+ssh://git@github.com/brain/ios-certificates --git_branch ${team_id} --app_identifier ${app_identifier} --readonly --team_id ${team_id}

gencert-com.hswl007.farm-adhoc: app_identifier := "com.hswl007.farm-adhoc"
gencert-com.hswl007.farm-adhoc: team_id := "3H6QPJUZ9X"
gencert-com.hswl007.farm-adhoc:
	$(HIDE)fastlane match development --git_url git+ssh://git@github.com/brain/ios-certificates --git_branch ${team_id} --app_identifier ${app_identifier} --readonly --team_id ${team_id}
	$(HIDE)fastlane match appstore --git_url git+ssh://git@github.com/brain/ios-certificates --git_branch ${team_id} --app_identifier ${app_identifier} --readonly --team_id ${team_id}
	$(HIDE)fastlane match adhoc --git_url git+ssh://git@github.com/brain/ios-certificates --git_branch ${team_id} --app_identifier ${app_identifier} --readonly --team_id ${team_id}

build-com.hswl007.farm:
	$(HIDE)rm -rf build
	$(HIDE)make sync
	$(HIDE)make runner-build
	$(HIDE)./script/generate.sh com.hswl007.farm
	$(HIDE)bundle exec fastlane build export_method:app-store profile_name:AppStore appid:com.hswl007.farm
	#$(HIDE)flutter build apk

build-com.hswl007.farm-adhoc:
	$(HIDE)rm -rf build
	$(HIDE)make sync
	$(HIDE)make runner-build
	$(HIDE)./script/generate.sh com.hswl007.farm-adhoc
	$(HIDE)bundle exec fastlane build export_method:ad-hoc profile_name:AdHoc appid:com.hswl007.farm-adhoc

upload-com.hswl007.farm:
	$(HIDE)fastlane upload_testflight app_identifier:com.hswl007.farm
	#$(HIDE)fastlane upload_appcenter_android app_name:Gravity-android

upload-com.hswl007.farm-adhoc:
	$(HIDE)fastlane upload_appcenter app_name:Gravity-ios

publish-prod:
	$(HIDE)make build-com.hswl007.farm
	$(HIDE)make upload-com.hswl007.farm
	$(HIDE)make build-com.hswl007.farm-adhoc
	$(HIDE)make upload-com.hswl007.farm-adhoc

i-ipa:
	$(HIDE)ideviceinstaller -i build/fastlane/App.ipa

i-apk:
	$(HIDE)adb install build/app/outputs/flutter-apk/app-release.apk
