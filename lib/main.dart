import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:fluttermaps/widgets/marker_popup.dart';
import 'package:fluttermaps/zoombuttons_plugin_option.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Maps'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  LatLng carranzaPosition = new LatLng(36.502529144287, -6.2728500366211);
  static final List<LatLng> _points = [
    new LatLng(36.502529144287, -6.2728500366211),
  ];

  static const _markerSize = 40.0;
  List<Marker> _markers;

  // Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();
  @override
  void initState() {
    super.initState();

    _markers = _points
        .map(
          (LatLng point) => Marker(
            point: point,
            width: _markerSize,
            height: _markerSize,
            builder: (_) => Icon(Icons.location_on, size: _markerSize),
            anchorPos: AnchorPos.align(AnchorAlign.top),
          ),
        )
        .toList();

    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: _markers,
      updateMapLocationOnPositionChange: true,
      showMoveToCurrentLocationFloatingActionButton: true,
      zoomToCurrentLocationOnLoad: true,
      showHeading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FlutterMap(
        options: new MapOptions(
          center: carranzaPosition,
          zoom: 13.0,
          minZoom: 4.0,
          maxZoom: 14.0,
          swPanBoundary: LatLng(36.35000, -6.4),
          nePanBoundary: LatLng(36.80000, -6.00000),
          plugins: [
            ZoomButtonsPlugin(),
            PopupMarkerPlugin(),
            UserLocationPlugin(),
          ],
          onTap: (_) => _popupLayerController.hidePopup(),
        ),
        layers: [
          new TileLayerOptions(
            tileProvider:
                MBTilesImageProvider.fromAsset('assets/maps/mi_cadiz.mbtiles'),
            maxZoom: 14.0,
            backgroundColor: Colors.white,
            tms: false,
          ),
          PopupMarkerLayerOptions(
            markers: _markers,
            popupSnap: PopupSnap.top,
            popupController: _popupLayerController,
            popupBuilder: (BuildContext _, Marker marker) =>
                ExamplePopup(marker),
          ),
          ZoomButtonsPluginOption(
            minZoom: 4,
            maxZoom: 19,
            mini: true,
            padding: 10,
            alignment: Alignment.topRight,
          ),
          userLocationOptions,
        ],
        mapController: mapController,
      ),
    );
  }

  void resetInfo() => _popupLayerController.hidePopup();

  void showPopupForFirstMarker() {
    _popupLayerController.togglePopup(_markers.first);
  }
}
