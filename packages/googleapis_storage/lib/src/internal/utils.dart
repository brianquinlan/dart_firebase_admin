import 'package:googleapis_storage/googleapis_storage.dart';

String assertProjectId(StorageOptions options, String? projectId) {
  // Check if we have a project ID explicitly provided or inherited from the options.
  final explicitProjectId = projectId ?? options.projectId;

  if (explicitProjectId == null) {
    throw ArgumentError(
      'A project ID is required to perform this operation. Please provide a specific project ID or set the project ID in the StorageOptions during initialization.',
    );
  }

  return explicitProjectId;
}
