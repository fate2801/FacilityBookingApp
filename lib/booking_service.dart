class Booking {
  final String facilityName;
  final String date;
  final String time;
  final String duration;
  final double cost;

  Booking({
    required this.facilityName,
    required this.date,
    required this.time,
    required this.duration,
    required this.cost,
  });
}

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  List<Booking> _bookings = [];

  void addBooking(Booking booking) {
    _bookings.add(booking);
  }

  List<Booking> getBookings() {
    return _bookings;
  }
}
