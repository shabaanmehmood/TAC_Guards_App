import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import '../community_service.dart';

class LinkedInPostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final CommunityService service;
  final String Function(String?) accountLabel;
  final String Function(String?) dateLabel;
  final bool isFollowed;
  final bool canFollow;
  final VoidCallback onFollowToggle;
  final VoidCallback onOpenThread;
  final Function(String) onReact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReport;
  final Function(Map<String, dynamic>) onOpenJob;
  final bool canEdit;
  final bool ownPost;
  final bool isReported;

  const LinkedInPostCard({
    Key? key,
    required this.post,
    required this.service,
    required this.accountLabel,
    required this.dateLabel,
    required this.isFollowed,
    required this.canFollow,
    required this.onFollowToggle,
    required this.onOpenThread,
    required this.onReact,
    required this.onEdit,
    required this.onDelete,
    required this.onReport,
    required this.onOpenJob,
    required this.canEdit,
    required this.ownPost,
    required this.isReported,
  }) : super(key: key);

  @override
  State<LinkedInPostCard> createState() => _LinkedInPostCardState();
}

class _LinkedInPostCardState extends State<LinkedInPostCard> {
  int _currentImageIndex = 0;
  bool _showReactionPicker = false;
  bool _isTextExpanded = false;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _getReactionColor(String? reaction) => switch (reaction) {
        'useful' => Colors.amber,
        'support' => const Color(0xFFFF6584),
        _ => AppColors.kSkyBlue,
      };

  IconData _getReactionIcon(String? reaction) => switch (reaction) {
        'like' => Icons.thumb_up,
        'useful' => Icons.lightbulb_rounded,
        'support' => Icons.volunteer_activism_rounded,
        _ => Icons.thumb_up_outlined,
      };

  String _getReactionLabel(String? reaction) => switch (reaction) {
        'like' => 'Like',
        'useful' => 'Useful',
        'support' => 'Support',
        _ => 'Like',
      };

  Widget _buildReactionOption(
      String type, String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() => _showReactionPicker = false);
        widget.onReact(type);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openImageViewer(int initialIndex, List<String> imagePaths) async {
    if (imagePaths.isEmpty) return;
    int currentIndex = initialIndex;
    final pageController = PageController(initialPage: initialIndex);

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Image Viewer',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Stack(
                    children: [
                      // Swipable Interactive Image PageView
                      PageView.builder(
                        controller: pageController,
                        itemCount: imagePaths.length,
                        onPageChanged: (idx) {
                          setDialogState(() => currentIndex = idx);
                        },
                        itemBuilder: (context, idx) {
                          final imgUrl =
                              widget.service.imageUrl(imagePaths[idx]);
                          return Center(
                            child: InteractiveViewer(
                              minScale: 1.0,
                              maxScale: 3.5,
                              clipBehavior: Clip.none,
                              child: CachedNetworkImage(
                                imageUrl: imgUrl,
                                fit: BoxFit.contain,
                                placeholder: (_, __) => const Center(
                                  child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.kSkyBlue,
                                    ),
                                  ),
                                ),
                                errorWidget: (_, __, ___) => const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    color: Colors.white38,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Top Bar: Close Button + Image Counter Badge
                      Positioned(
                        top: 12,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Close Button
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => Navigator.pop(dialogContext),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),

                            // Top-Right Counter Pill Badge (e.g. 1/4)
                            if (imagePaths.length > 1)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '${currentIndex + 1}/${imagePaths.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Bottom Dots Indicator (if multiple images)
                      if (imagePaths.length > 1)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              imagePaths.length,
                              (idx) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: currentIndex == idx ? 18 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: currentIndex == idx
                                      ? AppColors.kSkyBlue
                                      : Colors.white38,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
    );
    pageController.dispose();
  }

  Future<void> _showUnfollowSheet(BuildContext context, String fullName) async {
    final trimmed = fullName.trim();
    final firstName =
        trimmed.isNotEmpty ? trimmed.split(' ').first : 'this user';
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                  width: 44,
                  height: 4.5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Text(
                'Unfollow $firstName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14.5,
                    height: 1.45,
                  ),
                  children: [
                    const TextSpan(text: 'Stop seeing activity from '),
                    TextSpan(
                      text: firstName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(text: ' on your feed. '),
                    TextSpan(
                      text: firstName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(
                      text: " won't be notified that you've unfollowed.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kSkyBlue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                        onPressed: () => Navigator.pop(sheetContext, true),
                        child: const Text(
                          'Unfollow',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.kSkyBlue,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                        onPressed: () => Navigator.pop(sheetContext, false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.kSkyBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      widget.onFollowToggle();
    }
  }

  Future<void> _showPostActionsSheet(BuildContext context) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: const BoxDecoration(
            color: AppColors.kJobCardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (widget.canEdit)
                ListTile(
                  leading: const Icon(Icons.edit_outlined,
                      color: Colors.white, size: 22),
                  title: const Text(
                    'Edit post',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'Edit text and audience topic',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'edit'),
                ),
              if (widget.ownPost)
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded,
                      color: Colors.redAccent, size: 22),
                  title: const Text(
                    'Delete post',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'Permanently remove this post from the feed',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'delete'),
                ),
              if (!widget.ownPost && !widget.isReported)
                ListTile(
                  leading: const Icon(Icons.flag_outlined,
                      color: Colors.white70, size: 22),
                  title: const Text(
                    'Report post',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'Flag this post if it violates community policies',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'report'),
                )
              else if (!widget.ownPost && widget.isReported)
                ListTile(
                  leading: const Icon(Icons.flag_rounded,
                      color: Colors.amber, size: 22),
                  title: const Text(
                    'Reported',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'You have already reported this post for review',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => Navigator.pop(sheetContext),
                ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );

    if (action == 'edit') {
      widget.onEdit();
    } else if (action == 'delete') {
      widget.onDelete();
    } else if (action == 'report') {
      widget.onReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    final author = widget.post['author'] is Map
        ? Map<String, dynamic>.from(widget.post['author'] as Map)
        : const <String, dynamic>{};
    final topic = widget.post['topic'] is Map
        ? Map<String, dynamic>.from(widget.post['topic'] as Map)
        : null;
    final counts = widget.post['counts'] is Map
        ? Map<String, dynamic>.from(widget.post['counts'] as Map)
        : const <String, dynamic>{};
    final imagePaths = widget.post['images'] is List
        ? (widget.post['images'] as List).whereType<String>().toList()
        : <String>[];
    final currentReaction = widget.post['myReaction'] as String?;

    final profileImagePath = author['profileImage'] as String?;
    final avatarUrl = profileImagePath != null && profileImagePath.isNotEmpty
        ? widget.service.imageUrl(profileImagePath)
        : null;

    final reactionCount = counts['reactions'] as num? ?? 0;
    final commentCount = counts['comments'] as num? ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              color: AppColors.kJobCardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Author Avatar, Name, Follow, Subtitles & Actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Professional LinkedIn Avatar with crisp circular mask & border
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.kDarkBlue,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: (avatarUrl != null && avatarUrl.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: avatarUrl,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  color: AppColors.kDarkBlue,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.kSkyBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (_, __, ___) => const Icon(
                                  Icons.person,
                                  color: Colors.white70,
                                  size: 24,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.white70,
                                size: 24,
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  author['name'] as String? ??
                                      'Community member',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                widget.accountLabel(author['type'] as String?),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.65),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (author['professionalBadge'] != null &&
                                  (author['professionalBadge'] as String).isNotEmpty) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.kSkyBlue.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppColors.kSkyBlue.withValues(alpha: 0.4),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    author['professionalBadge'] as String,
                                    style: const TextStyle(
                                      color: AppColors.kSkyBlue,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                widget.dateLabel(
                                    widget.post['createdAt'] as String?),
                                style: TextStyle(
                                  color:
                                      Colors.white.withValues(alpha: 0.45),
                                  fontSize: 11.5,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.public,
                                size: 11.5,
                                color: Colors.white.withValues(alpha: 0.45),
                              ),
                              if (widget.post['editedAt'] != null) ...[
                                Text(
                                  ' · Edited',
                                  style: TextStyle(
                                    color: Colors.white
                                        .withValues(alpha: 0.45),
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Top Right: Follow / Following (Aligned with author name)
                    if (widget.canFollow)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (widget.isFollowed) {
                            _showUnfollowSheet(
                                context, author['name'] as String? ?? 'this user');
                          } else {
                            widget.onFollowToggle();
                          }
                        },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 1, bottom: 4),
                              child: widget.isFollowed
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.check_rounded,
                                          size: 16,
                                          color: Colors.white70,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Following',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.add_rounded,
                                          size: 17,
                                          color: AppColors.kSkyBlue,
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          'Follow',
                                          style: TextStyle(
                                            color: AppColors.kSkyBlue,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                      ],
                    ),

                    // Topic Tag (#TopicName text only, LinkedIn style)
                    if (topic != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        '#${topic['name'] as String? ?? ''}',
                        style: const TextStyle(
                          color: AppColors.kSkyBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],

                    // Post Text Content with "...see more"
                    if ((widget.post['text'] as String? ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          final text = widget.post['text'] as String;
                          final isLong = text.length > 130 ||
                              '\n'.allMatches(text).length >= 3;
                          if (!isLong || _isTextExpanded) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.5,
                                    height: 1.45,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                                if (isLong && _isTextExpanded)
                                  GestureDetector(
                                    onTap: () => setState(
                                        () => _isTextExpanded = false),
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 4),
                                      child: Text(
                                        'see less',
                                        style: TextStyle(
                                          color: AppColors.kSkyBlue,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  height: 1.45,
                                  letterSpacing: 0.15,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _isTextExpanded = true),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    '...see more',
                                    style: TextStyle(
                                      color: AppColors.kSkyBlue,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],

                    // Job Card Link (if attached)
                    if (widget.post['job'] is Map) ...[
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => widget.onOpenJob(
                            Map<String, dynamic>.from(
                                widget.post['job'] as Map)),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.kDarkBlue,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.kSkyBlue
                                  .withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.kSkyBlue
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.work_outline_rounded,
                                    color: AppColors.kSkyBlue, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.post['job']['title']
                                              as String? ??
                                          'Open job',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${widget.post['job']['location'] ?? ''} · \$${widget.post['job']['payPerHour'] ?? ''}/hr',
                                      style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: 0.65),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: AppColors.kSkyBlue, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Multi-Image Carousel with Top-Right "1/4" Pill Badge
                    if (imagePaths.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 10,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: imagePaths.length,
                                onPageChanged: (index) {
                                  setState(() => _currentImageIndex = index);
                                },
                                itemBuilder: (context, index) {
                                  final imgUrl = widget.service
                                      .imageUrl(imagePaths[index]);
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => _openImageViewer(
                                        index, imagePaths),
                                    child: CachedNetworkImage(
                                      imageUrl: imgUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => Container(
                                        color: AppColors.kDarkBlue,
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                width: 26,
                                                height: 26,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: AppColors.kSkyBlue,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Loading image...',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.4),
                                                  fontSize: 11.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      errorWidget: (_, __, ___) => Container(
                                        color: AppColors.kDarkBlue,
                                        child: const Center(
                                          child: Icon(
                                              Icons.broken_image_outlined,
                                              color: Colors.white38,
                                              size: 40),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (imagePaths.length > 1)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.72),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white
                                          .withValues(alpha: 0.15),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    '${_currentImageIndex + 1}/${imagePaths.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),

                    // LinkedIn Reaction & Comment Counters Row
                    if (reactionCount > 0 || commentCount > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (reactionCount > 0)
                              Text(
                                '$reactionCount ${reactionCount == 1 ? 'like' : 'likes'}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            if (commentCount > 0)
                              Text(
                                '$commentCount ${commentCount == 1 ? 'comment' : 'comments'}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 12.5,
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                          ],
                        ),
                      ),

                    Divider(
                      color: Colors.white.withValues(alpha: 0.08),
                      height: 16,
                      thickness: 0.8,
                    ),

                    // Action Buttons Row: Like, Comment & Report
                    Row(
                      children: [
                        // Like Button (Tap: Toggle Like/Dislike, Long Press: Reaction Picker)
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              widget.onReact(currentReaction ?? 'like');
                            },
                            onLongPress: () {
                              setState(() {
                                _showReactionPicker = true;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _getReactionIcon(currentReaction),
                                    size: 19,
                                    color: currentReaction != null
                                        ? _getReactionColor(currentReaction)
                                        : Colors.white70,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _getReactionLabel(currentReaction),
                                    style: TextStyle(
                                      color: currentReaction != null
                                          ? _getReactionColor(currentReaction)
                                          : Colors.white70,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 18,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        // Comment Button
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: widget.onOpenThread,
                            child: const Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 19,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Comment',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 18,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        // Report or Manage (for own post) Button
                        Expanded(
                          child: widget.ownPost
                              ? InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () => _showPostActionsSheet(context),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          widget.canEdit
                                              ? Icons.edit_note_rounded
                                              : Icons.delete_outline_rounded,
                                          size: 19,
                                          color: widget.canEdit
                                              ? Colors.white70
                                              : Colors.redAccent,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          widget.canEdit ? 'Manage' : 'Delete',
                                          style: TextStyle(
                                            color: widget.canEdit
                                                ? Colors.white70
                                                : Colors.redAccent,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: widget.isReported ? null : widget.onReport,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          widget.isReported
                                              ? Icons.flag_rounded
                                              : Icons.flag_outlined,
                                          size: 19,
                                          color: widget.isReported
                                              ? Colors.amber
                                              : Colors.white70,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          widget.isReported
                                              ? 'Reported'
                                              : 'Report',
                                          style: TextStyle(
                                            color: widget.isReported
                                                ? Colors.amber
                                                : Colors.white70,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

          // Floating LinkedIn Reaction Bar Overlay on Long Press
          if (_showReactionPicker) ...[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => setState(() => _showReactionPicker = false),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              bottom: 48,
              left: 10,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    alignment: Alignment.bottomLeft,
                    child: child,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.kDarkBlue,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.kSkyBlue.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.55),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildReactionOption(
                          'like', 'Like', Icons.thumb_up, AppColors.kSkyBlue),
                      const SizedBox(width: 16),
                      _buildReactionOption('useful', 'Useful',
                          Icons.lightbulb_rounded, Colors.amber),
                      const SizedBox(width: 16),
                      _buildReactionOption(
                          'support',
                          'Support',
                          Icons.volunteer_activism_rounded,
                          const Color(0xFFFF6584)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
