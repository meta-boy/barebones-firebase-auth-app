import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:location/location.dart';

class GetLocationWidget extends StatefulWidget {
  const GetLocationWidget({Key key}) : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocationWidget> {
  final Location location = Location();

  LocationData _location;
  String _error;

  Widget nice;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
    });
    try {
      final LocationData _locationResult = await location.getLocation();
      setState(() {
        _location = _locationResult;
        nice = WebviewScaffold(
          url:
              "https://www.google.com/maps/@${_location.latitude},${_location.longitude},12z",
          appBar: AppBar(),
        
        );
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        nice = Center(
          child: Text("Error"),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _location == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : nice;
  }
}
