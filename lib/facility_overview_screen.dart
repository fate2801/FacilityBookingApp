import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:marquee/marquee.dart';

import 'facility_groups_screen.dart';

class FacilityOverviewScreen extends StatelessWidget {
  final String facilityName;
  final String studentId = 'S10243262G';

  FacilityOverviewScreen({required this.facilityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildCustomHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageSection(),
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomHeader() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Container(
        height: 40,
        child: Marquee(
          text: '$facilityName | ID: $studentId',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          scrollAxis: Axis.horizontal,
          blankSpace: 60.0,
          velocity: 40.0,
          pauseAfterRound: Duration(seconds: 1),
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 24),
          _buildDescriptionCard('About', _getDescription()),
          const SizedBox(height: 16),
          _buildDescriptionCard('Details', _getSpecifications()),
          const SizedBox(height: 16),
          _buildDescriptionCard('Pricing', _getFacilityCost()),
          const SizedBox(height: 24),
          _buildBookingButton(context),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.blue.shade200, width: 2),
        ),
      ),
      child: Text(
        facilityName,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(String title, String content) {
    IconData getIcon() {
      switch (title) {
        case 'About':
          return Icons.info_outline;
        case 'Details':
          return Icons.architecture;
        case 'Pricing':
          return Icons.attach_money;
        default:
          return Icons.info_outline;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(getIcon(), color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.calendar_today),
        label: const Text(
          'Book Now',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FacilityGroupsScreen()),
        ),
      ),
    );
  }

  String _getFacilityCost() {
    Map<String, String> costs = {
      'Auditorium':
          '• Lower Hall: \$500/hour\n• Upper Hall: \$400/hour\n• VIP Room: \$100/hour',
      'Music Box': '• Main Hall: \$300/hour\n• VIP Room: \$80/hour',
      'LT76-79': '• \$150/hour',
      'LT73A-C': '• \$150/hour',
      'LT51A': '• \$120/hour',
      'Classrooms with Cluster Layout (050501, 050502)': '• \$80/hour per room',
      'Tiered Seating Classroom (080301)': '• \$100/hour',
      'Blk 56 Smart Classroom': '• \$100/hour',
      'Main Field': '• \$200/hour',
      'Swimming Pool': '• \$1000/hour',
      'The Sandbox - AGILE': '• \$80/hour',
      'The Sandbox - SPARK!': '• \$50/hour',
    };

    return costs[facilityName] ?? 'Cost information available upon request.';
  }

  String _getDescription() {
    Map<String, String> descriptions = {
      'Auditorium':
          'Modern multipurpose venue suitable for large events and performances.',
      'Music Box': 'Specialized performance space for concerts and ceremonies.',
      'LT76-79':
          'Contemporary lecture venue with modern presentation facilities.',
      'LT73A-C': 'Collaborative learning space with innovative design.',
      'LT51A':
          'Traditional lecture theater optimized for academic presentations.',
      'Classrooms with Cluster Layout (050501, 050502)':
          'Interactive learning environment with flexible seating.',
      'Tiered Seating Classroom (080301)':
          'Enhanced visibility classroom with stepped design.',
      'Blk 56 Smart Classroom': 'Technology-enabled learning space.',
      'Main Field': 'Versatile outdoor space for sports and events.',
      'Swimming Pool': 'Competition-standard aquatic facility.',
      'The Sandbox - AGILE':
          'Innovation hub for student-industry collaboration.',
      'The Sandbox - SPARK!': 'Student entrepreneurship development center.',
    };

    return descriptions[facilityName] ??
        'Facility information available on request.';
  }

  String _getSpecifications() {
    Map<String, String> specifications = {
      'Auditorium':
          '• Location: Block 68\n• Main Hall: 1000 capacity\n• Upper Area: 800 capacity',
      'Music Box':
          '• Location: Block 73\n• Capacity: 390\n• Stage Area Available',
      'LT76-79': '• Location: Block 76\n• Seats: 150\n• AV Equipment Included',
      'LT73A-C': '• Location: Block 73\n• Capacity: 138\n• Modern Facilities',
      'LT51A': '• Location: Block 51\n• Seats: 120\n• Standard Setup',
      'Classrooms with Cluster Layout (050501, 050502)':
          '• Location: Block 5\n• Capacity: 50\n• Modular Layout',
      'Tiered Seating Classroom (080301)':
          '• Location: Block 8\n• Capacity: 80\n• Elevated Design',
      'Blk 56 Smart Classroom':
          '• Location: Block 56\n• Capacity: 50\n• Smart Features',
      'Main Field':
          '• Location: Central Area\n• Large Open Space\n• Multiple Uses',
      'Swimming Pool': '• Olympic Size\n• 8 Lanes\n• Training Facility',
      'The Sandbox - AGILE':
          '• Location: Block 58\n• Collaborative Space\n• Meeting Areas',
      'The Sandbox - SPARK!':
          '• Location: Block 56\n• Startup Space\n• Workshop Area',
    };

    return specifications[facilityName] ??
        'Specifications available on request.';
  }

  Widget _buildImageSection() {
    Map<String, List<Map<String, String>>> facilityGallery = {
      'Auditorium': [
        {'image': 'assets/auditorium_1.png', 'caption': 'Main Stage'},
        {'image': 'assets/auditorium_2.png', 'caption': 'Seating Areas'},
        {'image': 'assets/auditorium_3.png', 'caption': 'Private Room'},
      ],
      'Music Box': [
        {'image': 'assets/music_box_1.png', 'caption': 'Performance Area'},
        {'image': 'assets/music_box_2.png', 'caption': 'Seating Layout'},
      ],
      'LT51A': [
        {'image': 'assets/lt51a_1.png', 'caption': 'Lecture Area'},
        {'image': 'assets/lt51a_2.png', 'caption': 'Student Seating'},
      ],
      'LT76-79': [
        {'image': 'assets/lt76-79_1.png', 'caption': 'Teaching Space'},
        {'image': 'assets/lt76-79_2.png', 'caption': 'Student Area'},
      ],
    };

    if (facilityGallery.containsKey(facilityName)) {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ImageSlideshow(
          width: double.infinity,
          height: 300,
          initialPage: 0,
          indicatorColor: Colors.blue,
          indicatorBackgroundColor: Colors.grey.withOpacity(0.3),
          indicatorRadius: 4,
          autoPlayInterval: 4000,
          isLoop: true,
          children: facilityGallery[facilityName]!.map((imageData) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imageData['image']!,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Text(
                      imageData['caption']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      );
    }

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          'assets/${facilityName.toLowerCase().replaceAll(' ', '_')}.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
