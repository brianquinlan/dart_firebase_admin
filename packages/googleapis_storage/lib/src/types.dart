part of '../googleapis_storage.dart';

class GetServiceAccountOptions {
  final String? userProject;
  final String? projectId;

  const GetServiceAccountOptions({this.userProject, this.projectId});
}

class RetryOptions {
  final bool autoRetry;
  final int maxRetries;
  final Duration totalTimeout;
  final Duration maxRetryDelay;
  final double retryDelayMultiplier;
  final RetryableErrorFn? retryableErrorFn;
  final IdempotencyStrategy idempotencyStrategy;

  const RetryOptions({
    this.autoRetry = true,
    this.maxRetries = 3,
    this.totalTimeout = const Duration(seconds: 600),
    this.maxRetryDelay = const Duration(seconds: 64),
    this.retryDelayMultiplier = 2.0,
    this.retryableErrorFn,
    this.idempotencyStrategy = IdempotencyStrategy.retryConditional,
  });

  RetryOptions copyWith({
    bool? autoRetry,
    int? maxRetries,
    Duration? totalTimeout,
    Duration? maxRetryDelay,
    double? retryDelayMultiplier,
    RetryableErrorFn? retryableErrorFn,
    IdempotencyStrategy? idempotencyStrategy,
  }) {
    return RetryOptions(
      autoRetry: autoRetry ?? this.autoRetry,
      maxRetries: maxRetries ?? this.maxRetries,
      totalTimeout: totalTimeout ?? this.totalTimeout,
      maxRetryDelay: maxRetryDelay ?? this.maxRetryDelay,
      retryDelayMultiplier: retryDelayMultiplier ?? this.retryDelayMultiplier,
      retryableErrorFn: retryableErrorFn ?? this.retryableErrorFn,
      idempotencyStrategy: idempotencyStrategy ?? this.idempotencyStrategy,
    );
  }
}

class PreconditionOptions {
  final int? ifGenerationMatch;
  final int? ifGenerationNotMatch;
  final int? ifMetagenerationMatch;
  final int? ifMetagenerationNotMatch;

  const PreconditionOptions({
    this.ifGenerationMatch,
    this.ifGenerationNotMatch,
    this.ifMetagenerationMatch,
    this.ifMetagenerationNotMatch,
  });
}

/// Options for delete operations, mirroring Node's DeleteOptions.
///
/// Extends [PreconditionOptions] to include delete-specific options.
class DeleteOptions extends PreconditionOptions {
  /// If true, ignore 404 errors (treat as success if object doesn't exist).
  final bool ignoreNotFound;

  /// The ID of the project which will be billed for the request.
  final String? userProject;

  const DeleteOptions({
    this.ignoreNotFound = false,
    this.userProject,
    super.ifGenerationMatch,
    super.ifGenerationNotMatch,
    super.ifMetagenerationMatch,
    super.ifMetagenerationNotMatch,
  });
}

typedef CorsConfiguration = storage_v1.BucketCors;

class RestoreOptions {
  final int generation;
  final Projection? projection;
  final String? userProject;

  const RestoreOptions({
    required this.generation,
    this.projection,
    this.userProject,
  });
}

class SetStorageClassOptions extends SetBucketMetadataOptions {
  const SetStorageClassOptions({
    super.userProject,
    super.ifMetagenerationMatch,
    super.ifMetagenerationNotMatch,
    super.ifGenerationMatch,
    super.ifGenerationNotMatch,
  });
}

class SetLabelsOptions extends SetBucketMetadataOptions {
  const SetLabelsOptions({
    super.userProject,
    super.ifMetagenerationMatch,
    super.ifMetagenerationNotMatch,
    super.ifGenerationMatch,
    super.ifGenerationNotMatch,
  });
}

sealed class MakeBucketVisibilityOptions {
  const MakeBucketVisibilityOptions._();
}

class MakeBucketPublicOptions {
  final bool? includeFiles;
  final bool? force;

  const MakeBucketPublicOptions({this.includeFiles, this.force});
}

class MakeBucketPrivateOptions {
  final bool? includeFiles;
  final bool? force;
  final BucketMetadata? metadata;
  final String? userProject;
  final PreconditionOptions? preconditionOpts;

  const MakeBucketPrivateOptions({
    this.includeFiles,
    this.force,
    this.metadata,
    this.userProject,
    this.preconditionOpts,
  });
}

class MakeAllFilesPublicPrivateOptions {
  final bool? force;
  final bool? private;
  final bool? public;
  final String? userProject;

  const MakeAllFilesPublicPrivateOptions._({
    this.force,
    this.private,
    this.public,
    this.userProject,
  });
}

class EnableLoggingOptions extends PreconditionOptions {
  final String prefix;
  final Bucket? bucket;

  const EnableLoggingOptions({required this.prefix, this.bucket});
}

/// Options for uploading a file from the filesystem.
class UploadOptions {
  /// The place to save your file. If given a String, the file will be uploaded to the bucket
  /// using the string as a filename. When given a File object, your local file will be uploaded
  /// to the File object's bucket and under the File object's name. If omitted, the file is uploaded
  /// to your bucket using the name of the local file.
  final Object? destination; // String or File

  /// A custom encryption key. See Customer-supplied Encryption Keys.
  final String? encryptionKey;

  /// Automatically gzip the file. This will set metadata.contentEncoding to 'gzip'.
  /// If null, the contentType is used to determine if the file should be gzipped (auto-detect).
  final bool? gzip;

  /// The name of the Cloud KMS key that will be used to encrypt the object.
  final String? kmsKeyName;

  /// Metadata for the file. See Objects: insert request body for details.
  final FileMetadata? metadata;

  /// The starting byte of the upload stream, for resuming an interrupted upload. Defaults to 0.
  final int? offset;

  /// Apply a predefined set of access controls to this object.
  final PredefinedAcl? predefinedAcl;

  /// Make the uploaded file private. (Alias for predefinedAcl = 'private')
  final bool? private;

  /// Make the uploaded file public. (Alias for predefinedAcl = 'publicRead')
  final bool? public;

  /// Resumable uploads are automatically enabled and must be shut off explicitly by setting to false.
  final bool? resumable;

  /// Set the HTTP request timeout in milliseconds. This option is not available for resumable uploads. Default: 60000
  final int? timeout;

  /// The URI for an already-created resumable upload. See File.createResumableUpload().
  final String? uri;

  /// The ID of the project which will be billed for the request.
  final String? userProject;

  /// Validation type for data integrity checks. By default, data integrity is validated with an MD5 checksum.
  final ValidationType? validation;

  /// Precondition options for the upload.
  final PreconditionOptions? preconditionOpts;

  /// Callback for upload progress events.
  final void Function(UploadProgress)? onUploadProgress;

  /// Chunk size for resumable uploads. Default: 256KB
  final int? chunkSize;

  /// High water mark for the stream. Controls buffer size.
  final int? highWaterMark;

  /// Whether this is a partial upload.
  final bool? isPartialUpload;

  const UploadOptions({
    this.destination,
    this.encryptionKey,
    this.gzip,
    this.kmsKeyName,
    this.metadata,
    this.offset,
    this.predefinedAcl,
    this.private,
    this.public,
    this.resumable,
    this.timeout,
    this.uri,
    this.userProject,
    this.validation,
    this.preconditionOpts,
    this.onUploadProgress,
    this.chunkSize,
    this.highWaterMark,
    this.isPartialUpload,
  });
}

class GetBucketsOptions {
  final bool? autoPaginate;
  final String? projectId;
  final int? maxApiCalls;
  final int? maxResults;
  final String? pageToken;
  final String? prefix;
  final Projection? projection;
  final bool? softDeleted;
  final String? userProject;

  const GetBucketsOptions({
    this.autoPaginate = true,
    this.projectId,
    this.maxApiCalls,
    this.maxResults,
    this.pageToken,
    this.prefix,
    this.projection,
    this.softDeleted,
    this.userProject,
  });

  GetBucketsOptions copyWith({
    bool? autoPaginate,
    String? projectId,
    int? maxApiCalls,
    int? maxResults,
    String? pageToken,
    String? prefix,
    Projection? projection,
    bool? softDeleted,
    String? userProject,
  }) {
    return GetBucketsOptions(
      autoPaginate: autoPaginate ?? this.autoPaginate,
      projectId: projectId ?? this.projectId,
      maxApiCalls: maxApiCalls ?? this.maxApiCalls,
      maxResults: maxResults ?? this.maxResults,
      pageToken: pageToken ?? this.pageToken,
      prefix: prefix ?? this.prefix,
      projection: projection ?? this.projection,
      softDeleted: softDeleted ?? this.softDeleted,
      userProject: userProject ?? this.userProject,
    );
  }
}

class AddLifecycleRuleOptions extends PreconditionOptions {
  final bool append;

  const AddLifecycleRuleOptions({
    this.append = true,
    super.ifMetagenerationMatch,
    super.ifMetagenerationNotMatch,
    super.ifGenerationMatch,
    super.ifGenerationNotMatch,
  });
}

class CombineOptions extends PreconditionOptions {
  final String? kmsKeyName;
  final String? userProject;

  const CombineOptions({
    this.kmsKeyName,
    this.userProject,
    super.ifMetagenerationMatch,
    super.ifMetagenerationNotMatch,
    super.ifGenerationMatch,
    super.ifGenerationNotMatch,
  });
}

class SetBucketMetadataOptions extends PreconditionOptions {
  final String? userProject;
  final PredefinedAcl? predefinedAcl;
  const SetBucketMetadataOptions({
    this.userProject,
    this.predefinedAcl,
    super.ifMetagenerationMatch,
    super.ifMetagenerationNotMatch,
    super.ifGenerationMatch,
    super.ifGenerationNotMatch,
  });
}

enum PredefinedAcl {
  authenticatedRead('authenticatedRead'),
  private('private'),
  projectPrivate('projectPrivate'),
  publicRead('publicRead'),
  publicReadWrite('publicReadWrite');

  /// The string value expected by the Google Cloud Storage API.
  final String value;

  const PredefinedAcl(this.value);
}

enum PredefinedDefaultObjectAcl {
  authenticatedRead,
  bucketOwnerFullControl,
  bucketOwnerRead,
  private,
  projectPrivate,
  publicRead,
}

enum Projection { full, noAcl }

class GetBucketOptions {
  /// Automatically create the bucket if it doesn't already exist.
  final bool autoCreate;
  final String? userProject;

  const GetBucketOptions({this.autoCreate = false, this.userProject});
}

class GetBucketSignedUrlOptions {
  final Uri? host; // inherited from SignedUrlConfig
  final Uri? signingEndpoint; // inherited from SignedUrlConfig

  final String action;
  final SignedUrlVersion? version;
  final String? cname;
  final bool? virtualHostedStyle;
  final DateTime expires;
  final Map<String, String>? extensionHeaders;
  final Map<String, String>? queryParams;

  const GetBucketSignedUrlOptions({
    this.host,
    this.signingEndpoint,
    this.action = 'list',
    this.version,
    this.cname,
    this.virtualHostedStyle = false,
    required this.expires,
    this.extensionHeaders,
    this.queryParams,
  });
}

class CreateNotificationOptions {
  /// An optional list of additional attributes to attach to each Cloud PubSub
  /// message published for this notification subscription.
  final Map<String, String>? customAttributes;

  /// If present, only send notifications about listed event types.
  /// If empty, send notifications for all event types.
  final List<String>? eventTypes;

  /// If present, only apply this notification configuration to object names
  /// that begin with this prefix.
  final String? objectNamePrefix;

  /// The desired content of the Payload. Defaults to `JSON_API_V1`.
  ///
  /// Acceptable values are:
  /// - `JSON_API_V1`
  /// - `NONE`
  final String? payloadFormat;

  /// The ID of the project which will be billed for the request.
  final String? userProject;

  const CreateNotificationOptions({
    this.customAttributes,
    this.eventTypes,
    this.objectNamePrefix,
    this.payloadFormat,
    this.userProject,
  });
}

class BucketOptions {
  final Crc32Generator? crc32cGenerator;
  final String? kmsKeyName;
  final PreconditionOptions? preconditionOpts;
  final String? userProject;
  final int? generation;
  final bool? softDeleted;

  const BucketOptions({
    this.crc32cGenerator,
    this.kmsKeyName,
    this.preconditionOpts,
    this.userProject,
    this.generation,
    this.softDeleted,
  });

  BucketOptions copyWith({
    Crc32Generator? crc32cGenerator,
    String? kmsKeyName,
    PreconditionOptions? preconditionOpts,
    String? userProject,
    int? generation,
    bool? softDeleted,
  }) {
    return BucketOptions(
      crc32cGenerator: crc32cGenerator ?? this.crc32cGenerator,
      kmsKeyName: kmsKeyName ?? this.kmsKeyName,
      preconditionOpts: preconditionOpts ?? this.preconditionOpts,
      userProject: userProject ?? this.userProject,
      generation: generation ?? this.generation,
      softDeleted: softDeleted ?? this.softDeleted,
    );
  }
}

typedef BucketMetadata = storage_v1.Bucket;
typedef LifecycleRule = storage_v1.BucketLifecycleRule;

abstract class WatchAllOptions {
  final String? delimiter;
  final int? maxResults;
  final String? pageToken;
  final String? prefix;
  final String? projection;
  final String? userProject;
  final bool? versions;

  const WatchAllOptions({
    this.delimiter,
    this.maxResults,
    this.pageToken,
    this.prefix,
    this.projection,
    this.userProject,
    this.versions,
  });
}

class CreateChannelConfig extends WatchAllOptions {
  final String address;

  const CreateChannelConfig({
    required this.address,
    super.delimiter,
    super.maxResults,
    super.pageToken,
    super.prefix,
    super.projection,
    super.userProject,
    super.versions,
  });
}

class CreateChannelOptions {
  final String? userProject;

  const CreateChannelOptions({this.userProject});
}

typedef ChannelMetadata = storage_v1.Channel;

typedef FileMetadata = storage_v1.Object;

class FileOptions {
  final Crc32Generator? crc32cGenerator;
  final String? encryptionKey;
  final int? generation;
  final String? restoreToken;
  final String? kmsKeyName;
  final PreconditionOptions? preconditionOpts;
  final String? userProject;

  const FileOptions({
    this.crc32cGenerator,
    this.encryptionKey,
    this.generation,
    this.restoreToken,
    this.kmsKeyName,
    this.preconditionOpts,
    this.userProject,
  });

  FileOptions copyWith({
    Crc32Generator? crc32cGenerator,
    String? encryptionKey,
    int? generation,
    String? restoreToken,
    String? kmsKeyName,
    PreconditionOptions? preconditionOpts,
    String? userProject,
  }) {
    return FileOptions(
      crc32cGenerator: crc32cGenerator ?? this.crc32cGenerator,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      generation: generation ?? this.generation,
      restoreToken: restoreToken ?? this.restoreToken,
      kmsKeyName: kmsKeyName ?? this.kmsKeyName,
      preconditionOpts: preconditionOpts ?? this.preconditionOpts,
      userProject: userProject ?? this.userProject,
    );
  }
}

class GetFilesOptions {
  final bool? autoPaginate;
  final String? delimiter;
  final String? endOffset;
  final bool? includeFoldersAsPrefixes;
  final bool? includeTrailingDelimiter;
  final String? prefix;
  final String? matchGlob;
  final int? maxApiCalls;
  final int? maxResults;
  final String? pageToken;
  final bool? softDeleted;
  final String? startOffset;
  final String? userProject;
  final bool? versions;
  final String? fields;

  const GetFilesOptions({
    this.autoPaginate = true,
    this.delimiter,
    this.endOffset,
    this.includeFoldersAsPrefixes,
    this.includeTrailingDelimiter,
    this.prefix,
    this.matchGlob,
    this.maxApiCalls,
    this.maxResults,
    this.pageToken,
    this.softDeleted,
    this.startOffset,
    this.userProject,
    this.versions,
    this.fields,
  });

  GetFilesOptions copyWith({
    bool? autoPaginate,
    String? delimiter,
    String? endOffset,
    bool? includeFoldersAsPrefixes,
    bool? includeTrailingDelimiter,
    String? prefix,
    String? matchGlob,
    int? maxApiCalls,
    int? maxResults,
    String? pageToken,
    bool? softDeleted,
    String? startOffset,
    String? userProject,
    bool? versions,
    String? fields,
  }) {
    return GetFilesOptions(
      autoPaginate: autoPaginate ?? this.autoPaginate,
      delimiter: delimiter ?? this.delimiter,
      endOffset: endOffset ?? this.endOffset,
      includeFoldersAsPrefixes:
          includeFoldersAsPrefixes ?? this.includeFoldersAsPrefixes,
      includeTrailingDelimiter:
          includeTrailingDelimiter ?? this.includeTrailingDelimiter,
      prefix: prefix ?? this.prefix,
      matchGlob: matchGlob ?? this.matchGlob,
      maxApiCalls: maxApiCalls ?? this.maxApiCalls,
      maxResults: maxResults ?? this.maxResults,
      pageToken: pageToken ?? this.pageToken,
      softDeleted: softDeleted ?? this.softDeleted,
      startOffset: startOffset ?? this.startOffset,
      userProject: userProject ?? this.userProject,
      versions: versions ?? this.versions,
      fields: fields ?? this.fields,
    );
  }
}

class DeleteFileOptions extends GetFilesOptions {
  final bool? force;
  // PreconditionOptions fields
  final int? ifGenerationMatch;
  final int? ifGenerationNotMatch;
  final int? ifMetagenerationMatch;
  final int? ifMetagenerationNotMatch;

  const DeleteFileOptions({
    this.force,
    // GetFilesOptions fields
    super.autoPaginate,
    super.delimiter,
    super.endOffset,
    super.includeFoldersAsPrefixes,
    super.includeTrailingDelimiter,
    super.prefix,
    super.matchGlob,
    super.maxApiCalls,
    super.maxResults,
    super.pageToken,
    super.softDeleted,
    super.startOffset,
    super.userProject,
    super.versions,
    super.fields,
    // PreconditionOptions fields
    this.ifGenerationMatch,
    this.ifGenerationNotMatch,
    this.ifMetagenerationMatch,
    this.ifMetagenerationNotMatch,
  });
}

class GetFileMetadataOptions {
  final String? userProject;

  const GetFileMetadataOptions({this.userProject});
}

class SetFileMetadataOptions extends PreconditionOptions {
  final String? userProject;

  const SetFileMetadataOptions({
    this.userProject,
    super.ifMetagenerationMatch,
    super.ifMetagenerationNotMatch,
    super.ifGenerationMatch,
    super.ifGenerationNotMatch,
  });
}

class CopyOptions {
  final String? cacheControl;
  final String? contentEncoding;
  final String? contentType;
  final String? contentDisposition;
  final String? destinationKmsKeyName;
  final Map<String, String>? metadata;
  final PredefinedAcl? predefinedAcl;
  final String? token;
  final String? userProject;
  final PreconditionOptions? preconditionOpts;

  const CopyOptions({
    this.cacheControl,
    this.contentEncoding,
    this.contentType,
    this.contentDisposition,
    this.destinationKmsKeyName,
    this.metadata,
    this.predefinedAcl,
    this.token,
    this.userProject,
    this.preconditionOpts,
  });
}

class MoveOptions {
  final String? userProject;
  final PreconditionOptions? preconditionOpts;

  const MoveOptions({this.userProject, this.preconditionOpts});
}

class RotateEncryptionKeyOptions {
  /// Customer-supplied encryption key.
  final EncryptionKey? encryptionKey;

  /// The name of the Cloud KMS key that will be used to encrypt the object.
  final String? kmsKeyName;

  /// Precondition options for the copy operation.
  final PreconditionOptions? preconditionOpts;

  const RotateEncryptionKeyOptions({
    this.encryptionKey,
    this.kmsKeyName,
    this.preconditionOpts,
  });
}

class MakeFilePrivateOptions {
  final FileMetadata? metadata;
  final bool? strict;
  final String? userProject;
  final PreconditionOptions? preconditionOpts;

  const MakeFilePrivateOptions({
    this.metadata,
    this.strict,
    this.userProject,
    this.preconditionOpts,
  });
}

class GetFileSignedUrlOptions {
  final Uri? host; // inherited from SignedUrlConfig
  final Uri? signingEndpoint; // inherited from SignedUrlConfig

  final String action;
  final SignedUrlVersion? version;
  final String? cname;
  final bool? virtualHostedStyle;
  final DateTime expires;
  final Map<String, String>? extensionHeaders;
  final Map<String, String>? queryParams;
  final String? contentMd5;
  final String? contentType;
  final String? promptSaveAs;
  final String? responseDisposition;
  final String? responseType;
  final DateTime? accessibleAt;

  const GetFileSignedUrlOptions({
    this.host,
    this.signingEndpoint,
    required this.action,
    this.version,
    this.cname,
    this.virtualHostedStyle = false,
    required this.expires,
    this.extensionHeaders,
    this.queryParams,
    this.contentMd5,
    this.contentType,
    this.promptSaveAs,
    this.responseDisposition,
    this.responseType,
    this.accessibleAt,
  });
}

class SetFileStorageClassOptions extends SetFileMetadataOptions {
  const SetFileStorageClassOptions({
    super.userProject,
    super.ifMetagenerationMatch,
    super.ifMetagenerationNotMatch,
    super.ifGenerationMatch,
    super.ifGenerationNotMatch,
  });
}

class RestoreFileOptions extends PreconditionOptions {
  final int generation;
  final String? restoreToken;
  final Projection? projection;
  final String? userProject;

  const RestoreFileOptions({
    required this.generation,
    this.restoreToken,
    this.projection,
    this.userProject,
    super.ifMetagenerationMatch,
    super.ifMetagenerationNotMatch,
    super.ifGenerationMatch,
    super.ifGenerationNotMatch,
  });
}

/// Validation type for data integrity checks during upload.
enum ValidationType {
  /// Validate using CRC32C checksum (default).
  crc32c,

  /// Validate using MD5 checksum.
  md5,

  /// Disable validation.
  none,
}

/// Progress information for an upload operation.
class UploadProgress {
  /// Number of bytes written so far.
  final int bytesWritten;

  /// Total number of bytes to upload, if known.
  final int? totalBytes;

  const UploadProgress._({required this.bytesWritten, this.totalBytes});
}

/// Options for creating a write stream to upload a file.
class CreateWriteStreamOptions {
  /// Content type of the file. If set to 'auto', the file name is used to determine the contentType.
  final String? contentType;

  /// If true, automatically gzip the file. If null, the contentType is used to determine if the file should be gzipped (auto-detect).
  final bool? gzip;

  /// Metadata for the file. See Objects: insert request body for details.
  final FileMetadata? metadata;

  /// The starting byte of the upload stream, for resuming an interrupted upload. Defaults to 0.
  final int? offset;

  /// Apply a predefined set of access controls to this object.
  final PredefinedAcl? predefinedAcl;

  /// Make the uploaded file private. (Alias for predefinedAcl = 'private')
  final bool? private;

  /// Make the uploaded file public. (Alias for predefinedAcl = 'publicRead')
  final bool? public;

  /// Force a resumable upload. Defaults to true.
  final bool? resumable;

  /// Set the HTTP request timeout in milliseconds. This option is not available for resumable uploads. Default: 60000
  final int? timeout;

  /// The URI for an already-created resumable upload. See File.createResumableUpload().
  final String? uri;

  /// The ID of the project which will be billed for the request.
  final String? userProject;

  /// Validation type for data integrity checks. By default, data integrity is validated with a CRC32c checksum.
  final ValidationType? validation;

  /// A CRC32C to resume from when continuing a previous upload.
  final String? resumeCRC32C;

  /// Precondition options for the upload.
  final PreconditionOptions? preconditionOpts;

  /// Chunk size for resumable uploads. Default: 256KB
  final int? chunkSize;

  /// High water mark for the stream. Controls buffer size.
  final int? highWaterMark;

  /// Whether this is a partial upload.
  final bool? isPartialUpload;

  /// Callback for upload progress events.
  final void Function(UploadProgress)? onUploadProgress;

  const CreateWriteStreamOptions({
    this.contentType,
    this.gzip,
    this.metadata,
    this.offset,
    this.predefinedAcl,
    this.private,
    this.public,
    this.resumable,
    this.timeout,
    this.uri,
    this.userProject,
    this.validation,
    this.resumeCRC32C,
    this.preconditionOpts,
    this.chunkSize,
    this.highWaterMark,
    this.isPartialUpload,
    this.onUploadProgress,
  });
}

/// Options for saving data to a file.
class SaveOptions extends CreateWriteStreamOptions {
  /// Callback for upload progress events.
  final void Function(UploadProgress)? onUploadProgress;

  const SaveOptions({
    super.contentType,
    super.gzip,
    super.metadata,
    super.offset,
    super.predefinedAcl,
    super.private,
    super.public,
    super.resumable,
    super.timeout,
    super.uri,
    super.userProject,
    super.validation,
    super.resumeCRC32C,
    super.preconditionOpts,
    super.chunkSize,
    super.highWaterMark,
    super.isPartialUpload,
    this.onUploadProgress,
  });
}

/// Options for creating a resumable upload URI.
class CreateResumableUploadOptions {
  /// Metadata for the file.
  final FileMetadata? metadata;

  /// The starting byte of the upload stream, for resuming an interrupted upload. Defaults to 0.
  final int? offset;

  /// Apply a predefined set of access controls to this object.
  final PredefinedAcl? predefinedAcl;

  /// Make the uploaded file private. (Alias for predefinedAcl = 'private')
  final bool? private;

  /// Make the uploaded file public. (Alias for predefinedAcl = 'publicRead')
  final bool? public;

  /// The URI for an already-created resumable upload.
  final String? uri;

  /// The ID of the project which will be billed for the request.
  final String? userProject;

  /// Precondition options for the upload.
  final PreconditionOptions? preconditionOpts;

  /// Chunk size for resumable uploads. Default: 256KB
  final int? chunkSize;

  /// High water mark for the stream. Controls buffer size.
  final int? highWaterMark;

  /// Whether this is a partial upload.
  final bool? isPartialUpload;

  const CreateResumableUploadOptions({
    this.metadata,
    this.offset,
    this.predefinedAcl,
    this.private,
    this.public,
    this.uri,
    this.userProject,
    this.preconditionOpts,
    this.chunkSize,
    this.highWaterMark,
    this.isPartialUpload,
  });
}

/// Options for creating a readable stream to download a file.
class CreateReadStreamOptions {
  /// The ID of the project which will be billed for the request.
  final String? userProject;

  /// Data integrity validation type.
  final ValidationType? validation;

  /// Start byte for range requests.
  final int? start;

  /// End byte for range requests. Negative values indicate tail requests.
  final int? end;

  /// Whether to decompress gzip content. Defaults to true.
  final bool? decompress;

  const CreateReadStreamOptions({
    this.userProject,
    this.validation,
    this.start,
    this.end,
    this.decompress,
  });
}

/// Options for downloading a file.
class DownloadOptions extends CreateReadStreamOptions {
  /// Local file to write the downloaded content to.
  final io.File? destination;

  /// Customer-supplied encryption key.
  final EncryptionKey? encryptionKey;

  const DownloadOptions({
    this.destination,
    this.encryptionKey,
    super.userProject,
    super.validation,
    super.start,
    super.end,
    super.decompress,
  });
}

/// Type alias for data that can be saved to a file.
typedef SaveData = Object; // String, Uint8List, List<int>, or Stream<List<int>>

class EncryptionKey {
  final String _keyBase64;
  final String _keyHash;

  EncryptionKey._(this._keyBase64, this._keyHash);

  /// Creates an EncryptionKey from a string.
  ///
  /// The string is converted to base64, and then a SHA256 hash is computed
  /// by decoding the base64 string back to bytes and hashing those bytes.
  /// The hash is then encoded as base64.
  factory EncryptionKey.fromString(String key) {
    // Convert string to bytes, then to base64
    // This mimics: Buffer.from(encryptionKey as string).toString('base64')
    final keyBytes = utf8.encode(key);
    final keyBase64 = base64.encode(keyBytes);

    // Create SHA256 hash by decoding the base64 string back to bytes and hashing
    // This mimics: crypto.createHash('sha256').update(this.encryptionKeyBase64, 'base64').digest('base64')
    final decodedBase64 = base64.decode(keyBase64);
    final hash = crypto.sha256.convert(decodedBase64);
    final keyHash = base64.encode(hash.bytes);

    return EncryptionKey._(keyBase64, keyHash);
  }

  /// Creates an EncryptionKey from a buffer (List<int>).
  ///
  /// The buffer is converted to base64, and then a SHA256 hash is computed
  /// by decoding the base64 string back to bytes and hashing those bytes.
  /// The hash is then encoded as base64.
  factory EncryptionKey.fromBuffer(List<int> buffer) {
    // Convert buffer to base64
    // This mimics: Buffer.from(encryptionKey).toString('base64')
    final keyBase64 = base64.encode(buffer);

    // Create SHA256 hash by decoding the base64 string back to bytes and hashing
    // This mimics: crypto.createHash('sha256').update(this.encryptionKeyBase64, 'base64').digest('base64')
    final decodedBase64 = base64.decode(keyBase64);
    final hash = crypto.sha256.convert(decodedBase64);
    final keyHash = base64.encode(hash.bytes);

    return EncryptionKey._(keyBase64, keyHash);
  }

  /// Gets the base64-encoded encryption key.
  String get keyBase64 => _keyBase64;

  /// Gets the base64-encoded SHA256 hash of the encryption key.
  String get keyHash => _keyHash;
}

/// Options when constructing an [HmacKey] handle.
class HmacKeyOptions {
  final String? projectId;

  const HmacKeyOptions({this.projectId});
}

class CreateHmacKeyOptions {
  final String? projectId;
  final String? userProject;

  const CreateHmacKeyOptions({this.projectId, this.userProject});
}

class GetHmacKeysOptions {
  final bool? autoPaginate;
  final String? projectId;
  final String? serviceAccountEmail;
  final bool? showDeletedKeys;
  final int? maxApiCalls;
  final int? maxResults;
  final String? pageToken;
  final String? userProject;

  const GetHmacKeysOptions({
    this.autoPaginate = true,
    this.projectId,
    this.userProject,
    this.serviceAccountEmail,
    this.showDeletedKeys,
    this.maxApiCalls,
    this.maxResults,
    this.pageToken,
  });

  GetHmacKeysOptions copyWith({
    bool? autoPaginate,
    String? projectId,
    String? serviceAccountEmail,
    bool? showDeletedKeys,
    int? maxApiCalls,
    int? maxResults,
    String? pageToken,
    String? userProject,
  }) {
    return GetHmacKeysOptions(
      autoPaginate: autoPaginate ?? this.autoPaginate,
      projectId: projectId ?? this.projectId,
      serviceAccountEmail: serviceAccountEmail ?? this.serviceAccountEmail,
      showDeletedKeys: showDeletedKeys ?? this.showDeletedKeys,
      maxApiCalls: maxApiCalls ?? this.maxApiCalls,
      maxResults: maxResults ?? this.maxResults,
      pageToken: pageToken ?? this.pageToken,
      userProject: userProject ?? this.userProject,
    );
  }
}

enum HmacKeyState {
  active('ACTIVE'),
  inactive('INACTIVE'),
  deleted('DELETED');

  final String value;
  const HmacKeyState(this.value);
}

/// Subset of HMAC metadata that can be updated, mirroring Node's
/// SetHmacKeyMetadata.
class SetHmacKeyMetadata extends storage_v1.HmacKeyMetadata {
  /// New state: 'ACTIVE' or 'INACTIVE'.
  SetHmacKeyMetadata({HmacKeyState? state, super.etag})
    : super(state: state?.value);
}

typedef HmacKeyMetadata = storage_v1.HmacKeyMetadata;

class GetPolicyOptions {
  final String? userProject;
  final int? requestedPolicyVersion;

  const GetPolicyOptions({this.userProject, this.requestedPolicyVersion});
}

class SetPolicyOptions {
  final String? userProject;

  const SetPolicyOptions({this.userProject});
}

class TestIamPermissionsOptions {
  final String? userProject;

  const TestIamPermissionsOptions({this.userProject});
}

typedef Policy = storage_v1.Policy;

class GetNotificationsOptions {
  final String? userProject;

  const GetNotificationsOptions({this.userProject});
}

typedef NotificationMetadata = storage_v1.Notification;

enum SignedUrlMethod {
  get('GET'),
  put('PUT'),
  delete('DELETE'),
  post('POST');

  const SignedUrlMethod(this.value);
  final String value;
}

enum SignedUrlVersion { v2, v4 }

/// Configuration for generating a signed URL, modeled after the Node SDK's
/// `SignerGetSignedUrlConfig` but simplified for v4 signing.
class SignedUrlConfig {
  final SignedUrlMethod method; // 'GET', 'PUT', etc.
  final DateTime expires;
  final DateTime? accessibleAt;
  final bool? virtualHostedStyle;
  final SignedUrlVersion? version;
  final String? cname;
  final Map<String, String>? extensionHeaders;
  final Map<String, String>? queryParams;
  final String? contentMd5;
  final String? contentType;
  final Uri? host;
  final Uri? signingEndpoint;

  const SignedUrlConfig({
    required this.method,
    required this.expires,
    this.accessibleAt,
    this.virtualHostedStyle,
    this.cname,
    this.version,
    this.extensionHeaders,
    this.queryParams,
    this.contentMd5,
    this.contentType,
    this.host,
    this.signingEndpoint,
  });
}

/// Sealed class for type-safe file/directory inputs for transfer operations.
sealed class TransferSource {
  const TransferSource._();

  /// Single file path.
  const factory TransferSource.file(String path) = _FileTransferSource;

  /// Multiple file paths.
  const factory TransferSource.files(List<String> paths) = _FilesTransferSource;

  /// Directory path (will be recursively walked).
  const factory TransferSource.directory(String path) =
      _DirectoryTransferSource;
}

final class _FileTransferSource extends TransferSource {
  final String path;
  const _FileTransferSource(this.path) : super._();
}

final class _FilesTransferSource extends TransferSource {
  final List<String> paths;
  const _FilesTransferSource(this.paths) : super._();
}

final class _DirectoryTransferSource extends TransferSource {
  final String path;
  const _DirectoryTransferSource(this.path) : super._();
}

/// Options for uploading many files.
class UploadManyFilesOptions {
  final int? concurrencyLimit;
  final String Function(String path, UploadManyFilesOptions options)?
  customDestinationBuilder;
  final bool? skipIfExists;
  final String? prefix;
  final Map<String, dynamic>? passthroughOptions;

  const UploadManyFilesOptions({
    this.concurrencyLimit,
    this.customDestinationBuilder,
    this.skipIfExists,
    this.prefix,
    this.passthroughOptions,
  });
}

/// Options for downloading many files.
class DownloadManyFilesOptions {
  final int? concurrencyLimit;
  final String? prefix;
  final String? stripPrefix;
  final Map<String, dynamic>? passthroughOptions;
  final bool? skipIfExists;

  const DownloadManyFilesOptions({
    this.concurrencyLimit,
    this.prefix,
    this.stripPrefix,
    this.passthroughOptions,
    this.skipIfExists,
  });
}

/// Options for uploading a file in chunks.
class UploadFileInChunksOptions {
  final int? concurrencyLimit;
  final int? chunkSizeBytes;
  final String? uploadName;
  final int? maxQueueSize;
  final String? uploadId;
  final bool? autoAbortFailure;
  final Map<int, String>? partsMap;
  final String? validation; // 'md5' or null/false
  final Map<String, String>? headers;

  const UploadFileInChunksOptions({
    this.concurrencyLimit,
    this.chunkSizeBytes,
    this.uploadName,
    this.maxQueueSize,
    this.uploadId,
    this.autoAbortFailure,
    this.partsMap,
    this.validation,
    this.headers,
  });
}

/// Options for downloading a file in chunks.
class DownloadFileInChunksOptions {
  final int? concurrencyLimit;
  final int? chunkSizeBytes;
  final String? destination;
  final String? validation; // 'crc32c' or null/false
  final bool? noReturnData;

  const DownloadFileInChunksOptions({
    this.concurrencyLimit,
    this.chunkSizeBytes,
    this.destination,
    this.validation,
    this.noReturnData,
  });
}
