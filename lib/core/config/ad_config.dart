import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdConfig {
  // Global flag to enable/disable all ads
  static const bool showAds = true;

  // Ad Unit IDs - Replace with your actual ad unit IDs
  // Android Ad Unit IDs
  static const String androidBannerAdUnitId = 'ca-app-pub-6095009079751828/8779308646'; // 'ca-app-pub-3940256099942544/6300978111'; Test ID
  // ca-app-pub-6095009079751828~7233458538 - Android App ID
  static const String androidInterstitialAdUnitId = 'ca-app-pub-6095009079751828/6699420695'; // 'ca-app-pub-3940256099942544/1033173712';  Test ID
  
  // iOS Ad Unit IDs
  static const String iosBannerAdUnitId = 'ca-app-pub-6095009079751828/1617862289'; // 'ca-app-pub-3940256099942544/2934735716'; // Test ID
  // ca-app-pub-6095009079751828~1748890075 - iOS App Id
  static const String iosInterstitialAdUnitId = 'ca-app-pub-6095009079751828/5285644556'; // 'ca-app-pub-3940256099942544/4411468910'; // Test ID

  // Get correct Ad Unit ID based on current platform
  static String get bannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return androidBannerAdUnitId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosBannerAdUnitId;
    }
    // Fallback for other platforms
    return androidBannerAdUnitId;
  }

  static String get interstitialAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return androidInterstitialAdUnitId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosInterstitialAdUnitId;
    }
    // Fallback for other platforms
    return androidInterstitialAdUnitId;
  }

  // Ad loading retry settings
  static const int maxRetryAttempts = 3;
  static const int retryDelayInSeconds = 2;

  // Interstitial ad trigger settings
  static const int linksViewedBeforeAd = 3; // Show ad after every 3 links viewed
}

class AdManager {
  static InterstitialAd? _interstitialAd;
  static int _linksViewedCount = 0;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!AdConfig.showAds) return;

    await MobileAds.instance.initialize();
    _isInitialized = true;

    // Preload first interstitial ad
    _loadInterstitialAd();
  }

  static bool get isAdsEnabled => AdConfig.showAds && _isInitialized;

  // Banner Ad Methods
  static BannerAd createBannerAd({
    required AdSize size,
    required BannerAdListener listener,
  }) {
    return BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: listener,
    );
  }

  // Interstitial Ad Methods
  static void _loadInterstitialAd() {
    if (!isAdsEnabled) return;

    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _setupInterstitialCallbacks();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          // Retry loading after delay
          Future.delayed(
            const Duration(seconds: AdConfig.retryDelayInSeconds),
            () => _loadInterstitialAd(),
          );
        },
      ),
    );
  }

  static void _setupInterstitialCallbacks() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      },
    );
  }

  static void onLinkViewed() {
    if (!isAdsEnabled) return;

    _linksViewedCount++;

    if (_linksViewedCount >= AdConfig.linksViewedBeforeAd && _interstitialAd != null) {
      _interstitialAd!.show();
      _linksViewedCount = 0;
    } else if (_interstitialAd == null) {
      _loadInterstitialAd();
    }
  }

  static void dispose() {
    _interstitialAd?.dispose();
  }
}