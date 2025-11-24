import 'package:test/test.dart';
import 'package:googleapis/storage/v1.dart' as storage_v1;
import 'main.dart';

void storageTests() {
  group('Integration Tests', () {
    test('should create a bucket', () async {
      // Ensure setup completed successfully
      if (storage == null || projectId == null) {
        fail(
            'Test setup failed. Check that PROJECT_ID is set and authentication is configured.');
      }

      final bucketName = generateBucketName();

      // Create bucket
      final bucketMetadata = storage_v1.Bucket()..name = bucketName;
      final createdBucket = await storage!.createBucket(
        bucketMetadata,
      );

      // Verify bucket was created
      expect(createdBucket.id, equals(bucketName));
      final metadata = createdBucket.metadata;
      expect(metadata, isNotNull);
      expect(metadata.name, equals(bucketName));

      // Verify we can get the bucket
      final retrievedBucket = await storage!.bucket(bucketName).getMetadata();
      expect(retrievedBucket.name, equals(bucketName));

      // Clean up: delete the bucket
      await createdBucket.delete();
    });
  });
}
