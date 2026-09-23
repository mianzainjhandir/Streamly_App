import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Help & Support',
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
              // Header Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8A2BE2), Color(0xFF4A00E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8A2BE2).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.live_tv_rounded, color: Colors.white, size: 28),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            'Streamly Platform',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Text(
                      'Video Streaming Platform Advanced',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'A Video Streaming Platform is an advanced full-stack project that teaches you how to build applications similar to popular video-sharing services. You\'ll work with file uploads, cloud storage, video streaming, authentication, and content management.',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(24),

              // Overview Section
              Text(
                'About This Application',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF0F172A),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Text(
                  'This project demonstrates your ability to handle large media files and build scalable web applications.',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF475569),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),

              const Gap(24),

              // Project Goals Header
              Row(
                children: [
                  const Icon(Icons.track_changes_rounded, color: Color(0xFF8A2BE2), size: 24),
                  const Gap(8),
                  Text(
                    '🎯 Project Goals & Features',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF0F172A),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(6),
              Text(
                'Build a video streaming platform where users can:',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),

              const Gap(12),

              // Features Tiles
              _buildFeatureTile(
                emoji: '👤',
                title: 'Register and log in',
                description: 'Create an account and securely log in using email & password.',
              ),
              _buildFeatureTile(
                emoji: '📤',
                title: 'Upload videos',
                description: 'Upload your video content to cloud storage seamlessly.',
              ),
              _buildFeatureTile(
                emoji: '▶️',
                title: 'Watch videos',
                description: 'Stream high quality video content on demand.',
              ),
              _buildFeatureTile(
                emoji: '❤️',
                title: 'Like videos',
                description: 'Express appreciation for your favorite video creators.',
              ),
              _buildFeatureTile(
                emoji: '💬',
                title: 'Comment on videos',
                description: 'Engage in discussions and post comments on videos.',
              ),
              _buildFeatureTile(
                emoji: '🔍',
                title: 'Search videos',
                description: 'Find videos, channels, and topics instantly using search.',
              ),
              _buildFeatureTile(
                emoji: '📂',
                title: 'Browse by category',
                description: 'Explore content organized by Gaming, Music, Tech, Movies, etc.',
              ),
              _buildFeatureTile(
                emoji: '👥',
                title: 'Subscribe to creators',
                description: 'Follow your favorite creators and get latest video updates.',
              ),
              _buildFeatureTile(
                emoji: '📱',
                title: 'Watch videos on mobile devices',
                description: 'Enjoy a fast, smooth mobile streaming experience on any device.',
              ),

              const Gap(24),

              // Support Contact Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 24),
                    ),
                    const Gap(14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Still Need Help?',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF1E3A8A),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Contact our support team at support@streamly.com',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2563EB),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required String emoji,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 22),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0F172A),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(2),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
