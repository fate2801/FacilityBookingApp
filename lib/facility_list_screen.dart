import 'package:flutter/material.dart';

import 'booking_screen.dart';

class FacilityListScreen extends StatelessWidget {
  final String groupName;
  final List<String> facilities;
  final String studentId = 'S10243262G';

  FacilityListScreen({required this.groupName, required this.facilities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '$groupName | $studentId',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(child: _buildFacilitiesList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          const SizedBox(width: 8),
          Text(
            'Available Facilities',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesList(BuildContext context) {
    return ListView.separated(
      itemCount: facilities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final facilityInfo = _parseFacilityInfo(facilities[index]);
        return _buildFacilityCard(context, facilityInfo);
      },
    );
  }

  Map<String, String> _parseFacilityInfo(String facility) {
    final parts = facility.split(':');
    return {
      'name': parts[0].trim(),
      'details': parts.length > 1 ? parts[1].trim() : '',
    };
  }

  Widget _buildFacilityCard(
      BuildContext context, Map<String, String> facilityInfo) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToBooking(context, facilityInfo['name']!),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getFacilityIcon(facilityInfo['name']!),
                      color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      facilityInfo['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (facilityInfo['details']!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.people_outline,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          facilityInfo['details']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFacilityIcon(String facility) {
    if (facility.toLowerCase().contains('hall')) return Icons.business;
    if (facility.toLowerCase().contains('room')) return Icons.meeting_room;
    if (facility.toLowerCase().contains('lt')) return Icons.school;
    if (facility.toLowerCase().contains('classroom')) return Icons.class_;
    if (facility.toLowerCase().contains('field')) return Icons.sports_soccer;
    if (facility.toLowerCase().contains('pool')) return Icons.pool;
    return Icons.room;
  }

  void _navigateToBooking(BuildContext context, String facility) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(facilityName: facility),
      ),
    );
  }
}
