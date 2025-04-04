import 'package:flutter/material.dart';

class EnquiryScreen extends StatefulWidget {
  final String studentId = 'S10243262G';

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameField = TextEditingController();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _enquiryField = TextEditingController();

  static const List<String> _enquiryCategories = [
    'General Enquiry',
    'Booking Related',
    'Technical Issue',
    'Feedback',
  ];

  String? _selectedCategory;

  void _processEnquirySubmission() {
    if (!_formKey.currentState!.validate()) return;

    _showConfirmationPopup(
      _fullNameField.text,
      _emailField.text,
      _selectedCategory ?? 'Not Specified',
      _enquiryField.text,
    );
  }

  void _showConfirmationPopup(
      String name, String email, String category, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Enquiry Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Your enquiry has been received.',
                  style: TextStyle(fontSize: 16),
                ),
                const Divider(height: 20),
                _buildConfirmationDetail('Name', name),
                _buildConfirmationDetail('Email', email),
                _buildConfirmationDetail('Category', category),
                _buildConfirmationDetail('Message', message),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _resetForm();
              Navigator.pop(ctx);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  void _resetForm() {
    _fullNameField.clear();
    _emailField.clear();
    _enquiryField.clear();
    setState(() => _selectedCategory = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Contact Support - ${widget.studentId}',
          style: const TextStyle(color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(
                controller: _fullNameField,
                label: 'Full Name',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _emailField,
                label: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 20),
              _buildCategoryDropdown(),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _enquiryField,
                label: 'Enquiry Details',
                maxLines: 6,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Message is required' : null,
              ),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
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
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
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
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        items: _enquiryCategories
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
            .toList(),
        onChanged: (value) => setState(() => _selectedCategory = value),
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _processEnquirySubmission,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Added this line to make text white
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final bool isValid =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    return isValid ? null : 'Please enter a valid email';
  }

  @override
  void dispose() {
    _fullNameField.dispose();
    _emailField.dispose();
    _enquiryField.dispose();
    super.dispose();
  }
}
