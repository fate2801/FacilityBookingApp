import 'package:flutter/material.dart';

import 'booking_service.dart';

class BookingListScreen extends StatelessWidget {
  final String studentId = 'S10243262G';

  @override
  Widget build(BuildContext context) {
    final List<Booking> reservations = BookingService().getBookings();
    final double totalCost =
        reservations.fold(0, (sum, booking) => sum + booking.cost);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'My Reservations | $studentId',
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
            _buildHeader(reservations.length, totalCost),
            const SizedBox(height: 16),
            Expanded(
              child: _buildBookingsList(reservations),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int bookingCount, double totalCost) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.event_note, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Total Reservations: $bookingCount',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.attach_money, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Total Cost: \$${totalCost.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> reservations) {
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Active Reservations',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: reservations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildBookingCard(reservations[index]),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getFacilityIcon(booking.facilityName),
                    color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    booking.facilityName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.calendar_today, 'Date', booking.date),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.access_time, 'Time', booking.time),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.timer, 'Duration', booking.duration),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.attach_money, 'Cost',
                '\$${booking.cost.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
}
