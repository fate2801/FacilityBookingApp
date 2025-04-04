# NP Facility Booking App

This Flutter app is a **Campus Facility Booking and Enquiry System** designed to provide Ngee Ann Polytechnic students with a seamless interface to view available campus facilities, make bookings, and submit enquiries or feedback. The application is student-centric, cleanly designed, and tailored for mobile use.

---

## ✨ Features

### 🏠 Home Screen
- Displays **current date and time** based on the Singapore timezone.
- Shows an **interactive campus map** with tappable markers for various facilities.
- Offers **quick action buttons** to:
  - Book Facilities
  - View Bookings
  - Make Enquiries

### 🗺️ Interactive Map
- Map loaded from `assets/np_map.png`.
- Facility locations marked using a grid system (`A.1` to `J.5`).
- Tapping on a marker opens a **Facility Overview** page.

### 🏫 Facility Overview
- Displays a detailed screen of the selected facility.
- Future-ready for including facility descriptions, images, or available booking slots.

### 🏷️ Facility Groups (Booking Categories)
- Allows users to navigate booking options by grouped facility types.

### 📅 Booking Screen
- Users can view **available facility groups** and navigate to book specific ones.

### 📋 Booking List
- Placeholder screen for displaying booking history.

### 📩 Enquiry System
-  **Enquiry Form** where users can:
  - Enter full name, email, and message.
  - Select an enquiry category (e.g., General, Booking Related, Technical Issue).
- Submissions trigger a **confirmation popup** displaying enquiry details.
- Form resets upon successful submission.

---

## 🛠️ Tech Stack

- **Flutter**: UI development
- **Dart**: Programming language
- **timezone** package: For accurate Singapore timezone support
- **Material Design**: UI styling
- **Responsive Design**: Optimized for various screen sizes
- **Image Slideshows**: allows image slideshows
- **marquee**: scrolling text

---
