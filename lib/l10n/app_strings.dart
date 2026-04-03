import 'package:flutter/widgets.dart';
import 'package:base42_events_mobile/providers/settings_provider.dart';
import 'package:provider/provider.dart';

/// Abstract localization class.
///
/// Usage:
///   final s = AppStrings.of(context);   // reactive — rebuilds on locale change
///   final s = AppStrings.forLocale('mk'); // non-reactive — use in callbacks
///
/// To add a new language: create a new concrete class and add it to [forLocale].
/// To add strings for a new screen: add getters here + implement in both classes.
abstract class AppStrings {
  const AppStrings();

  /// Returns strings for the current locale and rebuilds when it changes.
  static AppStrings of(BuildContext context) =>
      forLocale(context.watch<SettingsProvider>().locale);

  /// Returns strings for the given locale without watching.
  static AppStrings forLocale(String locale) =>
      locale == 'mk' ? const _MkStrings() : const _EnStrings();

  String get langMk;
  String get langEn;

  String get obSkip;
  String get obEnterButton;

  String get ob1Badge;
  String get ob1Title;
  String get ob1Subtitle;
  String get ob1LocationTitle;
  String get ob1LocationSub;
  String get ob1Block1;
  String get ob1Block2;
  String get ob1Block3;
  String get ob1Block4;
  String get ob1Block5;

  String get ob2Label;
  String get ob2Title;
  String get ob2Card1Title;
  String get ob2Card1Body;
  String get ob2Card2Title;
  String get ob2Card2Body;

  String get ob3Label;
  String get ob3Title;
  String ob3RulesCount(int count);
  List<String> get ob3Rules;
  List<int> get ob3RuleNumbers;

  String get ob4Title;
  String get ob4Subtitle;
  String get ob4PassHeader;
  String get ob4AccessGranted;
  String get ob4StatusLabel;
  String get ob4StatusValue;
  String get ob4LevelLabel;
  String get ob4LevelValue;
  String get ob4AccessLabel;
  String get ob4AccessValue;
  String get ob4LocationLabel;
  String get ob4LocationValue;
  String get ob4GalaxyLabel;
  String get ob4GalaxyValue;
}

class _MkStrings extends AppStrings {
  const _MkStrings();

  @override
  String get langMk => 'МК';
  @override
  String get langEn => 'EN';

  @override
  String get obSkip => 'Прескокни';
  @override
  String get obEnterButton => 'Влези во Base42';

  @override
  String get ob1Badge => '⚠️  ВНИМАНИЕ, ВНИМАНИЕ!!!!  ⚠️';
  @override
  String get ob1Title => 'IT Универзумот\nе пред тебе!';
  @override
  String get ob1Subtitle => 'Ти се извинуваме однапред за непријатностите 🙏';
  @override
  String get ob1LocationTitle => 'Римска 25, Тафталиџе';
  @override
  String get ob1LocationSub => 'Base42';
  @override
  String get ob1Block1 =>
      'Автостоперу, добре дојде на оваа попатна станица негде во Галаксијата. Во моментов се наоѓаш на еден суперкомпјутер наречен Земја, познат исто така и како мала бледа сина точка. Во моментов се движиш со 30 км во секунда и се движиш кон… зумирај, зумирај… уште малку… по лево. Десно! Уште десно… Нагоре! Зумирај. Уште малку… Е таму.';
  @override
  String get ob1Block2 =>
      'За некои претставува уште една попатна станица, за други — неискористен спа центар со џакузи и сауна, а за трети ХАКЕРСПЕЈС за гикови. Во моментот ја отвори неговата мобилна апликација. Веројатноста да бидеш жив и во исто време да се создаде вакво место и да ја отвориш оваа апликација беше толку мала што е просто невозможно дека сега ти се обраќаме. Ти се верува? Нас да.';
  @override
  String get ob1Block3 =>
      'Шансите за вакво нешто беа скоро 0. Ама го направивме невозможното, уште го правиме и сакаме и ти да го правиш со нас. Не ти е јасно? НЕ ПАНИЧИ! Од Base42 секој пат е вистинскиот пат до нова неоткриена авантура.';
  @override
  String get ob1Block4 =>
      'Апликацијава е наменета за неофицијално и неформално дружење и соработка меѓу различни земни и неземни ентитети, патници низ IT Универзумот со помалку или повеќе искуство.';
  @override
  String get ob1Block5 =>
      'Преку неа може да разменуваш IT знаење во секаква форма и вид, да следиш настани и да резервираш простор, а може да ги споделиш и твоите маки, желби, соништа, багови, непријатели.';

  @override
  String get ob2Label => 'МЕСТОТО';
  @override
  String get ob2Title => 'Место за градители\nи љубопитни.';
  @override
  String get ob2Card1Title => 'Знаење за секого';
  @override
  String get ob2Card1Body =>
      'Почнато со идејата дека знаењето треба да се шири колку е можно повеќе, колку е можно почесто и да достигне до колку е можно повеќе луѓе.\n\nЦелта на Base42 е да помогне да се поддржат луѓето и да се охрабри создавање на заедници, да им се дадат алатки за да растат, да се собираат заедно и да работат кон таа цел. Да градат заедно, а не сами.';
  @override
  String get ob2Card2Title => 'Не коворкинг простор. Хакерспејс.';
  @override
  String get ob2Card2Body =>
      'Во канцеларија се оди да се работи. Во хакерспејс се оди да се хакира.\n\nКоворкинг просторите ги промовираат комерцијалните цели на сопственички код и информации. Хакерспејсот е токму спротивното — доаѓаш да учиш, истражуваш, не само сам туку и од своите соученици. Треба да бидеш слободен да прашаш и да те прашаат да го споделиш своето знаење.';

  @override
  String get ob3Label => 'ПРАВИЛАТА НА АВТОСТОПЕРОТ';
  @override
  String get ob3Title => 'Неколку насоки за\nпатниците — автостопери';
  @override
  String ob3RulesCount(int count) => '$count правила';
  @override
  List<int> get ob3RuleNumbers => const [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    21,
    23,
    24,
  ];
  @override
  List<String> get ob3Rules => const [
    'НЕ ПАНИЧИ!',
    'Почитувај го 42. Тој е одговорот на смислата на животот, Универзумот и сѐ. Почитувај ги и сите негови следбеници. Однесувај се како дел од напредна цивилизација, а не како едноклеточно суштество.',
    'Гостите културно е да се претстават. Претстави се на настаните и запознај ги луѓето. После тоа те посвојуваме и си наш.',
    'Овде секој е важен и секој треба да придонесува волонтерски и по своја волја. Заедно создаваме и ја правиме смислата на 42.',
    'Внимавај на чудните ентитети што не се дел од нашата култура: реклами за вработување, ејчарки, зборовите "co-working space" и "recruitment". Ако налеташ на нешто такво — имаме проблем. (тивко) Не паничи! Не паничи!',
    'Нашиот вселенски брод се движи од страст и пасија кон технологијата. Доколку пробаш да го движиш само за профит, моторот ќе се расипе и после тоа ќе те изеде нешто. Не знам што, ама ќе те изеде.',
    'Доаѓа крајот на светот? Или апликацијата крашнува? Или двете? Напиј се пиво. Секогаш има време за пиво.',
    'Биди со отворен ум за нови предизвици, луѓе и технологии во оваа Галаксија.',
    'Чудните суштества се најдобри пријатели.',
    'На сите патувања носи удобна облека, по можност бањарка и пижами. Ако не носиш пижами, бањарката врзи ја убаво.',
    'Нормалност не постои. А и да постои, не е интересно.',
    'Кога сите планови ќе пропаднат и ништо не функционира, импровизирај. Голем дел од работите можат да бидат средени со пешкир и селотејп. За останатото, прашај некој член на Base42 да помогне.',
    'Изговор ти е дека немаш време? Универзумот нема да чека. Ако сакаш авантура мора да имаш време.',
    'Помогни на секој што се наоѓа на патувањето со тебе. Сподели код, кафе или разговор.',
    'Прочитај ја Автостоперски водич низ Галаксијата.',
    'Прочитај уште некоја книга.',
    'Ако имаш документација и водич — искористи ги.',
    'На сите планети има административни задачи и пишување документација, помири се со тоа.',
    'Биди благодарен за неверојатните веројатности околу тебе.',
    'Сѐ е поинтересно во живо. Понекогаш сврати на нашата физичка локација на Римска 25. Ќе видиш стоп знак со името Base42. Е таму пријателе, те чекаме.',
    'Џакузито се користи без вода, само за состаноци.',
    'Нема правила, освен таму каде што треба да има правила!',
  ];

  @override
  String get ob4Title => 'Добредојде\nна борд!';
  @override
  String get ob4Subtitle =>
      'Твоето патување низ галаксијата официјално започна.';
  @override
  String get ob4PassHeader => 'BOARDING PASS';
  @override
  String get ob4AccessGranted => 'ПРИСТАП ОДОБРЕН';
  @override
  String get ob4StatusLabel => 'СТАТУС';
  @override
  String get ob4StatusValue => 'Автостопер';
  @override
  String get ob4LevelLabel => 'НИВО';
  @override
  String get ob4LevelValue => '42';
  @override
  String get ob4AccessLabel => 'ПРИСТАП';
  @override
  String get ob4AccessValue => 'Неограничен';
  @override
  String get ob4LocationLabel => 'ЛОКАЦИЈА';
  @override
  String get ob4LocationValue => 'Римска 25, Скопје';
  @override
  String get ob4GalaxyLabel => 'ГАЛАКСИЈА';
  @override
  String get ob4GalaxyValue => 'Млечен Пат, Сектор 42';
}

class _EnStrings extends AppStrings {
  const _EnStrings();

  @override
  String get langMk => 'МК';
  @override
  String get langEn => 'EN';

  @override
  String get obSkip => 'Skip';
  @override
  String get obEnterButton => 'Enter Base42';

  @override
  String get ob1Badge => '⚠️  ATTENTION, ATTENTION!!!!  ⚠️';
  @override
  String get ob1Title => 'The IT Universe\nis before you!';
  @override
  String get ob1Subtitle => 'We apologize in advance for any inconvenience 🙏';
  @override
  String get ob1LocationTitle => 'Rimska 25, Taftalidze';
  @override
  String get ob1LocationSub => 'Base42';
  @override
  String get ob1Block1 =>
      'Hitchhiker, welcome to this waystation somewhere in the Galaxy. Right now you\'re on a supercomputer called Earth, also known as a pale blue dot. You\'re moving at 30 km/s towards... zoom in, zoom in... a little more... to the left. Right! More right... Up! Zoom. A little more... There it is.';
  @override
  String get ob1Block2 =>
      'For some it\'s just another waystation, for others — an unused spa with jacuzzi and sauna, and for others a HACKERSPACE for geeks. You\'ve just opened its mobile application. The probability of you being alive AND this place existing AND you opening this app was so small that it\'s simply impossible we\'re addressing you now. Do you believe it? We do.';
  @override
  String get ob1Block3 =>
      'The chances for something like this were almost 0. But we did the impossible, we\'re still doing it and we want you to do it with us. Not clear? DON\'T PANIC! From Base42, every path is the right path to a new undiscovered adventure.';
  @override
  String get ob1Block4 =>
      'This app is intended for unofficial and informal socializing and collaboration between various earthly and non-earthly entities, travelers through the IT Universe with more or less experience.';
  @override
  String get ob1Block5 =>
      'Through it you can exchange IT knowledge in any form, follow events and book spaces, and share your struggles, wishes, dreams, bugs, and enemies.';

  @override
  String get ob2Label => 'THE PLACE';
  @override
  String get ob2Title => 'A place for builders,\nand the curious.';
  @override
  String get ob2Card1Title => 'Knowledge for everyone';
  @override
  String get ob2Card1Body =>
      'Started with the idea that knowledge should be proliferated as much as possible, as often as possible and reach as many people as possible.\n\nThe goal of Base42 is to help enable people and encourage communities to be created, give them the tools to grow, get together and focus on achieving that goal. To build together, not alone.';
  @override
  String get ob2Card2Title => 'Not a coworking space. A hackerspace.';
  @override
  String get ob2Card2Body =>
      'You go to an office to work. You come to a hackerspace to hack.\n\nCoworking spaces promote commercial goals of proprietary code and information. A hackerspace is the exact opposite — you come to learn, explore, not just on your own but from your peers as well. You should be free to ask and be asked to share your knowledge.';

  @override
  String get ob3Label => 'THE HITCHHIKER\'S RULES';
  @override
  String get ob3Title => 'A few guidelines for\ntravelers — hitchhikers';
  @override
  String ob3RulesCount(int count) => '$count rules';
  @override
  List<int> get ob3RuleNumbers => const [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    21,
    23,
    24,
  ];
  @override
  List<String> get ob3Rules => const [
    'DON\'T PANIC!',
    'Respect 42. It is the answer to the meaning of life, the Universe and everything. Respect all its followers. Behave as part of an advanced civilization, not as a single-celled organism.',
    'It\'s customary for guests to introduce themselves. Introduce yourself at events and get to know the people. After that we adopt you and you\'re ours.',
    'Everyone here is important and everyone should contribute voluntarily and of their own free will. Together we create and give meaning to 42.',
    'Watch out for strange entities not part of our culture: job ads, HR recruiters, the words "co-working space" and "recruitment". If you encounter something like that here, we have a problem. (quietly) Don\'t panic! Don\'t panic!',
    'Our spaceship runs on passion and love for technology. If you try to run it only for profit, the engine will break and then something will eat you. I don\'t know what, but it will eat you.',
    'End of the world coming? Or is the app crashing? Or both? Have a beer. There\'s always time for beer.',
    'Be open-minded to new challenges, people and technologies in this Galaxy.',
    'Strange creatures are the best friends.',
    'On all journeys bring comfortable clothes, preferably a bathrobe and pajamas. If you don\'t bring pajamas, tie the bathrobe well.',
    'Normality doesn\'t exist. And even if it did, it wouldn\'t be interesting.',
    'When all plans fail and nothing works, improvise. Most things can be fixed with a towel and duct tape. For the rest, ask a fellow Base42 member to help.',
    'No time is your excuse? The Universe won\'t wait. If you want adventure you must make time.',
    'Help everyone on the journey with you. Share code, coffee or conversation.',
    'Read The Hitchhiker\'s Guide to the Galaxy.',
    'Read some other book.',
    'If you have documentation and a guide — use them.',
    'On all planets there are administrative tasks and writing documentation, accept it.',
    'Be grateful for the incredible probabilities around you.',
    'Everything is more interesting in person. Sometimes stop by our physical location at Rimska 25. You\'ll see a stop sign with the name Base42. That\'s where we\'re waiting for you, friend.',
    'The jacuzzi is used without water, only for meetings.',
    'There are no rules, except where there need to be rules!',
  ];

  @override
  String get ob4Title => 'Welcome\naboard!';
  @override
  String get ob4Subtitle =>
      'Your journey through the galaxy has officially begun.';
  @override
  String get ob4PassHeader => 'BOARDING PASS';
  @override
  String get ob4AccessGranted => 'ACCESS GRANTED';
  @override
  String get ob4StatusLabel => 'STATUS';
  @override
  String get ob4StatusValue => 'Hitchhiker';
  @override
  String get ob4LevelLabel => 'LEVEL';
  @override
  String get ob4LevelValue => '42';
  @override
  String get ob4AccessLabel => 'ACCESS';
  @override
  String get ob4AccessValue => 'Unrestricted';
  @override
  String get ob4LocationLabel => 'LOCATION';
  @override
  String get ob4LocationValue => 'Rimska 25, Skopje';
  @override
  String get ob4GalaxyLabel => 'GALAXY';
  @override
  String get ob4GalaxyValue => 'Milky Way, Sector 42';
}
