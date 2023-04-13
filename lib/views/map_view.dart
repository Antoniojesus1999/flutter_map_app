import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_app/blocs/map/map_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  final LatLng initialLocation;
  const MapView({super.key, required this.initialLocation});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition = CameraPosition(
        bearing: 192.8334901395799,
        target: initialLocation,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      compassEnabled: true,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) =>
          mapBloc.add(OnMapInitializedEvent(controller)),
    );
  }
}
