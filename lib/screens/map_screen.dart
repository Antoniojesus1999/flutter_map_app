import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_app/blocs/location/location_bloc.dart';

import '../views/views.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    //locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state.lastKnownLocation == null) {
              return const Center(
                child: Text('Espere por favor...'),
              );
            }
            return SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: size.height - padding.bottom - padding.top,
                    width: size.width,
                    child: MapView(
                      initialLocation: state.lastKnownLocation!,
                      //TODO: BOTONES Y MAS COSAS
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
