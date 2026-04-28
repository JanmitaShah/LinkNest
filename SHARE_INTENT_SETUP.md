t# Share Intent Configuration for LinkNest

This document describes the implementation that allows LinkNest to appear in the share sheet when users share links from other apps, similar to WhatsApp, LinkedIn, and other popular apps.

## Overview

The implementation configures LinkNest to handle shared content (URLs, text, and images) on Android, iOS, and Web platforms.

## Android Configuration

### File: `android/app/src/main/AndroidManifest.xml`

Added multiple intent filters to handle different types of shared content:

1. **Text Sharing** - Handles plain text and HTML content
   ```xml
   <intent-filter>
       <action android:name="android.intent.action.SEND" />
       <category android:name="android.intent.category.DEFAULT" />
       <data android:mimeType="text/plain" />
       <data android:mimeType="text/html" />
   </intent-filter>
   ```

2. **Image Sharing** - Handles single image shares
   ```xml
   <intent-filter>
       <action android:name="android.intent.action.SEND" />
       <category android:name="android.intent.category.DEFAULT" />
       <data android:mimeType="image/*" />
   </intent-filter>
   ```

3. **Multiple Image Sharing** - Handles multiple image shares
   ```xml
   <intent-filter>
       <action android:name="android.intent.action.SEND_MULTIPLE" />
       <category android:name="android.intent.category.DEFAULT" />
       <data android:mimeType="image/*" />
   </intent-filter>
   ```

### File: `android/app/src/main/res/values/strings.xml`

Created to properly define the app name as a string resource:
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">LinkNest</string>
</resources>
```

The AndroidManifest.xml now references this string resource:
```xml
<application
    android:label="@string/app_name"
    ... >
```

## iOS Configuration

### File: `ios/Runner/Info.plist`

Added several configurations to enable share sheet integration:

1. **URL Scheme Configuration** - Allows the app to handle custom URL schemes
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleTypeRole</key>
           <string>Editor</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>linkstore</string>
           </array>
       </dict>
   </array>
   ```

2. **Document Interaction** - Declares support for URL types
   ```xml
   <key>CFBundleDocumentInteraction</key>
   <dict>
       <key>UTExportedTypeDeclarations</key>
       <array>
           <dict>
               <key>UTTypeIdentifier</key>
               <string>public.url</string>
               <key>UTTypeDescription</key>
               <string>URL</string>
               <key>UTTypeConformsTo</key>
               <array>
                   <string>public.data</string>
               </array>
           </dict>
       </array>
   </dict>
   ```

3. **LSApplicationQueriesSchemes** - Allows the app to query for other apps
   ```xml
   <key>LSApplicationQueriesSchemes</key>
   <array>
       <string>whatsapp</string>
       <string>linkedin</string>
       <string>twitter</string>
       <string>facebook</string>
       <string>instagram</string>
       <string>telegram</string>
       <string>signal</string>
   </array>
   ```

4. **App Name Updates** - Updated to "LinkNest" for consistency
   ```xml
   <key>CFBundleDisplayName</key>
   <string>LinkNest</string>
   <key>CFBundleName</key>
   <string>LinkNest</string>
   ```

## Web Configuration

### File: `web/manifest.json`

Added `share_target` configuration for PWA share sheet integration:
```json
{
    "name": "LinkNest",
    "short_name": "LinkNest",
    "description": "A personal link manager app to save and organize video links.",
    "share_target": {
        "action": "/?share_target",
        "method": "GET",
        "enctype": "application/x-www-form-urlencoded",
        "params": {
            "title": "title",
            "text": "text",
            "url": "url"
        }
    },
    "theme_color": "#00D9FF",
    "background_color": "#12183D"
}
```

### File: `web/index.html`

Updated meta tags for proper PWA behavior:
```html
<meta name="description" content="A personal link manager app to save and organize video links.">
<meta name="apple-mobile-web-app-title" content="LinkNest">
<meta name="theme-color" content="#00D9FF">
<title>LinkNest</title>
```

## How It Works

### Android
When a user selects "Share" in another app, Android shows a share sheet with all apps that have registered intent filters matching the content type. LinkNest now appears for:
- Text and HTML content (URLs, notes, etc.)
- Images (single or multiple)

### iOS
The URL scheme and document interaction configurations allow iOS to recognize LinkNest as an app that can handle shared URLs. The `LSApplicationQueriesSchemes` allows the app to check for other installed apps.

### Web
The `share_target` configuration in the web app manifest enables PWA share sheet integration on supported browsers (primarily Chrome on Android).

## Testing

### Android
1. Open any app that allows sharing (e.g., Chrome, YouTube)
2. Tap the Share button
3. Look for "LinkNest" in the share sheet
4. Select LinkNest to share content

### iOS
1. Open Safari or any app with a Share button
2. Tap Share
3. Look for "LinkNest" in the share options
4. You may need to scroll or tap "More" to find it

### Web
1. Install the PWA on a supported device
2. Use the share feature in a browser
3. The app should appear in the share options

## Existing Share Intent Handling

The app already has robust share intent handling implemented in:
- `lib/core/services/share_intent_service.dart` - Handles incoming share intents
- `lib/features/links/presentation/providers/share_intent_provider.dart` - Riverpod provider for share intent state
- `lib/main.dart` - Listens for share intents and navigates to add link screen

When a user shares content to LinkNest, the app:
1. Receives the shared content via `receive_sharing_intent` package
2. Extracts URLs from the shared text
3. Automatically navigates to the "Add Link" screen with the URL pre-filled
4. Allows the user to save and organize the shared link

## Notes

- The app name has been standardized to "LinkNest" across all platforms (was "LinkStore" in some places)
- All configurations follow platform-specific best practices
- The implementation is backward compatible and doesn't affect existing functionality
- Users may need to restart their device or reinstall the app for iOS changes to take full effect