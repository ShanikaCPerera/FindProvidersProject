import 'package:image_picker/image_picker.dart';

class UploadImageRequest {
  int _entityId;
  XFile _image;

  UploadImageRequest({
    required int entityId,
    required XFile image,
  }) : _entityId = entityId,
        _image = image;

  int get getEntityId => _entityId;

  XFile get getImage => _image;

  factory UploadImageRequest.fromJson(Map<String, dynamic> json) => UploadImageRequest(
    entityId: json["entity_id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "entity_id": _entityId,
    "image": _image,
  };
}