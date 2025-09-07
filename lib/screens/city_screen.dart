import 'package:flutter/material.dart';
import '../data/locations.dart';
import '../models/city.dart';

class CityScreen extends StatefulWidget {
  final String countryName;

  const CityScreen({Key? key, required this.countryName}) : super(key: key);

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  List<City> _cities = [];
  List<City> _filteredCities = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  void _loadCities() {
    setState(() {
      _cities = (locations[widget.countryName] ?? [])
          .map((name) => City(name: name))
          .toList();
      _filteredCities = _cities;
    });
  }

  void _filterCities(String query) {
    setState(() {
      _filteredCities = _cities
          .where(
              (city) => city.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select City'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCities,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCities.length,
              itemBuilder: (context, index) {
                final city = _filteredCities[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(city.name),
                    onTap: () {
                      Navigator.pop(context, city.name);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
