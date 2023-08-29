import 'dart:io';

class UploadFileRequest {
  int _entityId;
  File _file;

  UploadFileRequest({
    required int entityId,
    required File file,
  }) : _entityId = entityId,
        _file = file;

  int get getEntityId => _entityId;

  File get getFile => _file;

  factory UploadFileRequest.fromJson(Map<String, dynamic> json) => UploadFileRequest(
    entityId: json["entity_id"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "entity_id": _entityId,
    "file": _file,
  };
}