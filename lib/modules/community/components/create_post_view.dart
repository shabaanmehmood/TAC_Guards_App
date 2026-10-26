import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/routes/app_routes.dart';
import '../community_service.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({
    super.key,
    required this.service,
    required this.topics,
    required this.onPostingDenied,
    required this.onInactive,
  });

  final CommunityService service;
  final List<Map<String, dynamic>> topics;
  final VoidCallback onPostingDenied;
  final VoidCallback onInactive;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _images = [];
  final Map<String, Uint8List> _thumbnailBytes = {};
  String? _topicId;
  String? _jobId;
  String? _error;
  bool _submitting = false;
  bool _loadingJobs = false;
  List<dynamic> _openJobs = [];
  bool _isFabExpanded = true;
  Timer? _collapseTimer;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      if (mounted) setState(() {});
    });
    if (widget.service.accountType == 'contractor') {
      _loadOpenJobs();
    }
    _collapseTimer = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        setState(() {
          _isFabExpanded = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    _textController.dispose();
    _thumbnailBytes.clear();
    super.dispose();
  }

  String get _selectedTopicName {
    if (_topicId == null) return 'No topic';
    final found = widget.topics.firstWhereOrNull((t) => t['id'] == _topicId);
    return found?['name'] as String? ?? 'No topic';
  }

  String get _selectedJobTitle {
    if (_jobId == null) return 'No job attached';
    final found = _openJobs.firstWhereOrNull((j) =>
        (j is Map ? (j['jobId'] ?? j['id']) : (j as dynamic).jobId) == _jobId);
    if (found == null) return 'No job attached';
    final title = found is Map ? (found['jobTitle'] ?? found['title'] ?? 'Job') : (found as dynamic).jobTitle;
    final rate = found is Map ? found['payPerHour'] : (found as dynamic).payPerHour;
    return rate != null ? '$title · \$$rate/hr' : '$title';
  }

  Future<void> _loadOpenJobs() async {
    setState(() => _loadingJobs = true);
    try {
      final jobs = await widget.service.fetchOpenOwnedJobs();
      if (mounted) setState(() => _openJobs = jobs);
    } catch (_) {
      if (mounted) setState(() => _openJobs = []);
    } finally {
      if (mounted) setState(() => _loadingJobs = false);
    }
  }

  void _showNotice(String title, String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.kJobCardColor,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.kSkyBlue.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            const Icon(Icons.info_outline_rounded,
                color: AppColors.kSkyBlue, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTopicPickerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.72,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: const BoxDecoration(
            color: AppColors.kJobCardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  'Select Topic',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: _topicId == null
                    ? AppColors.kSkyBlue.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.04),
                leading: Icon(
                  Icons.tag_rounded,
                  color: _topicId == null ? AppColors.kSkyBlue : Colors.white60,
                ),
                title: Text(
                  'No topic',
                  style: TextStyle(
                    color: _topicId == null ? AppColors.kSkyBlue : Colors.white,
                    fontWeight:
                        _topicId == null ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
                trailing: _topicId == null
                    ? const Icon(Icons.check_circle, color: AppColors.kSkyBlue)
                    : null,
                onTap: () {
                  setState(() => _topicId = null);
                  Navigator.of(sheetContext).pop();
                },
              ),
              const SizedBox(height: 8),
              if (widget.topics.isNotEmpty)
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.topics.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final topic = widget.topics[index];
                      final id = topic['id'] as String?;
                      final name = topic['name'] as String? ?? 'Topic';
                      final isSelected = _topicId == id;
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: isSelected
                            ? AppColors.kSkyBlue.withValues(alpha: 0.12)
                            : Colors.white.withValues(alpha: 0.04),
                        leading: Icon(
                          Icons.tag_rounded,
                          color:
                              isSelected ? AppColors.kSkyBlue : Colors.white60,
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            color:
                                isSelected ? AppColors.kSkyBlue : Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle,
                                color: AppColors.kSkyBlue)
                            : null,
                        onTap: () {
                          setState(() => _topicId = id);
                          Navigator.of(sheetContext).pop();
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJobPickerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.72,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: const BoxDecoration(
            color: AppColors.kJobCardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  'Attach Open Job',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: _jobId == null
                    ? AppColors.kSkyBlue.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.04),
                leading: Icon(
                  Icons.work_off_outlined,
                  color: _jobId == null ? AppColors.kSkyBlue : Colors.white60,
                ),
                title: Text(
                  'No job attached',
                  style: TextStyle(
                    color: _jobId == null ? AppColors.kSkyBlue : Colors.white,
                    fontWeight:
                        _jobId == null ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
                trailing: _jobId == null
                    ? const Icon(Icons.check_circle, color: AppColors.kSkyBlue)
                    : null,
                onTap: () {
                  setState(() => _jobId = null);
                  Navigator.of(sheetContext).pop();
                },
              ),
              const SizedBox(height: 8),
              if (_loadingJobs)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.kSkyBlue),
                  ),
                )
              else if (_openJobs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'No open jobs available to attach',
                      style:
                          TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _openJobs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final job = _openJobs[index];
                      final isSelected = _jobId == job.jobId;
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: isSelected
                            ? AppColors.kSkyBlue.withValues(alpha: 0.12)
                            : Colors.white.withValues(alpha: 0.04),
                        leading: Icon(
                          Icons.work_outline_rounded,
                          color:
                              isSelected ? AppColors.kSkyBlue : Colors.white60,
                        ),
                        title: Text(
                          job.jobTitle,
                          style: TextStyle(
                            color:
                                isSelected ? AppColors.kSkyBlue : Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          '${job.jobLocation} · \$${job.payPerHour}/hr',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle,
                                color: AppColors.kSkyBlue)
                            : null,
                        onTap: () {
                          setState(() => _jobId = job.jobId);
                          Navigator.of(sheetContext).pop();
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final remaining = 4 - _images.length;
    if (remaining <= 0) {
      _showNotice(
        'Maximum images attached',
        'You can attach up to 4 images per post. Remove an image to add a new one.',
      );
      return;
    }

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: AppColors.kJobCardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kSkyBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: AppColors.kSkyBlue, size: 22),
                ),
                title: const Text(
                  'Choose from gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kSkyBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: AppColors.kSkyBlue, size: 22),
                ),
                title: const Text(
                  'Take a photo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    List<XFile> selected = [];
    try {
      if (source == ImageSource.gallery) {
        if (remaining == 1) {
          final single = await _imagePicker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
          );
          if (single != null) selected = [single];
        } else {
          selected = await _imagePicker.pickMultiImage(imageQuality: 85);
        }
      } else {
        final photo = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (photo != null) selected = [photo];
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }

    if (!mounted || selected.isEmpty) return;

    final accepted = <XFile>[];
    for (final image in selected) {
      final fullName = image.path.isNotEmpty ? image.path : image.name;
      final hasDot = fullName.contains('.');
      final extension = hasDot ? fullName.split('.').last.toLowerCase() : 'jpg';

      if (hasDot &&
          !{'jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'}.contains(extension)) {
        continue;
      }
      if (accepted.length < remaining) {
        accepted.add(image);
      }
    }

    for (final image in accepted) {
      try {
        final bytes = await image.readAsBytes();
        final key = image.path.isNotEmpty ? image.path : image.name;
        _thumbnailBytes[key] = bytes;
      } catch (_) {}
    }

    setState(() {
      _images.addAll(accepted);
      _error = null;
    });

    if (selected.length > remaining) {
      _showNotice(
        'Image limit',
        'Maximum 4 images allowed per post. Added ${accepted.length} image(s).',
      );
    }
  }

  Future<void> _submit() async {
    final text = _textController.text.trim();
    if (text.isEmpty || text.length > 2000) {
      setState(
          () => _error = 'Post text must be between 1 and 2000 characters.');
      return;
    }
    if (_images.length > 4) {
      setState(() => _error = 'A post can include up to 4 images.');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final dataUris = <String>[];
      for (final image in _images) {
        final fullName = image.path.isNotEmpty ? image.path : image.name;
        final hasDot = fullName.contains('.');
        final extension =
            hasDot ? fullName.split('.').last.toLowerCase() : 'jpeg';
        final mimeType = switch (extension) {
          'jpg' || 'jpeg' => 'image/jpeg',
          'png' => 'image/png',
          'webp' => 'image/webp',
          _ => 'image/jpeg',
        };
        Uint8List bytes;
        try {
          if (image.path.isNotEmpty) {
            final compressed = await FlutterImageCompress.compressWithFile(
              image.path,
              minWidth: 1280,
              minHeight: 1280,
              quality: 75,
              format: mimeType == 'image/png'
                  ? CompressFormat.png
                  : mimeType == 'image/webp'
                      ? CompressFormat.webp
                      : CompressFormat.jpeg,
            );
            bytes = compressed ?? await image.readAsBytes();
          } else {
            bytes = await image.readAsBytes();
          }
        } catch (_) {
          bytes = await image.readAsBytes();
        }
        dataUris.add('data:$mimeType;base64,${base64Encode(bytes)}');
      }
      final post = await widget.service.createPost(
        text: text,
        images: dataUris,
        topicId: _topicId,
        jobId: _jobId,
      );
      if (mounted) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(post);
        } else {
          Get.back(result: post);
        }
      }
    } on CommunityApiException catch (exception) {
      if (!mounted) return;
      if (exception.statusCode == 401) {
        Get.offAllNamed(AppRoutes.signIn);
        return;
      }
      if (exception.statusCode == 403 &&
          exception.message == 'Account is inactive') {
        widget.onInactive();
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          Get.back();
        }
        return;
      }
      if (exception.statusCode == 403 &&
          exception.message == 'Only verified accounts can post') {
        widget.onPostingDenied();
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          Get.back();
        }
        return;
      }
      setState(() {
        _submitting = false;
        _error = exception.message;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = 'Could not create the post. Check your connection.';
        });
      }
    }
  }

  Widget _buildSingleThumbnail(XFile image, int index,
      {BoxFit fit = BoxFit.cover}) {
    final key = image.path.isNotEmpty ? image.path : image.name;
    final cachedBytes = _thumbnailBytes[key];

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: cachedBytes != null
              ? Image.memory(
                  cachedBytes,
                  fit: fit,
                )
              : Container(
                  color: AppColors.kJobCardColor,
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.kSkyBlue,
                      ),
                    ),
                  ),
                ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: () {
              setState(() {
                final removed = _images.removeAt(index);
                final remKey =
                    removed.path.isNotEmpty ? removed.path : removed.name;
                _thumbnailBytes.remove(remKey);
                _error = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.72),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCollage() {
    if (_images.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.photo_library_rounded,
                  color: AppColors.kSkyBlue, size: 17),
              const SizedBox(width: 8),
              Text(
                'Attached Images (${_images.length}/4)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final count = _images.length;

              if (count == 1) {
                return SizedBox(
                  height: 230,
                  width: double.infinity,
                  child: _buildSingleThumbnail(_images[0], 0),
                );
              }

              if (count == 2) {
                return SizedBox(
                  height: 190,
                  child: Row(
                    children: [
                      Expanded(child: _buildSingleThumbnail(_images[0], 0)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildSingleThumbnail(_images[1], 1)),
                    ],
                  ),
                );
              }

              if (count == 3) {
                return SizedBox(
                  height: 230,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildSingleThumbnail(_images[0], 0),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(child: _buildSingleThumbnail(_images[1], 1)),
                            const SizedBox(height: 8),
                            Expanded(child: _buildSingleThumbnail(_images[2], 2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // 4 Images: Option A - 1 Big Featured on Left (60%), 3 Stacked in Column on Right (40%)
              return SizedBox(
                height: 260,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildSingleThumbnail(_images[0], 0),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(child: _buildSingleThumbnail(_images[1], 1)),
                          const SizedBox(height: 6),
                          Expanded(child: _buildSingleThumbnail(_images[2], 2)),
                          const SizedBox(height: 6),
                          Expanded(child: _buildSingleThumbnail(_images[3], 3)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPost = _textController.text.trim().isNotEmpty && !_submitting;

    return PopScope(
      canPop: !_submitting,
      child: Scaffold(
        backgroundColor: AppColors.kDarkBlue,
        appBar: AppBar(
          backgroundColor: AppColors.kDarkBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Create post',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: canPost ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kSkyBlue,
                    disabledBackgroundColor: Colors.white.withValues(alpha: 0.12),
                    foregroundColor: AppColors.kBlack,
                    disabledForegroundColor: Colors.white38,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.kBlack,
                          ),
                        )
                      : const Text(
                          'Post',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: (_submitting || _images.length >= 4)
            ? null
            : Material(
                color: Colors.transparent,
                elevation: 6,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _pickImages,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.kSkyBlue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.28),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 56,
                          height: 56,
                          child: Center(
                            child: Icon(
                              Icons.add_photo_alternate_rounded,
                              color: AppColors.kBlack,
                              size: 26,
                            ),
                          ),
                        ),
                        ClipRect(
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                            alignment: Alignment.centerLeft,
                            widthFactor: _isFabExpanded ? 1.0 : 0.0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 320),
                              curve: Curves.easeInOut,
                              opacity: _isFabExpanded ? 1.0 : 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Text(
                                  _images.isEmpty
                                      ? 'Add Images'
                                      : 'Add Images (${_images.length}/4)',
                                  style: const TextStyle(
                                    color: AppColors.kBlack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
              children: [
                // 1. TOPIC (Sleek Bottom Sheet Selector - No clunky dropdown popup)
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _showTopicPickerSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.kJobCardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _topicId != null
                            ? AppColors.kSkyBlue.withValues(alpha: 0.45)
                            : Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tag_rounded,
                          color:
                              _topicId != null ? AppColors.kSkyBlue : Colors.white60,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Topic',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 11.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _selectedTopicName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            color: AppColors.kSkyBlue, size: 22),
                      ],
                    ),
                  ),
                ),

                // 2. ATTACH OPEN JOB (Sleek Bottom Sheet Selector - Completely stable, no flickering/disappearing)
                if (widget.service.accountType == 'contractor') ...[
                  const SizedBox(height: 12),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _showJobPickerSheet,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        color: AppColors.kJobCardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _jobId != null
                              ? AppColors.kSkyBlue.withValues(alpha: 0.45)
                              : Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.work_outline_rounded,
                            color:
                                _jobId != null ? AppColors.kSkyBlue : Colors.white60,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Attach open job (Optional)',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 11.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _selectedJobTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (_loadingJobs)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.kSkyBlue,
                              ),
                            )
                          else
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                color: AppColors.kSkyBlue, size: 22),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // 3. TEXT FIELD (Large & spacious, professional)
                TextField(
                  controller: _textController,
                  autofocus: true,
                  maxLength: 2000,
                  maxLines: 15,
                  minLines: 8,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15, height: 1.45),
                  decoration: InputDecoration(
                    hintText: 'What would you like to share?',
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 15),
                    filled: true,
                    fillColor: AppColors.kJobCardColor,
                    counterText: '',
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.kSkyBlue, width: 1.5),
                    ),
                  ),
                ),

                // 4. IMAGE COLLAGE PREVIEW (Option A with "Attached Images" header)
                _buildImageCollage(),

                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.redAccent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            if (_submitting)
              Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.65),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 24),
                        decoration: BoxDecoration(
                          color: AppColors.kJobCardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.kSkyBlue.withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 38,
                              height: 38,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.kSkyBlue),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Publishing post...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Please wait a moment',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
