import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'booking_service.dart';

class BookingScreen extends StatefulWidget {
  final String facilityName;

  BookingScreen({required this.facilityName});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late tz.TZDateTime _bookingDate;
  TimeOfDay _bookingTime = TimeOfDay(hour: 8, minute: 0);
  String _bookingDuration = '1 hour';
  bool _hasAcceptedTerms = false;
  final List<String> _durationOptions = [
    '1 hour',
    '2 hours',
    '3 hours',
    '4 hours'
  ];

  Map<String, double> facilityRates = {
    'Lower Hall (Convention centre level 1)': 500.0,
    'Upper Hall (Convention centre level 2)': 400.0,
    'VIP Room': 100.0,
    'Music Box': 300.0,
    'LT76 - 79': 150.0,
    'LT73A - C': 150.0,
    'LT51A': 120.0,
    'Cluster Layout 050501': 80.0,
    'Cluster Layout 050502': 80.0,
    'Tiered Seating 080301': 100.0,
    'Blk 56 Smart Classroom': 100.0,
    'Main Field': 200.0,
    'Swimming Pool': 1000.0,
    'AGILE': 80.0,
    'SPARK!': 50.0,
  };

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _bookingDate = _calculateNextValidTime(
        tz.TZDateTime.now(tz.getLocation('Asia/Singapore')));
    _bookingTime = TimeOfDay.fromDateTime(_bookingDate);
  }

  double _calculateCost() {
    double baseRate = facilityRates[widget.facilityName] ?? 0.0;
    int hours = int.parse(_bookingDuration.split(' ')[0]);
    return baseRate * hours;
  }

  tz.TZDateTime _calculateNextValidTime(tz.TZDateTime current) {
    final sgZone = tz.getLocation('Asia/Singapore');

    if (current.weekday > 5) {
      current = current.add(Duration(days: 8 - current.weekday));
    }

    if (current.hour < 8) {
      return tz.TZDateTime(sgZone, current.year, current.month, current.day, 8);
    }

    if (current.hour >= 18) {
      final tomorrow = current.add(Duration(days: 1));
      return tz.TZDateTime(
          sgZone, tomorrow.year, tomorrow.month, tomorrow.day, 8);
    }

    return tz.TZDateTime(
        sgZone, current.year, current.month, current.day, current.hour + 1);
  }

  void _processBooking() {
    double totalCost = _calculateCost();
    BookingService().addBooking(Booking(
      facilityName: widget.facilityName,
      date: _bookingDate.toString().split(' ')[0],
      time: _bookingTime.format(context),
      duration: _bookingDuration,
      cost: totalCost,
    ));
  }

  Future<void> _openDatePicker(BuildContext context) async {
    final now = _calculateNextValidTime(
        tz.TZDateTime.now(tz.getLocation('Asia/Singapore')));
    final maxDate = tz.TZDateTime(tz.getLocation('Asia/Singapore'), 2101);

    while (_bookingDate.weekday >= 6) {
      _bookingDate = _bookingDate.add(Duration(days: 1));
    }

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _bookingDate,
      firstDate: now,
      lastDate: maxDate,
      selectableDayPredicate: (DateTime date) => date.weekday < 6,
    );

    if (selected != null && selected != _bookingDate.toLocal()) {
      setState(() {
        _bookingDate =
            tz.TZDateTime.from(selected, tz.getLocation('Asia/Singapore'));
        _bookingTime = TimeOfDay.fromDateTime(_bookingDate);
      });
    }
  }

  void _showTimeSelector(BuildContext context) {
    final currentTime = tz.TZDateTime.now(tz.getLocation('Asia/Singapore'));
    final isCurrentDay = _bookingDate.year == currentTime.year &&
        _bookingDate.month == currentTime.month &&
        _bookingDate.day == currentTime.day;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Booking Time'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 11,
            itemBuilder: (context, index) {
              final timeSlot = TimeOfDay(hour: 8 + index, minute: 0);
              final isTimeAvailable = !isCurrentDay ||
                  timeSlot.hour > currentTime.hour ||
                  (timeSlot.hour == currentTime.hour &&
                      currentTime.minute == 0);

              return ListTile(
                title: Text(timeSlot.format(context)),
                enabled: isTimeAvailable,
                onTap: isTimeAvailable
                    ? () {
                        setState(() => _bookingTime = timeSlot);
                        Navigator.pop(context);
                      }
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Reserve ${widget.facilityName}',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBookingDetails(),
            const SizedBox(height: 20),
            _buildDateSelection(),
            const SizedBox(height: 20),
            _buildTimeSelection(),
            const SizedBox(height: 20),
            _buildDurationSelection(),
            const SizedBox(height: 20),
            _buildCostPreview(),
            const SizedBox(height: 20),
            _buildTermsAgreement(),
            const SizedBox(height: 24),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetails() {
    return _buildCard(
      title: 'Selected Facility',
      child: Text(
        widget.facilityName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    return _buildCard(
      title: 'Select Date',
      child: InkWell(
        onTap: () => _openDatePicker(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_bookingDate.toLocal()}'.split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelection() {
    return _buildCard(
      title: 'Select Time',
      child: InkWell(
        onTap: () => _showTimeSelector(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _bookingTime.format(context),
                style: const TextStyle(fontSize: 16),
              ),
              const Icon(Icons.access_time),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSelection() {
    return _buildCard(
      title: 'Duration',
      child: Column(
        children: _durationOptions
            .map((duration) => RadioListTile<String>(
                  title: Text(duration),
                  value: duration,
                  groupValue: _bookingDuration,
                  onChanged: (value) =>
                      setState(() => _bookingDuration = value!),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCostPreview() {
    return _buildCard(
      title: 'Cost Preview',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Cost:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            '\$${_calculateCost().toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildTermsAgreement() {
    return CheckboxListTile(
      value: _hasAcceptedTerms,
      onChanged: (value) => setState(() => _hasAcceptedTerms = value!),
      title: const Text('I agree to the terms and conditions'),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: !_hasAcceptedTerms
          ? null
          : () {
              _processBooking();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking Confirmed!')),
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Confirm Booking',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
