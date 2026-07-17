/// Centralized membership pricing constants.
/// Update these when Stripe prices change.
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
