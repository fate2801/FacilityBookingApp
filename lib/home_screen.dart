import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'booking_list_screen.dart';
import 'enquiry_screen.dart';
import 'facility_groups_screen.dart';
import 'facility_overview_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late tz.TZDateTime _timeNow;
  late Timer _clockTimer;
  static const String _studentId = 'S10243262G';

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    _initializeTime();
    _startClock();
  }

  void _initializeTime() {
    tz.initializeTimeZones();
    _timeNow = tz.TZDateTime.now(tz.getLocation('Asia/Singapore'));
  }

  void _startClock() {
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {
        _timeNow = tz.TZDateTime.now(tz.getLocation('Asia/Singapore'));
      }),
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'NP Facility Booking - $_studentId',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeDisplay(),
                  const SizedBox(height: 30),
                  _buildMapSection(),
                  const SizedBox(height: 30),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay() {
    // Convert to 12-hour format
    int hour12 = _timeNow.hour > 12 ? _timeNow.hour - 12 : _timeNow.hour;
    // Handle midnight (0:00)
    hour12 = hour12 == 0 ? 12 : hour12;
    // Determine AM or PM
    String period = _timeNow.hour >= 12 ? 'PM' : 'AM';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${hour12.toString()}:'
                '${_timeNow.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                period,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_timeNow.day} ${months[_timeNow.month - 1]} ${_timeNow.year}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Campus Facilities',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: InteractiveViewer(
              child: Stack(
                children: [
                  Image.asset('assets/np_map.png'),
                  ..._createMapMarkers(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _createMapMarkers() {
    final facilities = {
      'Auditorium': ['D.7', 4.6],
      'Music Box': ['D.1', 5.7],
      'LT76-79': ['B.6', 3.9],
      'LT73A-C': ['D.8', 5.4],
      'LT51A': ['D.4', 3.7],
      'Classrooms with Cluster Layout (050501, 050502)': ['G.7', 5.6],
      'Tiered Seating Classroom (080301)': ['H.3', 5.0],
      'Blk 56 Smart Classroom': ['E.8', 4.9],
      'Main Field': ['J.5', 6.2],
      'Swimming Pool': ['I.3', 5.4],
      'The Sandbox - AGILE': ['E.6', 4.0],
      'The Sandbox - SPARK!': ['F', 5.2],
    };

    return facilities.entries.map((facility) {
      return _createMarker(
        context,
        facility.key,
        facility.value[0] as String,
        facility.value[1] as double,
      );
    }).toList();
  }

  Widget _createMarker(
      BuildContext context, String name, String col, double row) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mapHeight = screenWidth * 1.2;

    final colWidth = screenWidth / 17;
    final rowHeight = mapHeight / 12;

    final colPositions = {
      'A': 0.0,
      'B': 1.0,
      'B.6': 1.6,
      'C': 2.0,
      'D': 3.0,
      'D.1': 3.1,
      'D.4': 3.4,
      'D.7': 3.7,
      'D.8': 3.8,
      'E': 4.0,
      'E.6': 4.6,
      'E.8': 4.8,
      'F': 5.0,
      'F.3': 5.3,
      'G': 6.0,
      'G.7': 6.7,
      'H': 7.0,
      'H.3': 7.3,
      'I': 8.0,
      'I.3': 8.3,
      'J': 9.0,
      'J.5': 9.5,
      'K': 10.0,
      'L': 11.0,
      'M': 12.0,
      'N': 13.0,
      'P': 14.0,
      'Q': 15.0
    };

    return Positioned(
      left: colPositions[col]! * colWidth,
      top: (row - 1) * rowHeight,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FacilityOverviewScreen(facilityName: name),
          ),
        ),
        child: const Icon(Icons.place, color: Colors.red, size: 30),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _customButton(
          'Book Facilities',
          Icons.calendar_today,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FacilityGroupsScreen()),
          ),
        ),
        const SizedBox(height: 15),
        _customButton(
          'View Bookings',
          Icons.list_alt,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingListScreen()),
          ),
        ),
        const SizedBox(height: 15),
        _customButton(
          'Make Enquiry',
          Icons.help_outline,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EnquiryScreen()),
          ),
        ),
      ],
    );
  }

  Widget _customButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
