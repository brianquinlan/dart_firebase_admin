import 'dart:async';

import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:googleapis_firestore/googleapis_firestore.dart';

/// Main entry point for all Firestore examples
Future<void> firestoreExample(FirebaseApp admin) async {
  print('\n### Firestore Examples ###\n');

  await basicFirestoreExample(admin);
  await multiDatabaseExample(admin);
  await bulkWriterExamples(admin);
  await bundleBuilderExample(admin);
}

/// Example 1: Basic Firestore operations with default database
Future<void> basicFirestoreExample(FirebaseApp admin) async {
  print('> Basic Firestore operations (default database)...\n');

  final firestore = admin.firestore();

  try {
    final collection = firestore.collection('users');
    await collection.doc('123').set({'name': 'John Doe', 'age': 27});
    final snapshot = await collection.get();
    for (final doc in snapshot.docs) {
      print('> Document data: ${doc.data()}');
    }
  } catch (e) {
    print('> Error: $e');
  }
  print('');
}

/// Example 2: Multi-database support
Future<void> multiDatabaseExample(FirebaseApp admin) async {
  print('### Multi-Database Examples ###\n');

  // Named database
  print('> Using named database "my-database"...\n');
  final namedFirestore = admin.firestore(databaseId: 'my-database');

  try {
    final collection = namedFirestore.collection('products');
    await collection.doc('product-1').set({
      'name': 'Widget',
      'price': 19.99,
      'inStock': true,
    });
    print('> Document written to named database\n');

    final doc = await collection.doc('product-1').get();
    if (doc.exists) {
      print('> Retrieved from named database: ${doc.data()}');
    }
  } catch (e) {
    print('> Error with named database: $e');
  }

  // Multiple databases simultaneously
  print('\n> Demonstrating multiple database access...\n');
  try {
    final defaultDb = admin.firestore();
    final analyticsDb = admin.firestore(databaseId: 'analytics-db');

    await defaultDb.collection('users').doc('user-1').set({
      'name': 'Alice',
      'email': 'alice@example.com',
    });

    await analyticsDb.collection('events').doc('event-1').set({
      'type': 'page_view',
      'timestamp': DateTime.now().toIso8601String(),
      'userId': 'user-1',
    });

    print('> Successfully wrote to multiple databases');
  } catch (e) {
    print('> Error with multiple databases: $e');
  }
  print('');
}

/// BulkWriter examples demonstrating various patterns
Future<void> bulkWriterExamples(FirebaseApp admin) async {
  print('### BulkWriter Examples ###\n');

  final firestore = admin.firestore();

  await bulkWriterBasicExample(firestore);
  await bulkWriterErrorHandlingExample(firestore);
  await bulkWriterLargeBatchExample(firestore);
  await bulkWriterFlushPatternExample(firestore);
  await bulkWriterDataMigrationExample(firestore);
  await bulkWriterCleanupPatternExample(firestore);
  await bulkWriterRateLimitingExample(firestore);
}

/// Basic BulkWriter usage
Future<void> bulkWriterBasicExample(Firestore firestore) async {
  print('> Basic BulkWriter usage...\n');

  try {
    final bulkWriter = firestore.bulkWriter();

    // Queue multiple write operations (don't await individual operations)
    for (var i = 0; i < 10; i++) {
      unawaited(
        bulkWriter.set(firestore.collection('bulk-demo').doc('item-$i'), {
          'name': 'Item $i',
          'index': i,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );
    }

    await bulkWriter.close();
    print('> Successfully wrote 10 documents in bulk\n');
  } catch (e) {
    print('> Error: $e');
  }
}

/// BulkWriter with error handling and retry logic
Future<void> bulkWriterErrorHandlingExample(Firestore firestore) async {
  print('> BulkWriter with error handling and retry logic...\n');

  try {
    final bulkWriter = firestore.bulkWriter();

    var successCount = 0;
    var errorCount = 0;

    bulkWriter.onWriteResult((ref, result) {
      successCount++;
      print('  ✓ Success: ${ref.path} at ${result.writeTime}');
    });

    bulkWriter.onWriteError((error) {
      errorCount++;
      print('  ✗ Error: ${error.documentRef.path} - ${error.message}');

      // Retry on transient errors, but not more than 3 times
      if (error.failedAttempts < 3 &&
          (error.code.name == 'unavailable' || error.code.name == 'aborted')) {
        print('    → Retrying (attempt ${error.failedAttempts + 1})...');
        return true;
      }
      return false;
    });

    // Mix of operations (queue them, don't await)
    // Use set() instead of create() to make example idempotent
    unawaited(
      bulkWriter.set(firestore.collection('orders').doc('order-1'), {
        'status': 'pending',
        'total': 99.99,
      }),
    );

    unawaited(
      bulkWriter.set(firestore.collection('orders').doc('order-2'), {
        'status': 'completed',
        'total': 149.99,
      }),
    );

    final orderRef = firestore.collection('orders').doc('order-3');
    await orderRef.set({'status': 'processing'});

    unawaited(
      bulkWriter.update(orderRef, {
        FieldPath(const ['status']): 'shipped',
        FieldPath(const ['shippedAt']): DateTime.now().toIso8601String(),
      }),
    );

    unawaited(
      bulkWriter.delete(firestore.collection('orders').doc('order-to-delete')),
    );

    await bulkWriter.close();

    print('\n> BulkWriter completed:');
    print('  - Successful writes: $successCount');
    print('  - Failed writes: $errorCount\n');
  } catch (e) {
    print('> Error: $e');
  }
}

/// Large batch processing
Future<void> bulkWriterLargeBatchExample(Firestore firestore) async {
  print('> BulkWriter processing 100+ documents...\n');

  try {
    final bulkWriter = firestore.bulkWriter();
    final startTime = DateTime.now();

    for (var i = 0; i < 100; i++) {
      unawaited(
        bulkWriter.set(firestore.collection('analytics').doc('event-$i'), {
          'eventType': i % 5 == 0 ? 'pageview' : 'click',
          'userId': 'user-${i % 10}',
          'timestamp': DateTime.now().toIso8601String(),
          'metadata': {'index': i, 'batch': i ~/ 20},
        }),
      );
    }

    await bulkWriter.close();
    final duration = DateTime.now().difference(startTime);

    print('> Processed 100 documents in ${duration.inMilliseconds}ms\n');
  } catch (e) {
    print('> Error: $e');
  }
}

/// Flush pattern for real-time updates
Future<void> bulkWriterFlushPatternExample(Firestore firestore) async {
  print('> BulkWriter with flush pattern...\n');

  try {
    final bulkWriter = firestore.bulkWriter();

    // Batch 1: User updates
    for (var i = 0; i < 5; i++) {
      unawaited(
        bulkWriter.set(firestore.collection('users-batch').doc('user-$i'), {
          'name': 'User $i',
          'status': 'active',
        }),
      );
    }

    await bulkWriter.flush();
    print('  ✓ Batch 1 flushed (5 user updates)');

    // Batch 2: Settings updates
    for (var i = 0; i < 3; i++) {
      unawaited(
        bulkWriter.set(firestore.collection('settings').doc('setting-$i'), {
          'key': 'setting-$i',
          'value': i * 10,
        }),
      );
    }

    await bulkWriter.flush();
    print('  ✓ Batch 2 flushed (3 settings updates)');

    await bulkWriter.close();
    print('> Flush pattern completed\n');
  } catch (e) {
    print('> Error: $e');
  }
}

/// Data migration pattern
Future<void> bulkWriterDataMigrationExample(Firestore firestore) async {
  print('> BulkWriter for data migration...\n');

  try {
    final bulkWriter = firestore.bulkWriter();

    final sourceCollection = firestore.collection('old-data');
    final targetCollection = firestore.collection('new-data');

    // Create source data
    for (var i = 0; i < 5; i++) {
      await sourceCollection.doc('old-$i').set({
        'legacyField': 'value-$i',
        'oldFormat': true,
      });
    }

    // Read and transform
    final sourceSnapshot = await sourceCollection.get();

    for (final doc in sourceSnapshot.docs) {
      final oldData = doc.data() as Map<String, dynamic>;

      final newData = {
        'newField': oldData['legacyField'],
        'migrated': true,
        'migratedAt': DateTime.now().toIso8601String(),
        'originalId': doc.id,
      };

      unawaited(bulkWriter.set(targetCollection.doc(doc.id), newData));
    }

    await bulkWriter.close();
    print('> Migrated ${sourceSnapshot.docs.length} documents\n');
  } catch (e) {
    print('> Error: $e');
  }
}

/// Cleanup pattern
Future<void> bulkWriterCleanupPatternExample(Firestore firestore) async {
  print('> BulkWriter with cleanup pattern...\n');

  try {
    final bulkWriter = firestore.bulkWriter();

    var operationsTracked = 0;

    bulkWriter.onWriteResult((ref, result) {
      operationsTracked++;
    });

    // Create temp documents
    for (var i = 0; i < 5; i++) {
      unawaited(
        bulkWriter.set(firestore.collection('temp-data').doc('temp-$i'), {
          'temporary': true,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );
    }

    await bulkWriter.flush();
    print('  ✓ Created 5 temporary documents');

    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Clean up
    for (var i = 0; i < 5; i++) {
      unawaited(
        bulkWriter.delete(firestore.collection('temp-data').doc('temp-$i')),
      );
    }

    await bulkWriter.close();
    print('  ✓ Cleaned up temporary documents');
    print('> Total operations: $operationsTracked\n');
  } catch (e) {
    print('> Error: $e');
  }
}

/// Rate limiting demonstration
Future<void> bulkWriterRateLimitingExample(Firestore firestore) async {
  print('> BulkWriter automatic rate limiting...\n');

  try {
    final bulkWriter = firestore.bulkWriter();

    print('  Queueing 500 operations (will be automatically rate-limited)...');

    final startTime = DateTime.now();

    for (var i = 0; i < 500; i++) {
      unawaited(
        bulkWriter.set(firestore.collection('rate-limit-demo').doc('doc-$i'), {
          'index': i,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    }

    await bulkWriter.close();

    final duration = DateTime.now().difference(startTime);
    print('  ✓ Completed 500 operations in ${duration.inSeconds}s');
    print('  (BulkWriter automatically batched and rate-limited)\n');
  } catch (e) {
    print('> Error: $e');
  }
}

/// BundleBuilder example demonstrating data bundle creation
Future<void> bundleBuilderExample(FirebaseApp admin) async {
  print('### BundleBuilder Example ###\n');

  final firestore = admin.firestore();

  try {
    print('> Creating a data bundle...\n');

    // Create a bundle
    final bundle = firestore.bundle('example-bundle');

    // Create and add some sample documents
    final collection = firestore.collection('bundle-demo');

    // Add individual documents
    await collection.doc('user-1').set({
      'name': 'Alice Smith',
      'role': 'admin',
      'lastLogin': DateTime.now().toIso8601String(),
    });

    await collection.doc('user-2').set({
      'name': 'Bob Johnson',
      'role': 'user',
      'lastLogin': DateTime.now().toIso8601String(),
    });

    await collection.doc('user-3').set({
      'name': 'Charlie Brown',
      'role': 'user',
      'lastLogin': DateTime.now().toIso8601String(),
    });

    // Get snapshots and add to bundle
    final doc1 = await collection.doc('user-1').get();
    final doc2 = await collection.doc('user-2').get();
    final doc3 = await collection.doc('user-3').get();

    bundle.addDocument(doc1);
    bundle.addDocument(doc2);
    bundle.addDocument(doc3);

    print('  ✓ Added 3 documents to bundle');

    // Add a query to the bundle
    final query = collection.where('role', WhereFilter.equal, 'user');
    final querySnapshot = await query.get();

    bundle.addQuery('regular-users', querySnapshot);

    print('  ✓ Added query "regular-users" to bundle');

    // Build the bundle
    final bundleData = bundle.build();

    print('\n> Bundle created successfully!');
    print('  - Bundle size: ${bundleData.length} bytes');
    print('  - Contains: 3 documents + 1 named query');
    print('\n  You can now:');
    print('  - Serve this bundle via CDN');
    print('  - Save to a file for static hosting');
    print('  - Send to clients for offline-first apps');
    print('  - Cache and reuse across multiple client sessions\n');

    // Example: Save to file (commented out)
    // import 'dart:io';
    // await File('bundle.txt').writeAsBytes(bundleData);

    // Clean up
    await collection.doc('user-1').delete();
    await collection.doc('user-2').delete();
    await collection.doc('user-3').delete();
  } catch (e) {
    print('> Error creating bundle: $e');
  }
}
