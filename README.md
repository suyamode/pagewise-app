# Pagewise Reader: build and publish guide

This folder is a ready-to-wrap Android project. The reader lives in `www/index.html`
with all libraries and fonts bundled, so it works offline and makes no network requests.

## Quick start (recommended)
After installing Node.js and Android Studio (step 1), run `npm run setup:android`. It does steps 3 and 5's signing wiring for you.
Then `npm run debug:apk` (install on your phone) or `npm run release:aab` (file for the Play Store). The app ID is now `com.pagewise.reader`; change it first if you want a different one.

**Accounts:** login, sign up and log out now work out of the box. Without Supabase keys, accounts are stored on the device only. Add the keys (see Accounts below) to sync across devices.

## 1. One-time setup on your computer
- Node.js 22 or newer (nodejs.org)
- Android Studio (developer.android.com/studio). Open it once and let it install the Android SDK.

## 2. Before anything else: set your app ID
Open `capacitor.config.json` and change `appId` from `com.example.pagewise` to something
unique that you own, for example `com.yourname.pagewise`.
**Do this now.** The app ID is permanent on the Play Store and awkward to change later.

## 3. Create the Android project
Run these in this folder:

    npm install
    npx cap add android
    npx capacitor-assets generate --android
    npx cap sync android
    npx cap open android

`cap add android` creates the `android/` folder. `capacitor-assets` turns the images in
`assets/` into every icon size. `cap open` opens the project in Android Studio.

## 4. Test it on your phone
1. On the phone: Settings, About phone, tap Build number 7 times, then enable USB debugging in Developer options.
2. Plug it in, pick it in the device dropdown in Android Studio, press the green Run button.
3. Read a book. Check: opening EPUB/PDF/TXT, page flip, highlights, bookmarks, shelves, and
   the Android Back button (it should close panels, then the book, then exit).

Whenever you change `www/`, run `npx cap sync android` and press Run again.

## 5. Build the release file (.aab)
1. In `android/app/build.gradle`, set `versionCode` (a whole number, +1 for every upload) and `versionName`.
2. Android Studio: Build, Generate Signed App Bundle / APK, choose Android App Bundle.
3. Create a new keystore when asked. **Back up the keystore file and its passwords somewhere safe.**
   Never commit it to git. (Play App Signing means Google holds the final signing key, and yours is the upload key.)
4. Choose the `release` variant. You get `app-release.aab`.

## 6. Play Console checklist (play.google.com/console)
- [ ] Developer account: one-time $25 fee plus identity verification
- [ ] Create app: name, default language, free app
- [ ] Store listing (text is drafted in `docs/store-listing.md`)
  - [ ] Icon 512x512: `docs/play-icon-512.png`
  - [ ] Feature graphic 1024x500: `docs/feature-graphic-1024x500.png`
  - [ ] At least 2 phone screenshots (take your own on the phone)
- [ ] Privacy policy: host `docs/privacy-policy.md` as a public web page (GitHub Pages works) and paste the URL
- [ ] Data safety form: this version collects no data (see the policy for the reasoning)
- [ ] Content rating questionnaire, target audience (not for children), ads declaration (no ads)
- [ ] Check the target API level warning when you upload. If Play asks for a newer one, update Capacitor and rebuild.

## 7. The testing gate (plan for it early)
Personal developer accounts created after 13 Nov 2023 must run a **closed test with at least
12 testers opted in for 14 continuous days** before applying for production access. Organization accounts are exempt.
1. Testing, Closed testing, create a track, upload the `.aab`.
2. Add testers by Google account email (or a Google Group) and share the opt-in link.
3. Keep 12+ testers opted in for 14 days straight, then apply for production access in the Dashboard.
Start recruiting testers while you build. Friends, family and reading communities all work.

## Accounts (sign up, log in, log out)
Accounts use Supabase (free tier is enough). Until you add your keys the app works exactly as before, on-device only.
1. Create a project at supabase.com.
2. SQL Editor: run `docs/supabase-setup.sql` (one table, locked so each user can only touch their own row).
3. Project Settings, API: copy the **Project URL** and the **anon public** key (never the service_role key).
4. In `www/index.html` find `var CFG={url:"",key:""}` and paste both values in.
5. Authentication, Providers, Email: leave "Confirm email" on for production (sign-up then asks the user to confirm before logging in), or turn it off while testing.
6. `npx cap sync android`, then Run.
First launch shows a sign-up screen with "Continue without an account". The Account tab has Log in / Log out. Synced: progress, bookmarks, highlights, shelves, settings. Not synced: book files and your AI key. Logging out keeps the books and reading data on that device.
**Update `docs/privacy-policy.md` and the Play Data safety form before shipping:** with accounts on, the app collects email addresses and stores reading data on your Supabase project.

## What is not in this version
- **Community and shared reading progress:** needs more server work.
- AI still runs on a key the user pastes in on the device (see below). A hosted AI key behind your own server is the next step if you want AI included in a paid plan.

## 3D shelves
Each shelf is a wooden bookcase with real 3D books (cover, spine, page edge, top). Customize, Shelf finish (Oak, Walnut, Ebony, White, Slate), Books on shelf (Covers or Spines), Shelf light on/off. The 3D depth slider and motion tilt apply to the books too. Spines view is for browsing; use Covers to move or remove books.

## Looks and 3D (added)
- **Customize** (home) or **Aa, Wallpapers, colors & 3D** (while reading): 9 themes including a Custom one with your own page and text colors; separate wallpapers for the home screen and for reading pages (presets or your own photo, with blur and tint sliders); 3D depth slider and motion-tilt toggle.
- Photos are resized and stored on the device only.

## AI chat in the Android app
Open the app, go to the Account tab and paste an Anthropic API key. It stays on the device (never synced) and powers the Ask tab, chapter summaries and shelf sorting. Chapter text is sent to Anthropic when you use AI, so mention this in your privacy policy.
