import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestlerimEkrani extends StatelessWidget {
  const TestlerimEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser!.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Testlerim'),
        backgroundColor: Colors.green[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .collection('tests')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 50, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "Henüz test kaydı bulunamadı.\nYeni test yapmak için ana sayfaya dönebilirsiniz.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final Timestamp timestamp = data['date'] as Timestamp;
              final DateTime date = timestamp.toDate();

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: ExpansionTile(
                  title: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        "${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    data['result'] ?? 'Sonuç bulunamadı',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "📋 Detaylı Sonuç:",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data['chatGPTResult'] ?? 'ChatGPT değerlendirmesi bulunamadı.',
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "🔍 Girilen Veriler:",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          ...(data['inputData'] as Map<String, dynamic>).entries.map(
                                (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                "• ${e.key}: ${e.value}",
                                style: const TextStyle(fontSize: 14),
                              ),
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
}
