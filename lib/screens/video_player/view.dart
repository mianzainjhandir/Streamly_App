import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  final String category;
  final String userName;
  final String videoId;
  final int likesCount;
  final int viewsCount;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.category,
    required this.userName,
    required this.videoId,
    this.likesCount = 0,
    this.viewsCount = 0,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  late int _likes;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.likesCount;
    _initializeVideo();
    _incrementViews();
  }

  Future<void> _incrementViews() async {
    try {
      if (widget.videoId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('videos')
            .doc(widget.videoId)
            .update({'viewsCount': FieldValue.increment(1)});
      }
    } catch (_) {}
  }

  Future<void> _initializeVideo() async {
    try {
      String url = widget.videoUrl.trim();
      const String sampleVideoUrl =
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

      if (url.startsWith('http://') || url.startsWith('https://')) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      } else if (url.startsWith('data:video/')) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      } else if (!kIsWeb && (url.startsWith('/') || url.startsWith('file://'))) {
        String cleanPath = url.replaceFirst('file://', '');
        File file = File(cleanPath);
        if (await file.exists()) {
          _controller = VideoPlayerController.file(file);
        } else {
          _controller = VideoPlayerController.networkUrl(Uri.parse(sampleVideoUrl));
        }
      } else {
        _controller = VideoPlayerController.networkUrl(Uri.parse(sampleVideoUrl));
      }

      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
      _controller.play();
    } catch (e) {
      try {
        const String fallbackUrl =
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
        _controller = VideoPlayerController.networkUrl(Uri.parse(fallbackUrl));
        await _controller.initialize();
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      } catch (_) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likes++;
      } else {
        _likes--;
      }
    });

    if (widget.videoId.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('videos')
          .doc(widget.videoId)
          .update({'likesCount': _likes});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D12),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Container
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxHeight: 220,
              ),
              color: Colors.black,
              child: _isInitialized
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio > 0
                                ? _controller.value.aspectRatio
                                : 16 / 9,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                        // Play/Pause Overlay & Progress Bar
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                          child: Center(
                            child: AnimatedOpacity(
                              opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                        ),
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: Color(0xFF8A2BE2),
                            bufferedColor: Colors.white24,
                            backgroundColor: Colors.white12,
                          ),
                        ),
                      ],
                    )
                  : (_hasError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: Colors.redAccent, size: 40),
                              const Gap(8),
                              Text(
                                'Unable to play video stream',
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF8A2BE2),
                          ),
                        )),
            ),

            // Video Details Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    // Views & Category
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8A2BE2).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.category.isNotEmpty
                                ? widget.category
                                : 'General',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF9E47FF),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Gap(12),
                        Text(
                          '${widget.viewsCount + 1} views',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const Gap(16),

                    // Actions Bar (Like, Share)
                    Row(
                      children: [
                        InkWell(
                          onTap: _toggleLike,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C26),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isLiked
                                      ? Icons.thumb_up_rounded
                                      : Icons.thumb_up_alt_outlined,
                                  color: _isLiked
                                      ? const Color(0xFF8A2BE2)
                                      : Colors.white,
                                  size: 18,
                                ),
                                const Gap(6),
                                Text(
                                  '$_likes',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C26),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.share_outlined,
                                  color: Colors.white, size: 18),
                              const Gap(6),
                              Text(
                                'Share',
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Gap(20),
                    const Divider(color: Colors.white12),
                    const Gap(12),

                    // Channel / Creator Info
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF8A2BE2),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName.isNotEmpty
                                    ? widget.userName
                                    : 'Creator',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Publisher',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade400,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Gap(20),

                    // Description Box
                    if (widget.description.isNotEmpty) ...[
                      Text(
                        'Description',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.description,
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade300,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
