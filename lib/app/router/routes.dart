class Routes {
  static const String root = '/';
  
  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main Tabs
  static const String home = '/home';
  static const String markets = '/markets';
  static const String wallet = '/wallet';
  static const String activity = '/activity';
  static const String profile = '/profile';

  // Sub-routes
  static const String assetDetail = 'detail/:coinId';
  static const String send = 'send';
  static const String receive = 'receive';
  static const String deposit = 'deposit';
  static const String withdraw = 'withdraw';
  static const String transactionDetail = 'tx/:transactionId';
  
  // Full-screen flows outside the shell
  static const String buy = '/buy/:coinId';
  static const String sell = '/sell/:coinId';
}
