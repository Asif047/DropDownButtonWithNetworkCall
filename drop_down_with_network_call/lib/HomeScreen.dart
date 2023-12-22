import 'dart:convert';

import 'package:drop_down_with_network_call/model/Cities.dart';
import 'package:drop_down_with_network_call/model/Countries.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Countries> _countries;
  late List<String> _countryList;

  late List<Cities> _cities;
  late List<String> _cityList;

  final Map<String, List<String>> _dropDownMenu = {
    'Study': ['Math', 'English', 'Japanese'],
    'Workout': ['Shoulder', 'Chest', 'Back'],
    'Coding': ['Flutter', 'Python', 'C#']
  };

  String? _selectedKey = null;
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _countries = [];
    _countryList = [];

    _cities = [];
    _cityList = [];
    _fetchCountries();
    _fetchCities();
  }

  Future<void> _fetchCountries() async {
    final List<Countries> countries = await fetchCountries(http.Client());
    setState(() {
      _countries = countries;

      for(int i = 0; i < countries[0].data.length; i++) {
        _countryList.add(_countries[0].data[i].country);
      }

    });

    print("country: ${_countryList[0]}");
  }

  Future<void> _fetchCities() async {
    final List<Cities> cities = await fetchCities(http.Client(), _selectedKey!!);
    setState(() {
      _cities = cities;
      _cityList = _cities[0].data;
    });

    print("city: ${_cityList[0]}");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Double DropdownButton Demo'),
      ),
      body: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              SizedBox(height: 20,),
              const Text(
                'Select Country List:',
                style: TextStyle(fontSize: 24),
              ),
              Container(
                width: 250,
                child: DropdownButton<String>(
                  value: _selectedKey,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 12,
                  elevation: 6,
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedKey = newValue;
                      _selectedItem = null;
                      _cityList = [];
                    });

                    _fetchCities();
                  },
                  items: _countryList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                          width: 150,
                          child: Text(value)),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),


          SizedBox(height: 40,),

          _selectedKey != null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Text(
                'Select City list:',
                style: TextStyle(fontSize: 24),
              ),
              DropdownButton<String>(
                value: _selectedItem,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 30,
                elevation: 16,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.grey,
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                },
                items: _cityList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                        width: 250,
                        child: Text(value)),
                  );
                }).toList(),
              ),
            ],
          )
              : Container(),
        ],
      ),
    );



  }



}


Future<List<Countries>> fetchCountries(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://countriesnow.space/api/v0.1/countries'));

  return compute(parseCountries, response.body);
}

Future<List<Cities>> fetchCities(http.Client client, String query) async {
  final response = await client
      .get(Uri.parse('https://countriesnow.space/api/v0.1/countries/cities/q?country=${query.toString().toLowerCase()}'));

  return compute(parseCities, response.body);
}



List<Cities> parseCities(String responseBody) {
  final Map<String, dynamic> parsed = jsonDecode(responseBody);

  return [Cities.fromJson(parsed)];
}


List<Countries> parseCountries(String responseBody) {
  final Map<String, dynamic> parsed = jsonDecode(responseBody);

  return [Countries.fromJson(parsed)];
}



