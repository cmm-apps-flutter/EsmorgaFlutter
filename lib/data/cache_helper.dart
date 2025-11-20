class CacheHelper {
  static const int cacheValidityDuration = 300000;

  static bool shouldReturnCache(int creationTime) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    return (currentTime - creationTime) < cacheValidityDuration;
  }
}

