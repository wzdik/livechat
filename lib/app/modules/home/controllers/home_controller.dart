import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Counter existing
  final count = 0.obs;

  // Chat-specific properties
  final TextEditingController chatController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Stream untuk mengambil data chat dari Firestore
  Stream<QuerySnapshot> get chatStream =>
      firestore.collection('chats').orderBy('timestamp', descending: false).snapshots();

  // Fungsi untuk mengirim pesan
  void sendMessage(String message) async {
    if (message.trim().isNotEmpty) {
      // Simpan pesan pengguna
      await firestore.collection('chats').add({
        'sender': 'user',
        'message': message.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Simulasikan balasan bot
      String botReply = _getBotResponse(message);
      await firestore.collection('chats').add({
        'sender': 'bot',
        'message': botReply,
        'timestamp': FieldValue.serverTimestamp(),
      });

      chatController.clear(); // Kosongkan input pengguna
    }
  }

  // Logika untuk balasan bot dengan respons acak
  String _getBotResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();
    Map<String, List<String>> responses = {
      'halo': [
        'Halo! Ada yang bisa saya bantu? 😊',
        'Hi! Bagaimana kabar Anda hari ini?',
        'Halo, selamat datang di Kedelai Hub!',
      ],
      'produk': [
        'Kami memiliki berbagai produk berbasis kedelai. Ada yang spesifik Anda cari?',
        'Produk kami meliputi tempe, tahu, susu kedelai, dan masih banyak lagi.',
        'Tertarik dengan promosi terbaru kami untuk produk kedelai? 😊',
      ],
      'default': [
        'Maaf, saya tidak mengerti. Bisakah Anda ulangi dengan pertanyaan yang lebih spesifik?',
        'Hmm, saya kurang paham. Mungkin Anda bisa bertanya tentang produk atau layanan kami.',
        'Pertanyaan yang menarik! Namun, saya perlu sedikit informasi lebih detail. 😊',
      ],
    };

    // Tentukan respon berdasarkan kata kunci
    if (userMessage.contains('halo')) {
      return _getRandomResponse(responses['halo']!);
    } else if (userMessage.contains('produk')) {
      return _getRandomResponse(responses['produk']!);
    } else {
      return _getRandomResponse(responses['default']!);
    }
  }

  // Fungsi untuk mengambil respons secara acak dari daftar
  String _getRandomResponse(List<String> responseList) {
    final random = Random();
    return responseList[random.nextInt(responseList.length)];
  }

  // Increment fungsi bawaan
  void increment() => count.value++;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    chatController.dispose(); // Bersihkan controller saat close
    super.onClose();
  }
}
 