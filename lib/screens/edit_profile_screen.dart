import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/profile_image_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  File? _imageFile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? '';
  }

  // Request camera permission
  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (!result.isGranted) {
        if (result.isPermanentlyDenied) openAppSettings();
        return false;
      }
    }
    return true;
  }

  // Request gallery permission
  Future<bool> _requestGalleryPermission() async {
    final status = await Permission.photos.status; // for Android 13+
    if (!status.isGranted) {
      final result = await Permission.photos.request();
      if (!result.isGranted) {
        if (result.isPermanentlyDenied) openAppSettings();
        return false;
      }
    }
    return true;
  }

  // Pick image from camera
  Future<void> _pickCameraImage() async {
    if (!await _requestCameraPermission()) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  // Pick image from gallery
  Future<void> _pickGalleryImage() async {
    if (!await _requestGalleryPermission()) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  // Save profile updates
  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser;

    try {
      await user!.updateDisplayName(_nameController.text.trim());
      await user.reload();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating username: $e')),
      );
    }

    if (_imageFile != null) {
      context.read<ProfileImageProvider>().setImage(_imageFile!);
    }

    if (mounted) Navigator.pop(context);
    setState(() => _loading = false);
  }

  // Show dialog with camera & gallery options
  void _showImageOptions() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Center(child: Text('Select Image')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  _pickCameraImage();
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  _pickGalleryImage();
                },
                icon: const Icon(Icons.photo),
                label: const Text('Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileImageProvider>();
    final avatarImage = _imageFile ??
        (provider.photoUrl != null ? File(provider.photoUrl!) : null);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImageOptions,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: avatarImage != null ? FileImage(avatarImage) : null,
                    child: avatarImage == null ? const Icon(Icons.person, size: 50) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.purple,
                      child: const Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _saveProfile,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
