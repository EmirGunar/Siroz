import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ana_sayfa.dart';

class TestEkrani extends StatefulWidget {
  const TestEkrani({Key? key}) : super(key: key);

  @override
  State<TestEkrani> createState() => _TestEkraniState();
}

class _TestEkraniState extends State<TestEkrani> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, Map<String, dynamic>> _testDegerleri = {
    "Bilirubin": {
      "controller": TextEditingController(),
      "referans": "0.1-1.2 mg/dL",
      "icon": Icons.water_drop,
      "color": Color(0xFF2196F3),
    },
    "Kolesterol": {
      "controller": TextEditingController(),
      "referans": "125-200 mg/dL",
      "icon": Icons.bloodtype,
      "color": Color(0xFFE91E63),
    },
    "Albümin": {
      "controller": TextEditingController(),
      "referans": "3.5-5.0 g/dL",
      "icon": Icons.science,
      "color": Color(0xFF4CAF50),
    },
    "Bakır": {
      "controller": TextEditingController(),
      "referans": "70-140 µg/dL",
      "icon": Icons.science,
      "color": Color(0xFFFFC107),
    },
    "Alkalen Fosfataz": {
      "controller": TextEditingController(),
      "referans": "44-147 U/L",
      "icon": Icons.biotech,
      "color": Color(0xFF9C27B0),
    },
    "SGOT": {
      "controller": TextEditingController(),
      "referans": "5-40 U/L",
      "icon": Icons.analytics,
      "color": Color(0xFFF44336),
    },
    "Triglesirid": {
      "controller": TextEditingController(),
      "referans": "50-150 mg/dL",
      "icon": Icons.water,
      "color": Color(0xFF00BCD4),
    },
    "Trombositler": {
      "controller": TextEditingController(),
      "referans": "150,000-450,000 /µL",
      "icon": Icons.cell_tower,
      "color": Color(0xFF795548),
    },
    "Protrombin": {
      "controller": TextEditingController(),
      "referans": "11-13.5 saniye",
      "icon": Icons.timer,
      "color": Color(0xFF607D8B),
    },
  };

  bool _loading = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    for (var value in _testDegerleri.values) {
      value["controller"].dispose();
    }
    super.dispose();
  }

  void _otomatikDoldur() {
    setState(() {
      _testDegerleri["Bilirubin"]!["controller"].text = "3.2";
      _testDegerleri["Kolesterol"]!["controller"].text = "220";
      _testDegerleri["Albümin"]!["controller"].text = "2.9";
      _testDegerleri["Bakır"]!["controller"].text = "110";
      _testDegerleri["Alkalen Fosfataz"]!["controller"].text = "260";
      _testDegerleri["SGOT"]!["controller"].text = "150";
      _testDegerleri["Triglesirid"]!["controller"].text = "180";
      _testDegerleri["Trombositler"]!["controller"].text = "100";
      _testDegerleri["Protrombin"]!["controller"].text = "17";
    });
  }

  Future<void> _testiKaydet() async {
    if (!_formKey.currentState!.validate()) return;

    final inputData = _testDegerleri.map((key, value) => 
      MapEntry(key, value["controller"].text));
    final userEmail = FirebaseAuth.instance.currentUser!.email;

    setState(() => _loading = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('tests')
          .add({
        'date': Timestamp.now(),
        'inputData': inputData,
        'result': 'Test sonucu bekleniyor...',
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text("Test Başarılı"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Testiniz başarıyla kaydedildi.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "'Testlerim' sayfasından görebilirsiniz.",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AnaSayfa()),
                  );
                },
                child: Text(
                  "Tamam",
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Bir hata oluştu: $e'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Siroz Testi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D32),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Siroz Risk Analizi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lütfen aşağıdaki değerleri giriniz',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    ..._testDegerleri.entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: e.value["color"].withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      e.value["icon"],
                                      color: e.value["color"],
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.key,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          e.value["referans"],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: e.value["controller"],
                                decoration: InputDecoration(
                                  hintText: 'Değer giriniz',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen ${e.key} değerini girin';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Geçerli bir sayı girin';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _otomatikDoldur,
                      icon: const Icon(Icons.auto_fix_high),
                      label: const Text('Otomatik Doldur (Geliştirici)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF57C00),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _testiKaydet,
                        icon: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.health_and_safety),
                        label: Text(_loading ? 'Kaydediliyor...' : 'Testi Kaydet'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
