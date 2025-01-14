import 'package:flutter/material.dart';

class BusFilterMenu extends StatefulWidget {
  const BusFilterMenu({super.key});

  @override
  State<BusFilterMenu> createState() => _BusFilterMenuState();
}

class _BusFilterMenuState extends State<BusFilterMenu> {
  bool isLocationMode = true;
  String sourceLocation = '';
  String destinationLocation = '';
  String busNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Bus Routes"),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mode Toggle
              Center(
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(12),
                  selectedColor: Colors.white,
                  fillColor: Theme.of(context).primaryColor,
                  constraints: const BoxConstraints(
                    minWidth: 140,
                    minHeight: 45,
                  ),
                  isSelected: [isLocationMode, !isLocationMode],
                  onPressed: (index) => setState(() => isLocationMode = index == 0),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("By Location", style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("By Bus Number", style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Filter Fields
              if (isLocationMode)
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "From Location",
                        hintText: "Enter starting point",
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => setState(() => sourceLocation = value),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "To Location",
                        hintText: "Enter destination",
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => setState(() => destinationLocation = value),
                    ),
                  ],
                )
              else
                TextField(
                  decoration: InputDecoration(
                    labelText: "Bus Number",
                    hintText: "Enter bus route number",
                    prefixIcon: const Icon(Icons.directions_bus),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => setState(() => busNumber = value),
                ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 8),
                          Text("Reset", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilter,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check),
                          SizedBox(width: 8),
                          Text("Apply", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetFields() {
    setState(() {
      if (isLocationMode) {
        sourceLocation = '';
        destinationLocation = '';
      } else {
        busNumber = '';
      }
    });
  }

  void _applyFilter() {
    if (isLocationMode) {
      if (sourceLocation.isNotEmpty || destinationLocation.isNotEmpty) {
        Navigator.of(context).pop([
          sourceLocation.trim(),
          destinationLocation.trim(),
        ]);
      }
    } else {
      if (busNumber.isNotEmpty) {
        Navigator.of(context).pop(busNumber.trim());
      }
    }
  }
}