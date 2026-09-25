import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoItem {
  final String id;
  final String title;
  final String channel;
  final String views;
  final String thumbnailUrl;

  YouTubeVideoItem({
    required this.id,
    required this.title,
    required this.channel,
    required this.views,
    required this.thumbnailUrl,
  });
}

class YouTubePlaylistScreen extends StatefulWidget {
  final int initialIndex;

  const YouTubePlaylistScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<YouTubePlaylistScreen> createState() => _YouTubePlaylistScreenState();
}

class _YouTubePlaylistScreenState extends State<YouTubePlaylistScreen> {
  late YoutubePlayerController _controller;
  late int _currentIndex;
  bool _isLiked = false;
  int _likesCount = 1240;

  final List<YouTubeVideoItem> _playlist = [
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
    YouTubeVideoItem(
      id: 'dFPri23M16A',
      title: 'Building Scalable Mobile & Web Apps in 2026',
      channel: 'TechStream',
      views: '340K views • 2 weeks ago',
      thumbnailUrl: 'https://img.youtube.com/vi/dFPri23M16A/hqdefault.jpg',
    ),
    YouTubeVideoItem(
      id: '1ukSR1GRtMU',
      title: 'Jetpack Compose & Flutter Modern Design System',
      channel: 'UiDesignPro',
      views: '95K views • 3 weeks ago',
      thumbnailUrl: 'https://img.youtube.com/vi/1ukSR1GRtMU/hqdefault.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = YoutubePlayerController(
      initialVideoId: _playlist[_currentIndex].id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  void _playVideoAtIndex(int index) {
    setState(() {
      _currentIndex = index;
      _isLiked = false;
    });
    _controller.load(_playlist[index].id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentVideo = _playlist[_currentIndex];

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: const Color(0xFF8A2BE2),
        progressColors: const ProgressBarColors(
          playedColor: Color(0xFF8A2BE2),
          handleColor: Color(0xFF9E47FF),
        ),
      ),
      builder: (context, player) {
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
              'Playlist Stream',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. YouTube Video Player
                player,

                // 2. Currently Playing Info & Playlist List Below
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          currentVideo.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          '${currentVideo.views} • ${currentVideo.channel}',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),

                        const Gap(14),

                        // Actions Row (Like & Share)
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isLiked = !_isLiked;
                                  if (_isLiked) {
                                    _likesCount++;
                                  } else {
                                    _likesCount--;
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1C1C26),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _isLiked ? Icons.thumb_up_rounded : Icons.thumb_up_alt_outlined,
                                      color: _isLiked ? const Color(0xFF8A2BE2) : Colors.white,
                                      size: 18,
                                    ),
                                    const Gap(6),
                                    Text(
                                      '$_likesCount',
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C1C26),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.share_outlined, color: Colors.white, size: 18),
                                  const Gap(6),
                                  Text(
                                    'Share',
                                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Gap(16),
                        const Divider(color: Colors.white12),
                        const Gap(10),

                        Text(
                          'Next in Playlist',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Gap(12),

                        // 3. Playlist Videos List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _playlist.length,
                          itemBuilder: (context, index) {
                            final video = _playlist[index];
                            final isPlaying = index == _currentIndex;

                            return GestureDetector(
                              onTap: () => _playVideoAtIndex(index),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isPlaying
                                      ? const Color(0xFF8A2BE2).withValues(alpha: 0.15)
                                      : const Color(0xFF1C1C26),
                                  borderRadius: BorderRadius.circular(12),
                                  border: isPlaying
                                      ? Border.all(color: const Color(0xFF8A2BE2), width: 1.5)
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    // Thumbnail
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.network(
                                            video.thumbnailUrl,
                                            width: 110,
                                            height: 68,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 110,
                                                height: 68,
                                                color: const Color(0xFF232330),
                                                child: const Icon(Icons.video_library, color: Colors.white54),
                                              );
                                            },
                                          ),
                                          if (isPlaying)
                                            Container(
                                              width: 110,
                                              height: 68,
                                              color: Colors.black45,
                                              child: const Icon(Icons.equalizer_rounded, color: Color(0xFF9E47FF)),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const Gap(12),
                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            video.title,
                                            style: GoogleFonts.poppins(
                                              color: isPlaying ? const Color(0xFF9E47FF) : Colors.white,
                                              fontSize: 13,
                                              fontWeight: isPlaying ? FontWeight.bold : FontWeight.w600,
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
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
