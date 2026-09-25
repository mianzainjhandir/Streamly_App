import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamly_app/screens/notification/notification.dart';
import 'package:streamly_app/screens/video_player/view.dart';
import 'package:streamly_app/screens/youtube_playlist/view.dart';
import 'profile/view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<YouTubeVideoItem> _youtubePlaylist = [
    YouTubeVideoItem(
      id: 'gQJ97R43x9Q',
      title: 'Flutter UI Masterclass - Building Modern Streaming App',
      channel: 'Streamly Official',
      views: '125K views • 2 days ago',
      thumbnailUrl: 'https://img.youtube.com/vi/gQJ97R43x9Q/hqdefault.jpg',
    ),
    YouTubeVideoItem(
      id: 'VPvVD8t02U8',
      title: 'GetX State Management & Responsive UI Navigation',
      channel: 'CodeWithMe',
      views: '89K views • 5 days ago',
      thumbnailUrl: 'https://img.youtube.com/vi/VPvVD8t02U8/hqdefault.jpg',
    ),
    YouTubeVideoItem(
      id: 'x0uinJvhNxI',
      title: 'Firebase Authentication & Firestore Full Course',
      channel: 'DevNinja',
      views: '210K views • 1 week ago',
      thumbnailUrl: 'https://img.youtube.com/vi/x0uinJvhNxI/hqdefault.jpg',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildThumbnailWidget(String thumbnailUrl) {
    if (thumbnailUrl.isNotEmpty && thumbnailUrl.startsWith('data:image')) {
      try {
        final base64Data = thumbnailUrl.split(',').last;
        final bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        );
      } catch (_) {}
    }
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8A2BE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.play_circle_fill_rounded,
          size: 56,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8A2BE2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                      const Gap(10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Stream',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'ly',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF9E47FF),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.to(() => const NotificationPage());
                            },
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(4),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ProfileScreen());
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/images/profile.jpg',
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFF232330),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Gap(16),

              // Search Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C26),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search videos, creators, categories...',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade400,
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),

              const Gap(20),

              // Category Chips Row
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip('All'),
                    _buildCategoryChip('Gaming'),
                    _buildCategoryChip('Music'),
                    _buildCategoryChip('Tech'),
                    _buildCategoryChip('Education'),
                    _buildCategoryChip('Movies'),
                  ],
                ),
              ),

              const Gap(20),

              // YouTube Featured Playlist Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Playlist',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const YouTubePlaylistScreen());
                    },
                    child: Text(
                      'View All',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF9E47FF),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(8),

              // Featured YouTube Playlist Cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _youtubePlaylist.length,
                itemBuilder: (context, index) {
                  final video = _youtubePlaylist[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => YouTubePlaylistScreen(initialIndex: index));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C26),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  video.thumbnailUrl,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 180,
                                      color: const Color(0xFF232330),
                                      child: const Icon(Icons.play_circle_fill_rounded,
                                          size: 56, color: Colors.white54),
                                    );
                                  },
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xFF8A2BE2),
                                  child: Text(
                                    video.channel[0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.title,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Gap(4),
                                      Text(
                                        '${video.channel} • ${video.views}',
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
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Gap(16),

              Text(
                'Recent Uploads',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Gap(12),

              // StreamBuilder to fetch videos from Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('videos')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(color: Color(0xFF8A2BE2)),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading videos',
                        style: GoogleFonts.poppins(color: Colors.redAccent),
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C26),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.video_library_outlined,
                            color: Colors.grey,
                            size: 40,
                          ),
                          const Gap(8),
                          Text(
                            'No custom uploaded videos yet',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      String title = data['title'] ?? 'Untitled Video';
                      String description = data['description'] ?? '';
                      String category = data['category'] ?? 'General';
                      String videoUrl = data['videoUrl'] ?? '';
                      String thumbnailUrl = data['thumbnailUrl'] ?? '';
                      String userName = data['userName'] ?? 'Creator';
                      int likesCount = data['likesCount'] ?? 0;
                      int viewsCount = data['viewsCount'] ?? 0;

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => VideoPlayerScreen(
                                videoId: doc.id,
                                title: title,
                                description: description,
                                category: category,
                                videoUrl: videoUrl,
                                userName: userName,
                                likesCount: likesCount,
                                viewsCount: viewsCount,
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C26),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _buildThumbnailWidget(thumbnailUrl),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: Colors.black45,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: const Color(0xFF8A2BE2),
                                      child: Text(
                                        userName.isNotEmpty ? userName[0].toUpperCase() : 'C',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Gap(12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const Gap(4),
                                          Text(
                                            '$userName • $viewsCount views • $category',
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
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8A2BE2) : const Color(0xFF1C1C26),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.grey.shade400,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
