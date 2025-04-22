import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'giris_ekrani.dart';
import 'test_ekrani.dart';
import 'testlerim_ekrani.dart';
import 'profil_duzenle.dart';
import 'dart:convert';

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Siroz Asistan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF81C784),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) async {
              if (value == 'edit_profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilDuzenle()),
                );
              } else if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const GirisEkrani()),
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit_profile',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFF81C784)),
                    SizedBox(width: 8),
                    Text('Profili Düzenle'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Color(0xFF81C784)),
                    SizedBox(width: 8),
                    Text('Çıkış Yap'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.email)
            .snapshots(),
        builder: (context, userSnapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.email)
                .collection('tests')
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (context, testSnapshot) {
              final userName = userSnapshot.hasData ? userSnapshot.data?.get('name') as String? : null;
              final userGender = userSnapshot.hasData ? userSnapshot.data?.get('gender') as String? : null;
              final userPhoto = userSnapshot.hasData && userSnapshot.data!.exists ? 
                  (userSnapshot.data!.data() as Map<String, dynamic>).containsKey('photoUrl') ? 
                      userSnapshot.data?.get('photoUrl') as String? : null 
                  : null;
              
              final testCount = testSnapshot.hasData ? testSnapshot.data?.docs.length ?? 0 : 0;
              final lastTestDate = testSnapshot.hasData && testSnapshot.data!.docs.isNotEmpty
                  ? (testSnapshot.data!.docs.first.data() as Map<String, dynamic>)['date'] as Timestamp
                  : null;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFF81C784),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: userPhoto != null 
                                  ? MemoryImage(base64Decode(userPhoto)) 
                                  : null,
                              child: userPhoto == null
                                  ? Icon(
                                      userGender == 'Kadın' ? Icons.female : Icons.male,
                                      size: 60,
                                      color: const Color(0xFF81C784),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Hoş Geldin, ${userName ?? 'Kullanıcı'}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'İstatistikler',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF424242),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Toplam Test',
                                  testCount.toString(),
                                  Icons.analytics,
                                  const Color(0xFF81C784),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'Son Test',
                                  lastTestDate != null
                                      ? '${lastTestDate.toDate().day}/${lastTestDate.toDate().month}/${lastTestDate.toDate().year}'
                                      : 'Yok',
                                  Icons.calendar_today,
                                  const Color(0xFF64B5F6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Hızlı İşlemler',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF424242),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            'Yeni Siroz Testi',
                            'Hızlı ve güvenilir siroz risk analizi yapın',
                            'Hemen Test Et',
                            Icons.health_and_safety,
                            const Color(0xFF81C784),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TestEkrani()),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            'Test Geçmişi',
                            'Geçmiş test sonuçlarınızı görüntüleyin ve takip edin',
                            'Sonuçları Gör',
                            Icons.history,
                            const Color(0xFF64B5F6),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TestlerimEkrani()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String description,
    String buttonText,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 24,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        buttonText,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: color,
                        size: 16,
                      ),
                    ],
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
