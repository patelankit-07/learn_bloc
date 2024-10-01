import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/image_picker.dart';
import 'image_picker_event.dart';
import 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerStates> {
  final ImagePickerUtils imagePickerUtils;

  ImagePickerBloc(this.imagePickerUtils) : super(const ImagePickerStates()) {
    on<CameraCapture>(cameraCapture);
    on<GalleryPicker>(galleryPicker);
  }

  void cameraCapture(CameraCapture event, Emitter<ImagePickerStates> emit) async {
    XFile? file = await imagePickerUtils.cameraCapture();
    emit(state.copyWith(file: file));
  }

  void galleryPicker(GalleryPicker event, Emitter<ImagePickerStates> emit) async {
    XFile? file = await imagePickerUtils.pickImageFromGallery();
    emit(state.copyWith(file: file));
  }
}
