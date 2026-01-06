/// Helper utilities for image operations
/// 
/// Provides functions for image picking, compression, and validation.
library;

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../constants/app_constants.dart';
import '../errors/app_exceptions.dart';
import '../logging/app_logger.dart';

/// Helper class for image operations
class ImageHelper {
  static final ImagePicker _picker = ImagePicker();
  
  /// Pick an image from gallery or camera
  /// 
  /// [source] - ImageSource.gallery or ImageSource.camera
  /// Returns the path to the selected image, or null if cancelled
  static Future<String?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      AppLogger.d('Picking image from ${source == ImageSource.gallery ? "gallery" : "camera"}');
      
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: AppConstants.maxImageWidth.toDouble(),
        maxHeight: AppConstants.maxImageHeight.toDouble(),
        imageQuality: (AppConstants.imageQuality * 100).toInt(),
      );
      
      if (image == null) {
        AppLogger.d('Image picker cancelled');
        return null;
      }
      
      // Validate image size
      final file = File(image.path);
      final fileSize = await file.length();
      
      if (fileSize > AppConstants.maxImageSizeBytes) {
        AppLogger.w('Image file too large: ${fileSize} bytes');
        throw ImageException.fileTooLarge();
      }
      
      // Compress image if needed
      final compressedPath = await compressImage(image.path);
      
      AppLogger.i('Image picked successfully: $compressedPath');
      return compressedPath;
    } catch (e, stackTrace) {
      if (e is ImageException) {
        rethrow;
      }
      AppLogger.e('Error picking image', e, stackTrace);
      throw ImageException.uploadFailed();
    }
  }
  
  /// Compress an image file
  /// 
  /// [imagePath] - Path to the image file
  /// Returns the path to the compressed image
  static Future<String> compressImage(String imagePath) async {
    try {
      AppLogger.d('Compressing image: $imagePath');
      
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = path.basename(imagePath);
      final targetPath = path.join(tempDir.path, 'compressed_$fileName');
      
      // Compress image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        targetPath,
        quality: (AppConstants.imageQuality * 100).toInt(),
        minWidth: 800,
        minHeight: 600,
      );
      
      if (compressedFile == null) {
        AppLogger.w('Image compression returned null, using original');
        return imagePath;
      }
      
      AppLogger.d('Image compressed: ${compressedFile.path}');
      return compressedFile.path;
    } catch (e) {
      AppLogger.w('Error compressing image, using original', e);
      // Return original path if compression fails
      return imagePath;
    }
  }
  
  /// Validate image file
  /// 
  /// [filePath] - Path to the image file
  /// Throws ImageException if validation fails
  static Future<void> validateImage(String filePath) async {
    final file = File(filePath);
    
    if (!await file.exists()) {
      throw ImageException('Image file does not exist.', code: 'FILE_NOT_FOUND');
    }
    
    final fileSize = await file.length();
    if (fileSize > AppConstants.maxImageSizeBytes) {
      throw ImageException.fileTooLarge();
    }
    
    // Check file extension
    final extension = path.extension(filePath).toLowerCase();
    final allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    if (!allowedExtensions.contains(extension)) {
      throw ImageException.invalidFormat();
    }
  }
  
  /// Get image file size in MB
  static Future<double> getImageSizeMB(String filePath) async {
    final file = File(filePath);
    final size = await file.length();
    return size / (1024 * 1024);
  }
}

