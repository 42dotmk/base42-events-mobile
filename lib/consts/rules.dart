class HouseRule {
  final String title;
  final String description;
  final String imageAssetPath;

  const HouseRule({
    required this.title,
    required this.description,
    required this.imageAssetPath,
  });
}

const List<HouseRule> houseRules = [
  HouseRule(
    title: 'No recruitment',
    description:
        'Base42 is a hackerspace, not LinkedIn with better lighting.',
    imageAssetPath: 'assets/rules/marvin_bot_rules_icon_no_recruit.png',
  ),
  HouseRule(
    title: 'No co-working space',
    description:
        'You are welcome to learn, experiment, and hang out, but please don\'t move in with your laptop and call it "remote work."',
    imageAssetPath: 'assets/rules/marvin_bot_rules_icon_no_recruit.png',
  ),
  HouseRule(
    title: 'Leave the place as you found it, or better',
    description:
        'Future humans should not have to solve the mystery of your coffee cup, cables, crumbs, or abandoned project parts.',
    imageAssetPath: 'assets/rules/marvin_bot_rules_icon_friend.png',
  ),
  HouseRule(
    title: 'Report equipment use on Discord',
    description:
        'If you use tools, hardware, the 3D printer, server rack, or anything that looks expensive, powerful, or slightly dangerous, let the community know.',
    imageAssetPath: 'assets/rules/marvin_bot_rules_icon_report.png',
  ),
  HouseRule(
    title: 'Be friendly with everyone',
    description:
        'Be kind, be respectful, and remember that the best hackerspace tool is still good vibes.',
    imageAssetPath: 'assets/rules/marvin_bot_rules_icon_friend.png',
  ),
];
