import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location locationController = Location();
  static const LatLng _pGooglePlex = LatLng(10.0182688, 76.3424971);
  static const LatLng _pApplepark = LatLng(37.346, -122.0090);

  LatLng? _currentP = null;

  @override
  void initState() {
    super.initState();
    getLocationupdaets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentP.toString()),
      ),
      body: _currentP == null
          ? const Center(
              child: Text('Location...'),
            )
          : GoogleMap(
              initialCameraPosition:
                  const CameraPosition(target: _pGooglePlex, zoom: 14),
              markers: {
                Marker(
                    markerId: const MarkerId('_currentPositon'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _currentP!),
                const Marker(
                    markerId: MarkerId('_sourecLocation'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pGooglePlex),
                const Marker(
                  markerId: MarkerId('_desitinationLocation'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _pApplepark,
                ),
              },
            ),
    );
  }

  Future<void> getLocationupdaets() async {
    bool serviceEnabled;
    PermissionStatus _permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }
    _permissionGranted = await locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationController.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        return;
      }
    }
    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print(_currentP);
        });
      }
    });
  }
}
