import 'package:flutter/material.dart';

import 'facility_list_screen.dart';

class FacilityGroupsScreen extends StatelessWidget {
  final String studentId = 'S10243262G';

  final Map<String, List<String>> facilityGroups = {
    'Auditoriums': [
      'Lower Hall (Convention centre level 1): 1000 pax, 850m²',
      'Upper Hall (Convention centre level 2): 800 pax, 1126m²',
      'VIP Room: 178m²',
    ],
    'Music Box': [
      'Music Box: 390 pax, 708m²',
      'VIP Room: 34m²',
    ],
    'Lecture Theatres': [
      'LT76 - 79: 150 pax',
      'LT73A - C: 138 pax',
      'LT51A: 120 pax',
    ],
    'Classrooms': [
      'Cluster Layout 050501: 50 pax',
      'Cluster Layout 050502: 50 pax',
      'Tiered Seating 080301: 80 pax',
      'Blk 56 Smart Classroom: 50 pax',
    ],
    'Sports Facilities': [
      'Main Field',
      'Swimming Pool',
    ],
    'The Sandbox': [
      'AGILE',
      'SPARK!',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Facility Categories | $studentId',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.separated(
          itemCount: facilityGroups.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            String groupName = facilityGroups.keys.elementAt(index);
            return _buildGroupCard(context, groupName);
          },
        ),
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, String groupName) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToFacilityList(context, groupName),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _getGroupIcon(groupName),
              const SizedBox(width: 16),
              Text(
                groupName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Icon _getGroupIcon(String groupName) {
    final Map<String, IconData> icons = {
      'Auditoriums': Icons.theater_comedy,
      'Music Box': Icons.music_note,
      'Lecture Theatres': Icons.school,
      'Classrooms': Icons.class_,
      'Sports Facilities': Icons.sports,
      'The Sandbox': Icons.lightbulb,
    };
    return Icon(icons[groupName] ?? Icons.room, color: Colors.blue);
  }

  void _navigateToFacilityList(BuildContext context, String groupName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FacilityListScreen(
          groupName: '$groupName ($studentId)',
          facilities: facilityGroups[groupName] ?? [],
        ),
      ),
    );
  }
}
