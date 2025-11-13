import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pepper_cloud/features/initial/bloc/initial_event.dart';
import 'package:pepper_cloud/features/initial/bloc/initial_state.dart';

class InitialBloc extends Bloc<InitialEvent, InitialState> {
  InitialBloc() : super(InitialInitial()) {
    on<StartInitial>((event, emit) async {});
  }
}
