import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../models/test_type_model.dart';
import '../providers/report_provider.dart';

class UploadReportScreen extends StatefulWidget {
  const UploadReportScreen({super.key});

  @override
  State<UploadReportScreen> createState() => _UploadReportScreenState();
}

class _UploadReportScreenState extends State<UploadReportScreen> {
  XFile? _selectedImage;
  String? _extractedText;
  bool _isProcessing = false;
  bool _isImageClear = true;

  TestType? _selectedTestType;
  final _reportDateController = TextEditingController();
  final _labNameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  TextRecognizer? _textRecognizer;

  @override
  void initState() {
    super.initState();
    // Only initialize ML Kit on mobile platforms
    if (!kIsWeb) {
      _textRecognizer = TextRecognizer();
    }
  }

  @override
  void dispose() {
    _reportDateController.dispose();
    _labNameController.dispose();
    _textRecognizer?.close();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        await _processImage(image);
      }
    } catch (e) {
      _showError('Failed to capture image: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        await _processImage(image);
      }
    } catch (e) {
      _showError('Failed to select image: $e');
    }
  }

  Future<void> _processImage(XFile imageFile) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Check file size (limit to 5MB)
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        _showError('File size exceeds 5MB limit');
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      // Validate image clarity and extract text (only on mobile)
      if (!kIsWeb) {
        final file = File(imageFile.path);
        await _validateImageClarity(file);
        await _extractTextFromImage(file);
      } else {
        setState(() {
          _isImageClear = true;
          _extractedText =
              'OCR not available on web. Please use Android or iOS device for text extraction.';
        });
      }

      setState(() {
        _selectedImage = imageFile;
        _isProcessing = false;
      });
    } catch (e) {
      _showError('Failed to process image: $e');
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _validateImageClarity(File imageFile) async {
    try {
      // Using ML Kit Image Labeling to check if image is clear
      final inputImage = InputImage.fromFile(imageFile);
      final imageLabeler = ImageLabeler(
        options: ImageLabelerOptions(confidenceThreshold: 0.5),
      );

      final labels = await imageLabeler.processImage(inputImage);

      // Check for blur or unclear indicators
      final hasDocumentLabel = labels.any(
        (label) =>
            label.label.toLowerCase().contains('document') ||
            label.label.toLowerCase().contains('text') ||
            label.label.toLowerCase().contains('paper'),
      );

      setState(() {
        _isImageClear = hasDocumentLabel || labels.length > 3;
      });

      await imageLabeler.close();
    } catch (e) {
      // If image labeling fails, assume image is acceptable
      setState(() {
        _isImageClear = true;
      });
    }
  }

  Future<void> _extractTextFromImage(File imageFile) async {
    try {
      if (_textRecognizer == null) return;

      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText =
          await _textRecognizer!.processImage(inputImage);

      final StringBuffer extractedText = StringBuffer();

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          extractedText.writeln(line.text);
        }
      }

      setState(() {
        _extractedText = extractedText.toString();
      });
    } catch (e) {
      _showError('Failed to extract text: $e');
      setState(() {
        _extractedText = 'Failed to extract text from image';
      });
    }
  }

  Future<void> _submitReport() async {
    if (_selectedImage == null) {
      _showError('Please select an image');
      return;
    }

    if (_selectedTestType == null) {
      _showError('Please select a test type');
      return;
    }

    if (_reportDateController.text.isEmpty) {
      _showError('Please select report date');
      return;
    }

    if (!_isImageClear) {
      final confirm = await _showConfirmDialog(
        'Image Quality Warning',
        'The selected image may not be clear. Do you want to proceed anyway?',
      );
      if (!confirm) return;
    }

    final reportProvider = context.read<ReportProvider>();
    final success = await reportProvider.uploadReport(
      testType: _selectedTestType!.id,
      testName: _selectedTestType!.name,
      reportDate: DateTime.parse(_reportDateController.text),
      imagePath: _selectedImage!.path,
      extractedText: _extractedText,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report uploaded successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      _showError('Failed to upload report');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Selection
            _buildImageSelector(),

            if (_selectedImage != null) ...[
              const SizedBox(height: 24),

              // Image Preview
              _buildImagePreview(),

              const SizedBox(height: 24),

              // Test Type Selection
              _buildTestTypeSelector(),

              const SizedBox(height: 16),

              // Report Date
              _buildDateSelector(),

              const SizedBox(height: 16),

              // Lab Name (Optional)
              TextField(
                controller: _labNameController,
                decoration: const InputDecoration(
                  labelText: 'Lab Name (Optional)',
                  hintText: 'Enter lab name',
                  prefixIcon: Icon(Icons.business),
                ),
              ),

              const SizedBox(height: 24),

              // Extracted Text Preview
              if (_extractedText != null && _extractedText!.isNotEmpty)
                _buildExtractedTextPreview(),

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isProcessing ? null : _submitReport,
                child: const Text('Submit Report'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    if (_selectedImage == null) {
      return Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.upload_file,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Upload Medical Report',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Select an image of your medical report',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _pickImageFromCamera,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take Photo'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickImageFromGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text('Choose from Gallery'),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Image',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                  _extractedText = null;
                  _isImageClear = true;
                });
              },
              icon: const Icon(Icons.close),
              label: const Text('Remove'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: kIsWeb
              ? Image.network(
                  _selectedImage!.path,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(_selectedImage!.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        if (!_isImageClear) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber, color: AppColors.warning),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Image quality may be low. Consider retaking the photo.',
                    style: TextStyle(color: AppColors.warning),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_isProcessing) ...[
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          const Text(
            'Processing image and extracting text...',
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildTestTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Test Type *',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TestType>(
          initialValue: _selectedTestType,
          decoration: const InputDecoration(
            hintText: 'Choose test type',
            prefixIcon: Icon(Icons.medical_services),
          ),
          items: TestTypeData.availableTests.map((test) {
            return DropdownMenuItem(
              value: test,
              child: Text(test.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedTestType = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return TextField(
      controller: _reportDateController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Report Date *',
        hintText: 'Select date',
        prefixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );

        if (date != null) {
          setState(() {
            _reportDateController.text = date.toIso8601String().split('T')[0];
          });
        }
      },
    );
  }

  Widget _buildExtractedTextPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Extracted Text Preview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: SingleChildScrollView(
            child: Text(
              _extractedText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
