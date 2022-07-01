import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'file_picker_event.dart';
part 'file_picker_state.dart';

class FilePickerBloc extends Bloc<FilePickerEvent, FilePickerState> {
  FilePickerBloc() : super(FilePickerInitial()) {
    on<FilePickerEvent>((event, emit) {});
  }
}
