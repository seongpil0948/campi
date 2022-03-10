import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

const defaultZoom = 15.0;
const CameraPosition defaultPosition = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: defaultZoom,
);

// ignore: must_be_immutable
class CampyMap extends StatefulWidget {
  final double? initLat;
  final double? initLng;
  MapType mapType = MapType.normal;
  CampyMap({Key? key, this.initLat, this.initLng}) : super(key: key);

  @override
  _CampyMapState createState() => _CampyMapState();
}

class _CampyMapState extends State<CampyMap> {
  final Completer<GoogleMapController> _controller = Completer();

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

  @override
  Widget build(BuildContext context) {
    var _markers = [
      Marker(
          markerId: const MarkerId("1"),
          draggable: true,
          onTap: () {},
          position: LatLng(widget.initLat!, widget.initLng!))
    ];
    return Stack(children: [
      GoogleMap(
          mapType: widget.mapType,
          markers: Set.from(_markers),
          // ignore: prefer_collection_literals
          gestureRecognizers: Set()
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
            ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
            ..add(
              Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()),
            ),
          initialCameraPosition:
              widget.initLat != null && widget.initLng != null
                  ? CameraPosition(
                      target: LatLng(widget.initLat!, widget.initLng!),
                      zoom: defaultZoom)
                  : defaultPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true),
      Positioned(
        right: 10,
        bottom: 70,
        child: FloatingActionButton(
            child: const Icon(Icons.switch_camera),
            mini: true,
            onPressed: () {
              setState(() {
                widget.mapType = widget.mapType == MapType.normal
                    ? MapType.hybrid
                    : MapType.normal;
              });
            }),
      )
    ]);
  }
}

// ignore: must_be_immutable
class SelectMapW extends StatefulWidget {
  void Function(PickResult) onPick;
  SelectMapW({Key? key, required this.onPick}) : super(key: key);

  @override
  _SelectMapWState createState() => _SelectMapWState();
}

class _SelectMapWState extends State<SelectMapW> {
  static const kInitialPosition = LatLng(37.48030185005912, 126.85525781355892);
  PickResult? selectedPlace;
  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Row(
      children: [
        Image.asset("assets/images/map_marker.png", height: 20),
        selectedPlace != null && selectedPlace!.formattedAddress != null
            ? Container(
                width: s.width / 2.5,
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  selectedPlace != null
                      ? "${selectedPlace?.formattedAddress}"
                      : '',
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  softWrap: false,
                ),
              )
            : TextButton(
                child: const Text("위치 선택", textAlign: TextAlign.center),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Theme(
                            data: Theme.of(context).copyWith(
                                inputDecorationTheme:
                                    const InputDecorationTheme()),
                            child: PlacePicker(
                              apiKey: 'AIzaSyAIVJL0nZPQc-N3EZ0YJCH90R4ZYxWMipY',
                              initialPosition: kInitialPosition,
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              //usePlaceDetailSearch: true,
                              autocompleteLanguage: "ko",
                              region: 'KR',
                              selectedPlaceWidgetBuilder:
                                  (_, place, state, isSearchBarFocused) {
                                return isSearchBarFocused
                                    ? Container()
                                    : FloatingCard(
                                        bottomPosition: 0.0,
                                        leftPosition: 0.0,
                                        rightPosition: 0.0,
                                        width: 500,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: state == SearchingState.Searching
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : Column(
                                                children: [
                                                  const SizedBox(height: 20),
                                                  Text(
                                                      "${place?.formattedAddress}"),
                                                  ElevatedButton(
                                                    child: Text(
                                                      "위치 선택 완료",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                    onPressed: () {
                                                      if (place != null) {
                                                        setState(() {
                                                          selectedPlace = place;
                                                          widget.onPick(place);
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                  ),
                                                  const SizedBox(height: 20)
                                                ],
                                              ),
                                      );
                              },
                              pinBuilder: (context, state) {
                                if (state == PinState.Idle) {
                                  return const Icon(Icons.favorite_border);
                                } else {
                                  return const Icon(Icons.favorite);
                                }
                              },
                            ));
                      },
                    ),
                  );
                  selectedPlace == null
                      ? Container()
                      : Text(selectedPlace!.formattedAddress ?? "");
                },
              ),
      ],
    );
  }
}
