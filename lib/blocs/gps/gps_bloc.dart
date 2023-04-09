import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  GpsBloc()
      : super(const GpsState(
            isGpsEnabled: false, isGpsPermissionGranted: false)) {
    on<OnGpsAndPermissionEvent>((event, emit) => emit(state.copyWith(
        isGpsEnabled: event.isGpsEnabled,
        isGpsPermissionGranted: event.isGpsPermissionGrated)));

    _init();
  }

  Future<void> _init() async {
    _checkGpsStatus();
  }

  Future<bool> _checkGpsStatus() async {
    //Ver si al iniciar la aplicación está activo o inactivo
    final isEnable = await Geolocator.isLocationServiceEnabled();
    print('valor de isLocationServiceEnabled $isEnable');
    //ver el listener en tiempo real
    Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = (event.index == 1) ? true : false;
      print('service status $isEnabled');
    });
    return isEnable;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
