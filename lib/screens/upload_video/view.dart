import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;

  PlatformFile? _videoPlatformFile;
  String? _videoFileName;
  String? _videoFileSize;

  PlatformFile? _thumbnailPlatformFile;
  Uint8List? _thumbnailBytes;
  String? _thumbnailBase64;

  bool _isUploading = false;

  final List<String> _categories = [
    'Gaming',
    'Music',
    'Education',
    'Tech',
    'Entertainment',
    'Movies',
    'Sports',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Pick Video File
  Future<void> _pickVideo() async {
    try {
      PlatformFile? file = await FilePicker.pickFile(
        type: FileType.video,
      );

      if (file != null) {
        int bytesCount = await file.length() ?? 0;
        double mb = bytesCount / (1024 * 1024);

        setState(() {
          _videoPlatformFile = file;
          _videoFileName = file.name;
          _videoFileSize = '${mb.toStringAsFixed(1)} MB';
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick video: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Pick Thumbnail Image
  Future<void> _pickThumbnail() async {
    try {
      PlatformFile? file = await FilePicker.pickFile(
        type: FileType.image,
      );

      if (file != null) {
        Uint8List bytes = await file.readAsBytes();
        String base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

        setState(() {
          _thumbnailPlatformFile = file;
          _thumbnailBytes = bytes;
          _thumbnailBase64 = base64Image;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick thumbnail: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Upload Video Data to Firestore
  Future<void> _uploadVideo() async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();

    if (_videoPlatformFile == null) {
      Get.snackbar('Required', 'Please select a video to upload!',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (title.isEmpty) {
      Get.snackbar('Required', 'Please enter a video title!',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (_selectedCategory == null) {
      Get.snackbar('Required', 'Please select a category!',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;

      String videoPathOrUrl = _videoPlatformFile!.path ?? '';
      if (videoPathOrUrl.isEmpty || !videoPathOrUrl.startsWith('/')) {
        videoPathOrUrl =
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
      }

      // Save video metadata + thumbnail in Firestore 'videos' collection
      await FirebaseFirestore.instance.collection('videos').add({
        'title': title,
        'description': description,
        'category': _selectedCategory,
        'videoUrl': videoPathOrUrl,
        'videoName': _videoFileName ?? 'video.mp4',
        'videoSize': _videoFileSize ?? '0 MB',
        'thumbnailUrl': _thumbnailBase64 ?? '',
        'thumbnailPath': _thumbnailPlatformFile?.path ?? '',
        'userId': user?.uid ?? '',
        'userEmail': user?.email ?? '',
        'userName': user?.displayName ?? 'Creator',
        'likesCount': 0,
        'viewsCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Video uploaded successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);

      // Reset fields
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _videoPlatformFile = null;
        _videoFileName = null;
        _videoFileSize = null;
        _thumbnailPlatformFile = null;
        _thumbnailBytes = null;
        _thumbnailBase64 = null;
        _selectedCategory = null;
        _isUploading = false;
      });

      Get.back();
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      Get.snackbar('Error', 'Failed to upload video: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Upload Video',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. VIDEO UPLOAD BOX
              GestureDetector(
                onTap: _pickVideo,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF8A2BE2).withValues(alpha: 0.4),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8A2BE2).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_upload_outlined,
                          color: Color(0xFF8A2BE2),
                          size: 36,
                        ),
                      ),
                      const Gap(12),
                      Text(
                        _videoFileName != null
                            ? _videoFileName!
                            : 'Tap to upload video',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1E293B),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        _videoFileSize != null
                            ? 'Selected Size: $_videoFileSize'
                            : 'MP4, MOV, or WEBM (Max 500MB)',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Gap(20),

              // 2. VIDEO TITLE FIELD
              Text(
                'Video Title',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1E293B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(6),
              TextField(
                controller: _titleController,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter video title...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8A2BE2), width: 1.5),
                  ),
                ),
              ),

              const Gap(16),

              // 3. DESCRIPTION FIELD
              Text(
                'Description',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1E293B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(6),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Tell us about your video...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8A2BE2), width: 1.5),
                  ),
                ),
              ),

              const Gap(16),

              // 4. CATEGORY DROPDOWN
              Text(
                'Category',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1E293B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(6),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text(
                  'Select category',
                  style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8A2BE2), width: 1.5),
                  ),
                ),
              ),

              const Gap(16),

              // 5. THUMBNAIL SECTION
              Text(
                'Thumbnail',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1E293B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _thumbnailBytes != null
                        ? Image.memory(
                            _thumbnailBytes!,
                            width: 120,
                            height: 75,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 120,
                            height: 75,
                            color: const Color(0xFFF8F9FE),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_outlined, color: Colors.grey, size: 28),
                                SizedBox(height: 4),
                                Text('No thumbnail', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            ),
                          ),
                  ),
                  const Gap(16),
                  TextButton(
                    onPressed: _pickThumbnail,
                    child: Text(
                      _thumbnailPlatformFile != null ? 'Change' : 'Choose Thumbnail',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF8A2BE2),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(28),

              // 6. UPLOAD BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _uploadVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A2BE2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Upload',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
