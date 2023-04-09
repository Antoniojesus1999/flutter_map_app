import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;

  GpsBloc()
      : super(const GpsState(
            isGpsEnabled: false, isGpsPermissionGranted: false)) {
    on<OnGpsAndPermissionEvent>((event, emit) => emit(state.copyWith(
        isGpsEnabled: event.isGpsEnabled,
        isGpsPermissionGranted: event.isGpsPermissionGrated)));

    _init();
  }

  Future<void> _init() async {
    final gpsInitStatus =
        await Future.wait([_checkGpsStatus(), _isPermissionGranted()]);

    add(OnGpsAndPermissionEvent(
        isGpsEnabled: gpsInitStatus[0],
        isGpsPermissionGrated: gpsInitStatus[1]));
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsStatus() async {
    //Ver si al iniciar la aplicación está activo o inactivo
    final isEnable = await Geolocator.isLocationServiceEnabled();
    print('valor de isLocationServiceEnabled $isEnable');
    //ver el listener en tiempo real
    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      print('service status $isEnabled');
      add(OnGpsAndPermissionEvent(
          isGpsEnabled: isEnabled,
          isGpsPermissionGrated: state.isGpsPermissionGranted));
    });
    return isEnable;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
        add(OnGpsAndPermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGrated: true));
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        add(OnGpsAndPermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGrated: false));
        openAppSettings();
    }
  }

  @override
  Future<void> close() {
    gpsServiceSubscription?.cancel();
    return super.close();
  }
}
