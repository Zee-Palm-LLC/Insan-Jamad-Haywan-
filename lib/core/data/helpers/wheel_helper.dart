import 'dart:math';
import 'dart:ui';

class WheelHelper {
  static List<String> getAlphabets() {
    return List.generate(26, (i) => String.fromCharCode(65 + i));
  }

  static List<String> getAlphabetsShuffled() {
    final alphabets = getAlphabets();
    alphabets.shuffle(Random());
    return alphabets;
  }

  static final List<Color> _colors = const [
    Color(0xFFFCF0DA),
    Color(0xFFBED6E2),
    Color(0xFF449F50),
    Color(0xFFF66F6C),
    Color(0xFFFFD767),
  ];

  static Color getColorForIndex(int index) {
    return _colors[index % _colors.length];
  }

 static String formattedTime({required double minutes, required double seconds}) {
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}
