import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp3/order/order_history_screen.dart';
import 'package:flutterapp3/login/auth_screen.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String city;

  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.city,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController cityController;

  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    cityController = TextEditingController(text: widget.city);

    _loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();
    super.dispose();
  }

  // ================= FIREBASE LOAD PROFILE =================
  Future<void> _loadProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;

      setState(() {
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        cityController.text = data['city'] ?? '';
      });
    }
  }

  // ================= UPLOAD IMAGE =================
  Future<String?> _uploadImage(File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images/${user.uid}.jpg');

      await ref.putFile(file);

      return await ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
      return null;
    }
  }

  // ================= PICK IMAGE =================
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      setState(() => _profileImage = file);

      final url = await _uploadImage(file);

      if (url != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'profileImage': url,
        }, SetOptions(merge: true));
      }
    }
  }

  // ================= SAVE PROFILE =================
  Future<void> _saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final city = cityController.text.trim();

    if (name.isEmpty || email.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'name': name,
      'email': email,
      'city': city,
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  // ================= LOGOUT =================
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false,
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.green,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : null,
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: cityController, decoration: const InputDecoration(labelText: "City")),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Save Profile"),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Order History"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrderHistoryScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }
}