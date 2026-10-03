#!/usr/bin/env bash
# One-shot: creates the Android project, icons, and release signing. Run from the project folder.
set -e
npm install
[ -d android ] || npx cap add android
npx capacitor-assets generate --android
npx cap sync android

G=android/app/build.gradle
if ! grep -q keystore.properties "$G"; then
  python3 - "$G" <<'PY'
import sys,re
p=sys.argv[1];s=open(p).read()
s="def keystorePropertiesFile = rootProject.file(\"keystore.properties\")\ndef keystoreProperties = new Properties()\nif (keystorePropertiesFile.exists()) { keystoreProperties.load(new FileInputStream(keystorePropertiesFile)) }\n\n"+s
sign='''    signingConfigs {
        release {
            if (keystorePropertiesFile.exists()) {
                storeFile file(keystoreProperties['storeFile'])
                storePassword keystoreProperties['storePassword']
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
            }
        }
    }
'''
s=s.replace("    buildTypes {",sign+"    buildTypes {",1)
s=re.sub(r"(buildTypes\s*\{\s*release\s*\{)",r"\1\n            signingConfig signingConfigs.release",s,1)
open(p,'w').write(s)
PY
fi
echo
echo "Android project ready."
echo "Next: create your upload key ONCE (keep the file + passwords safe, never commit):"
echo "  keytool -genkey -v -keystore android/pagewise-upload.jks -keyalias upload -keyalg RSA -keysize 2048 -validity 10000"
echo "Then create android/keystore.properties with:"
echo "  storeFile=pagewise-upload.jks"
echo "  storePassword=YOUR_PASSWORD"
echo "  keyAlias=upload"
echo "  keyPassword=YOUR_PASSWORD"
echo "Build the Play Store file:  npm run release:aab"
echo "  -> android/app/build/outputs/bundle/release/app-release.aab"
echo "Test on your phone:         npm run debug:apk  (or press Run in Android Studio)"
