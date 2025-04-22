import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestEkrani extends StatefulWidget {
  const TestEkrani({Key? key}) : super(key: key);

  @override
  State<TestEkrani> createState() => _TestEkraniState();
}

class _TestEkraniState extends State<TestEkrani> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    "Bilirubin": TextEditingController(),
    "Kolesterol": TextEditingController(),
    "Albümin": TextEditingController(),
    "Bakır": TextEditingController(),
    "Alkalen Fosfataz": TextEditingController(),
    "SGOT": TextEditingController(),
    "Triglesirid": TextEditingController(),
    "Trombositler": TextEditingController(),
    "Protrombin": TextEditingController(),
  };

  bool _loading = false;

  // Otomatik doldurma
  void _otomatikDoldur() {
    setState(() {
      _controllers["Bilirubin"]!.text = "3.2";
      _controllers["Kolesterol"]!.text = "220";
      _controllers["Albümin"]!.text = "2.9";
      _controllers["Bakır"]!.text = "110";
      _controllers["Alkalen Fosfataz"]!.text = "260";
      _controllers["SGOT"]!.text = "150";
      _controllers["Triglesirid"]!.text = "180";
      _controllers["Trombositler"]!.text = "100";
      _controllers["Protrombin"]!.text = "17";
    });
  }

  // Basit test kaydetme
  Future<void> _testiKaydet() async {
    if (!_formKey.currentState!.validate()) return;

    final inputData = _controllers.map((key, value) => MapEntry(key, value.text));
    final userEmail = FirebaseAuth.instance.currentUser!.email;

    setState(() => _loading = true);

    await FirebaseFirestore.instance.collection('users').doc(userEmail).collection('tests').add({
      'date': Timestamp.now(),
      'inputData': inputData,
      'result': 'Test sonucu bekleniyor...',
    });

    setState(() => _loading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Test Başarılı"),
        content: const Text("Testiniz başarıyla kaydedildi. 'Testlerim' sayfasından görebilirsiniz."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tamam"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Siroz Testi'), backgroundColor: Colors.green[700]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ..._controllers.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: e.value,
                    decoration: InputDecoration(
                      labelText: e.key,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.green[50],
                    ),
                    validator: (value) => value!.isEmpty ? 'Zorunlu alan' : null,
                  ),
                )),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _otomatikDoldur,
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Otomatik Doldur (Geliştirici)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _loading ? null : _testiKaydet,
                  icon: const Icon(Icons.health_and_safety),
                  label: _loading ? const CircularProgressIndicator() : const Text('Test Yap'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
