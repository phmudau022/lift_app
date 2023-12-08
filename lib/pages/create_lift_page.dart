import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LiftPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const LiftPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<LiftPage> createState() => _LiftPageState();
}

class _LiftPageState extends State<LiftPage> {
  final _departureController = TextEditingController();
  final _destinationController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _emailController = TextEditingController();
  final _seatsController = TextEditingController();
  String _roleValue = "passenger";
  DateTime? _selectedDate;
  bool _isLoading = false;

  Future createLift() async {
    setState(() {
      _isLoading = true;
    });

    await FirebaseFirestore.instance.collection("lifts").add({
      "departure": _departureController.text.trim(),
      "destination": _destinationController.text.trim(),
      "departureTime": _departureTimeController.text.trim(),
      "email": _emailController.text.trim(),
      "role": _roleValue,
      "date": _selectedDate?.toLocal(),
      "seats": int.parse(_seatsController.text.trim()), // Convert seats to int
    });

    // Navigate back to the home page
    Navigator.pop(context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    _departureTimeController.dispose();
    _emailController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_car,
                  size: 50,
                  color: Colors.deepPurple,
                ),
                SizedBox(height: 30),
                Text(
                  "Create a Lift",
                  style: GoogleFonts.bebasNeue(
                    fontSize: 40,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Provide lift details below",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 50),
                buildTextField("Departure", _departureController),
                SizedBox(height: 15),
                buildTextField("Destination", _destinationController),
                SizedBox(height: 15),
                buildTextField("Departure Time", _departureTimeController),
                SizedBox(height: 15),
                buildTextField("Email", _emailController),
                SizedBox(height: 15),
                buildTextField("Seats", _seatsController),
                SizedBox(height: 15),
                buildRadioButtons(),
                SizedBox(height: 15),
                buildDateSelector(context),
                SizedBox(height: 15),
                _isLoading ? CircularProgressIndicator() : buildButton("Create Lift", createLift),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRadioButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select your role",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Radio(
                value: "driver",
                groupValue: _roleValue,
                onChanged: (value) {
                  setState(() {
                    _roleValue = value!;
                  });
                },
              ),
              SizedBox(width: 15),
              Text("Driver"),
              Radio(
                value: "passenger",
                groupValue: _roleValue,
                onChanged: (value) {
                  setState(() {
                    _roleValue = value!;
                  });
                },
              ),
              SizedBox(width: 15),
              Text("Passenger"),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDateSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Date",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text("Pick a date"),
              ),
              SizedBox(width: 10),
              Text(
                _selectedDate != null
                    ? "Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}"
                    : "No date selected",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
