import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'kayit_ekrani.dart';
import 'ana_sayfa.dart';


class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Başarılı giriş olursa Ana Sayfa'ya yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AnaSayfa()),
      );
    } on FirebaseAuthException catch (e) {
      // Firebase Hatasını net göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase Hatası: ${e.message}')),
      );
    } catch (e) {
      // Diğer genel hata
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Genel Hata: ${e.toString()}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/STTS_Logo.png', height: 150),
            const SizedBox(height: 32),
            const Text('Giriş Yap', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Şifre'), obscureText: true, keyboardType: TextInputType.text),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _login, child: const Text('Giriş Yap')),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KayitEkrani())),
              child: const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
