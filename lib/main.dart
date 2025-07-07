import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart' as material;

void main() {
  runApp(const RialTomanConverterApp());
}

class RialTomanConverterApp extends StatelessWidget {
  const RialTomanConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rial ⇄ Toman',
      theme: ThemeData(
        fontFamily: 'Vazir',
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: const ConverterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final rialController = TextEditingController();
  final tomanController = TextEditingController();

  String rialLabel = '';
  String tomanLabel = '';
  String outputText = '';

  final maxLimit = 999999999999;

  @override
  void dispose() {
    rialController.dispose();
    tomanController.dispose();
    super.dispose();
  }

  String formatNumber(int number) {
    return NumberFormat("#,###", "fa").format(number);
  }

  void updateLabel(String value, String type) {
    if (value.isEmpty) {
      setState(() {
        if (type == 'rial') rialLabel = '';
        if (type == 'toman') tomanLabel = '';
      });
      return;
    }

    final number = int.tryParse(value);
    if (number == null) return;

    if (number > maxLimit) {
      setState(() {
        if (type == 'rial') rialLabel = 'عدد خیلی بزرگ است!';
        if (type == 'toman') tomanLabel = 'عدد خیلی بزرگ است!';
      });
    } else {
      final text = '${convertNumberToText(number)} ${type == 'rial' ? 'ریال' : 'تومان'}';
      setState(() {
        if (type == 'rial') rialLabel = text;
        if (type == 'toman') tomanLabel = text;
      });
    }
  }

  void convertToToman() {
    final rial = int.tryParse(rialController.text);
    if (rial == null) {
      setState(() {
        outputText = 'لطفاً عدد معتبر وارد کنید';
      });
      return;
    }
    final toman = rial ~/ 10;
    final formatted = formatNumber(toman);
    final text = convertNumberToText(toman);
    setState(() {
      outputText = '$formatted تومان\n$text تومان';
    });
  }

  void convertToRial() {
    final toman = int.tryParse(tomanController.text);
    if (toman == null) {
      setState(() {
        outputText = 'لطفاً عدد معتبر وارد کنید';
      });
      return;
    }
    final rial = toman * 10;
    final formatted = formatNumber(rial);
    final text = convertNumberToText(rial);
    setState(() {
      outputText = '$formatted ریال\n$text ریال';
    });
  }

  void openGithub() async {
    const url = 'https://github.com/Amirabbasjadidi/RialToman_Exchange';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: material.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تبدیل ریال و تومان'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildTextField(
                      controller: rialController,
                      label: 'ریال:',
                      onChanged: (val) => updateLabel(val, 'rial'),
                    ),
                    Text(rialLabel, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: convertToToman,
                      child: const Text('تبدیل به تومان'),
                    ),
                    const SizedBox(height: 24),
                    buildTextField(
                      controller: tomanController,
                      label: 'تومان:',
                      onChanged: (val) => updateLabel(val, 'toman'),
                    ),
                    Text(tomanLabel, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: convertToRial,
                      child: const Text('تبدیل به ریال'),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      outputText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: IconButton(
                icon: Image.asset(
                  'assets/image/github.png',
                  width: 48,
                  height: 48,
                ),
                onPressed: openGithub,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required void Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}

const Map<int, String> numToText = {
  0: 'صفر',
  1: 'یک',
  2: 'دو',
  3: 'سه',
  4: 'چهار',
  5: 'پنج',
  6: 'شش',
  7: 'هفت',
  8: 'هشت',
  9: 'نه',
  10: 'ده',
  11: 'یازده',
  12: 'دوازده',
  13: 'سیزده',
  14: 'چهارده',
  15: 'پانزده',
  16: 'شانزده',
  17: 'هفده',
  18: 'هجده',
  19: 'نوزده',
  20: 'بیست',
  30: 'سی',
  40: 'چهل',
  50: 'پنجاه',
  60: 'شصت',
  70: 'هفتاد',
  80: 'هشتاد',
  90: 'نود',
  100: 'صد',
  200: 'دویست',
  300: 'سیصد',
  400: 'چهارصد',
  500: 'پانصد',
  600: 'ششصد',
  700: 'هفتصد',
  800: 'هشتصد',
  900: 'نهصد',
  1000: 'هزار',
  1000000: 'میلیون',
  1000000000: 'میلیارد',
};

String convertNumberToText(int number) {
  if (number == 0) return numToText[0]!;
  if (number < 21) return numToText[number]!;
  if (number < 100) {
    final tens = number ~/ 10 * 10;
    final units = number % 10;
    return units == 0
        ? numToText[tens]!
        : '${numToText[tens]} و ${numToText[units]}';
  }
  if (number < 1000) {
    final hundreds = number ~/ 100 * 100;
    final remainder = number % 100;
    return remainder == 0
        ? numToText[hundreds]!
        : '${numToText[hundreds]} و ${convertNumberToText(remainder)}';
  }
  if (number < 1000000) {
    final thousands = number ~/ 1000;
    final remainder = number % 1000;
    return remainder == 0
        ? '${convertNumberToText(thousands)} هزار'
        : '${convertNumberToText(thousands)} هزار و ${convertNumberToText(remainder)}';
  }
  if (number < 1000000000) {
    final millions = number ~/ 1000000;
    final remainder = number % 1000000;
    return remainder == 0
        ? '${convertNumberToText(millions)} میلیون'
        : '${convertNumberToText(millions)} میلیون و ${convertNumberToText(remainder)}';
  }
  final billions = number ~/ 1000000000;
  final remainder = number % 1000000000;
  return remainder == 0
      ? '${convertNumberToText(billions)} میلیارد'
      : '${convertNumberToText(billions)} میلیارد و ${convertNumberToText(remainder)}';
}
