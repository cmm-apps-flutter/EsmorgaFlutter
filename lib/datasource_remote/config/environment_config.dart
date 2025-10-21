enum Environment {
  qa,
  prod,
}

class EnvironmentConfig {
  final Environment environment;
  final String baseUrl;

  const EnvironmentConfig({
    required this.environment,
    required this.baseUrl,
  });

  static const EnvironmentConfig qa = EnvironmentConfig(
    environment: Environment.qa,
    baseUrl: 'https://qa.api.esmorgaevents.com/v1/',
  );

  static const EnvironmentConfig prod = EnvironmentConfig(
    environment: Environment.prod,
    baseUrl: 'https://api.esmorgaevents.com/v1/',
  );

  static EnvironmentConfig _current = qa;

  static EnvironmentConfig get current => _current;

  static void setEnvironment(EnvironmentConfig config) {
    _current = config;
  }

  static String get currentBaseUrl => _current.baseUrl;

  static bool get isQA => _current.environment == Environment.qa;

  static bool get isProd => _current.environment == Environment.prod;

  static void initFromDartDefine() {
    const value = String.fromEnvironment('ESMORGA_ENV', defaultValue: 'qa');
    switch (value.toLowerCase()) {
      case 'prod':
      case 'production':
        setEnvironment(prod);
        break;
      case 'qa':
      case 'dev':
      default:
        setEnvironment(qa);
    }
  }
}
