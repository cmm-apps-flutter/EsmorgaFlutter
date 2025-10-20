class CacheHelper {
  static const int cacheValidityDuration = 3600000;

  static bool shouldReturnCache(int creationTime) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    return (currentTime - creationTime) < cacheValidityDuration;
  }
}

