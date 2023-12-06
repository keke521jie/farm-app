#!/bin/sh

if [ "$1" = "com.hswl007.farm" ]; then
  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "PRODUCT_BUNDLE_IDENTIFIER = \"com.hswl007.farm\"" "PRODUCT_BUNDLE_IDENTIFIER = \"com.hswl007.farm\""
  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "PRODUCT_BUNDLE_IDENTIFIER = \"com.hswl007.farm-adhoc\"" "PRODUCT_BUNDLE_IDENTIFIER = \"com.hswl007.farm\""

  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match AppStore com.hswl007.farm\"" "match AdHoc com.hswl007.farm\""
  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match AppStore com.hswl007.farm-adhoc\"" "match AdHoc com.hswl007.farm\""

  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match AdHoc com.hswl007.farm\"" "match AdHoc com.hswl007.farm\""
  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match AdHoc com.hswl007.farm-adhoc\"" "match AdHoc com.hswl007.farm\""

  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match Development com.hswl007.farm\"" "match Development com.hswl007.farm\""
  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match Development com.hswl007.farm-adhoc\"" "match Development com.hswl007.farm\""

  python3 script/sed.py "android/app/build.gradle" "com.hswl007.farm\"" "com.hswl007.farm\""
  python3 script/sed.py "android/app/build.gradle" "ai.brain.adhoc_gravity\"" "com.hswl007.farm\""

  python3 script/sed.py "android/app/src/debug/AndroidManifest.xml" "package=\"com.hswl007.farm\"" "package=\"com.hswl007.farm\""
  python3 script/sed.py "android/app/src/debug/AndroidManifest.xml" "package=\"ai.brain.adhoc_gravity\"" "package=\"com.hswl007.farm\""

  python3 script/sed.py "android/app/src/main/AndroidManifest.xml" "package=\"com.hswl007.farm\"" "package=\"com.hswl007.farm\""
  python3 script/sed.py "android/app/src/main/AndroidManifest.xml" "package=\"ai.brain.adhoc_gravity\"" "package=\"com.hswl007.farm\""

  python3 script/sed.py "android/app/src/profile/AndroidManifest.xml" "package=\"com.hswl007.farm\"" "package=\"com.hswl007.farm\""
  python3 script/sed.py "android/app/src/profile/AndroidManifest.xml" "package=\"ai.brain.adhoc_gravity\"" "package=\"com.hswl007.farm\""

  python3 script/sed.py "android/app/src/main/kotlin/app/MainActivity.kt" "package com.hswl007.farm" "package com.hswl007.farm"
  python3 script/sed.py "android/app/src/main/kotlin/app/MainActivity.kt" "package ai.brain.adhoc_gravity" "package com.hswl007.farm"
fi


if [ "$1" = "com.hswl007.farm-adhoc" ]; then
  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "PRODUCT_BUNDLE_IDENTIFIER = \"com.hswl007.farm\"" "PRODUCT_BUNDLE_IDENTIFIER = \"com.hswl007.farm-adhoc\""
  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "PRODUCT_BUNDLE_IDENTIFIER = \"com.hswl007.farm-adhoc\"" "PRODUCT_BUNDLE_IDENTIFIER = \"com.hswl007.farm-adhoc\""

  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match AppStore com.hswl007.farm\"" "match AdHoc com.hswl007.farm-adhoc\""
  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match AppStore com.hswl007.farm-adhoc\"" "match AdHoc com.hswl007.farm-adhoc\""

  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match AdHoc com.hswl007.farm\"" "match AdHoc com.hswl007.farm-adhoc\""
  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match AdHoc com.hswl007.farm-adhoc\"" "match AdHoc com.hswl007.farm-adhoc\""

  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match Development com.hswl007.farm\"" "match Development com.hswl007.farm-adhoc\""
  python3 script/sed.py "ios/Runner.xcodeproj/project.pbxproj" "match Development com.hswl007.farm-adhoc\"" "match Development com.hswl007.farm-adhoc\""

  python3 script/sed.py "android/app/build.gradle" "com.hswl007.farm\"" "com.hswl007.farm\""
  python3 script/sed.py "android/app/build.gradle" "ai.brain.adhoc_gravity\"" "com.hswl007.farm\""

  python3 script/sed.py "android/app/src/debug/AndroidManifest.xml" "package=\"com.hswl007.farm\"" "package=\"com.hswl007.farm\""
  python3 script/sed.py "android/app/src/debug/AndroidManifest.xml" "package=\"ai.brain.adhoc_gravity\"" "package=\"com.hswl007.farm\""

  python3 script/sed.py "android/app/src/main/AndroidManifest.xml" "package=\"com.hswl007.farm\"" "package=\"com.hswl007.farm\""
  python3 script/sed.py "android/app/src/main/AndroidManifest.xml" "package=\"ai.brain.adhoc_gravity\"" "package=\"com.hswl007.farm\""

  python3 script/sed.py "android/app/src/profile/AndroidManifest.xml" "package=\"com.hswl007.farm\"" "package=\"com.hswl007.farm\""
  python3 script/sed.py "android/app/src/profile/AndroidManifest.xml" "package=\"ai.brain.adhoc_gravity\"" "package=\"com.hswl007.farm\""

  python3 script/sed.py "android/app/src/main/kotlin/app/MainActivity.kt" "package com.hswl007.farm" "package com.hswl007.farm"
  python3 script/sed.py "android/app/src/main/kotlin/app/MainActivity.kt" "package ai.brain.adhoc_gravity" "package com.hswl007.farm"
fi
