# BWeather GitHub Actions setup

Copy `release.yml` to `.github/workflows/release.yml` in the root of the BWeather repository.

## 1. Configure Android signing secrets

The Android release job requires a real release/upload keystore. In GitHub, open:

**Repository → Settings → Secrets and variables → Actions → New repository secret**

Create these four repository secrets:

- `ANDROID_KEYSTORE_BASE64` — Base64 of the `.jks` or `.keystore` file, without certificate headers.
- `ANDROID_KEYSTORE_PASSWORD` — keystore password.
- `ANDROID_KEY_ALIAS` — key alias.
- `ANDROID_KEY_PASSWORD` — key password.

On Windows CMD, generate the Base64 value with:

```cmd
powershell -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('my-release-key.jks'))"
```

Copy the output directly into `ANDROID_KEYSTORE_BASE64`. Do not commit the keystore or `android/key.properties`.

The workflow writes `android/key.properties` during the Android job and uses the signing configuration already present in `android/app/build.gradle.kts`.

## 2. Enable GitHub Pages

Open:

**Repository → Settings → Pages → Build and deployment → Source**

Select **GitHub Actions**.

The workflow deploys the Flutter Web build whenever code is pushed to `main`.

For a normal project repository, the workflow automatically builds with `/<repository-name>/` as the Web base path. For a custom domain served from the root, add a repository Actions variable:

- Name: `WEB_BASE_HREF`
- Value: `/`

For an account/organization Pages repository named `<owner>.github.io`, the workflow automatically uses `/`.

## 3. Publish a release

Push a version tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The workflow builds Android, Windows, Linux, and Web in parallel. Once all builds succeed, it creates a GitHub Release and attaches the requested assets.

You can also create and push later tags such as `v1.0.1` or `v1.1.0`.

## 4. Important desktop packaging note

`bweather.exe` and the Linux `bweather` file are the requested executable files, but neither is a complete portable desktop application by itself. Distribute `bweather-windows.zip` on Windows and `bweather-linux.tar.gz` on Linux so the Flutter runtime, assets, and bundled libraries are included.

The Web `bweather.zip` contains the contents of `build/web` at the ZIP root, ready to host as a static site.

## 5. Repository permissions

If release publishing fails with a permissions error, open:

**Repository → Settings → Actions → General → Workflow permissions**

Enable **Read and write permissions**. The release job also declares `contents: write` explicitly.
