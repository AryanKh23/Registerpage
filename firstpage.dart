import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});



  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String country, pin;
  late List countries;

  @override
  void initState() {
    getCountries();
    super.initState();
  }

  void getCountries() async {
    final response =
    await http.get(Uri.parse('https://restcountries.eu/rest/v2/all?fields=name'));
    if (response.statusCode == 200) {
      setState(() {
        countries = json.decode(response.body) as List;
      });
    }
  }

  // Validation method
  bool validateFields() {
    if (country.isEmpty || pin.isEmpty) {
      return false;
    }
    return true;
  }

  //API Call to validate Pin code
  void validatePin(String stateName) async {
    final response =
    await http.get(Uri.parse('https://api.postalpincode.in/pincode/$pin/$stateName'));
    if (response.statusCode == 200) {
      var pinResponse = json.decode(response.body);
      if (pinResponse["Status"] == "Error") {
        _showDialog("Pin code Not Found", pinResponse["Message"]);
      }
    }
  }

  // Method to showDailog
  void _showDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(20),
            child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        country = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Country Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    SizedBox(height: 30),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items:
                        countries.map((item) => DropdownMenuItem(
                          child: Text(item['name']),
                          value: item['name'],
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            country = 'India';
                          });
                        },
                        value: country,
                        isExpanded: false,
                        hint: Text('Choose Country'),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        pin = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Pin Code',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          final validationResult = validateFields();
                          if (validationResult) {
                            validatePin(country);
                          } else {
                            _showDialog("Error",
                                "Please fill all the fields correctly");
                          }
                        })
                  ],
                ))));
  }
}
