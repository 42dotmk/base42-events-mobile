/// Centralized membership pricing constants.
/// TODO: fetch these from the backend API so price changes propagate
/// without requiring users to update the app.
class MembershipPricing {
  static const String monthlyPrice = '€10';
  static const String yearlyPrice = '€99';
  static const String monthlyInterval = 'mo';
  static const String yearlyInterval = 'yr';
  static const String monthlyPerMonth = '€8.25';

  static String priceForTier(String tier) =>
      tier == 'yearly' ? yearlyPrice : monthlyPrice;

  static String intervalForTier(String tier) =>
      tier == 'yearly' ? yearlyInterval : monthlyInterval;

  static String displayForTier(String tier) =>
      tier == 'yearly' ? '$yearlyPrice/$yearlyInterval' : '$monthlyPrice/$monthlyInterval';
}
