import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttermaps/zoombuttons_plugin_option.dart';
import 'package:latlong/latlong.dart';

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
  LatLng carranzaPosition = new LatLng(36.502529144287, -6.2728500366211);
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
          plugins: [
            ZoomButtonsPlugin(),
          ],
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: carranzaPosition,
                  builder: (ctx) => Container(
                        child: GestureDetector(
                          onTap: () {
                            final snackBar =
                                SnackBar(content: Text('Estadio Carranza'));
                            Scaffold.of(ctx).showSnackBar(snackBar);
                          },
                          child: FlutterLogo(
                            colors: Colors.blue,
                          ),
                        ),
                      )),
            ],
          ),
          ZoomButtonsPluginOption(
              minZoom: 4,
              maxZoom: 19,
              mini: true,
              padding: 10,
              alignment: Alignment.bottomRight)
        ],
      ),
    );
  }
}
