import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/models/job_model.dart';
import 'package:tac/modules/Guards/job_details/job_details_screen.dart';

import 'community_service.dart';
import 'components/post_card.dart';
import 'components/thread_view.dart';

class CommunityHistoryScreen extends StatefulWidget {
  const CommunityHistoryScreen({
    super.key,
    required this.authorType,
    required this.authorId,
  });

  final String authorType;
  final String authorId;

  @override
  State<CommunityHistoryScreen> createState() => _CommunityHistoryScreenState();
}

class _CommunityHistoryScreenState extends State<CommunityHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  late final CommunityService _service;
  Map<String, dynamic> _person = const {};
  Map<String, dynamic> _summary = const {};
  final Map<String, List<Map<String, dynamic>>> _items = {
    'posts': [],
    'comments': [],
    'reactions': [],
    'following': [],
    'reports': [],
  };
  final Map<String, Map<String, dynamic>> _pagination = {};
  String? _error;
  int _requestedPage = 1;
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasReports = false;

  @override
  void initState() {
    super.initState();
    final userController = Get.find<UserController>();
    _service = CommunityService(
      token: userController.accessToken.value ?? '',
      accountId: userController.accountId.value ?? '',
      accountType: userController.accountType.value,
    );
    _scrollController.addListener(_onScroll);
    _loadPage(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPage(int page) async {
    if (page == 1) {
      setState(() {
        _loading = true;
        _error = null;
      });
    } else {
      if (_loadingMore || !_canLoadMore) return;
      setState(() => _loadingMore = true);
    }

    try {
      final response = await _service.fetchHistory(
        type: widget.authorType,
        id: widget.authorId,
        page: page,
        limit: 20,
      );
      if (!mounted) return;
      final person = _asMap(response['person']);
      if (person == null) {
        throw const CommunityApiException(
          500,
          'The community history response was invalid.',
        );
      }
      final summary = _asMap(response['summary']) ?? const {};
      setState(() {
        _person = person;
        _summary = summary;
        if (page == 1) _pagination.clear();
        for (final section in _items.keys) {
          final sectionData = _asMap(response[section]);
          if (sectionData == null) {
            if (page == 1) _items[section] = [];
            continue;
          }
          final rows = _asMapList(sectionData['items']);
          if (page == 1) {
            _items[section] = rows;
          } else {
            _items[section]!.addAll(rows);
          }
          final pagination = _asMap(sectionData['pagination']);
          if (pagination != null) _pagination[section] = pagination;
        }
        _hasReports = response.containsKey('reports');
        _requestedPage = page;
        _loading = false;
        _loadingMore = false;
      });
    } on CommunityApiException catch (exception) {
      if (exception.statusCode == 404 &&
          exception.message.toLowerCase() == 'account not found' &&
          mounted) {
        Navigator.of(context).maybePop();
        return;
      }
      if (!mounted) return;
      setState(() {
        _error = exception.message;
        _loading = false;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load this profile history. Check your connection.';
        _loading = false;
        _loadingMore = false;
      });
    }
  }

  bool get _canLoadMore => _pagination.entries
      .where((entry) => entry.key != 'comments')
      .any((entry) {
        final pagination = entry.value;
        final page = _asInt(pagination['page']);
        final totalPages = _asInt(pagination['totalPages']);
        return page < totalPages;
      });

  void _onScroll() {
    if (_scrollController.position.extentAfter < 360 &&
        !_loading &&
        !_loadingMore &&
        _canLoadMore) {
      _loadPage(_requestedPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile History'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.kSkyBlue),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => _loadPage(1),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _loadPage(1),
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                    children: [
                      _profileHeader(),
                      const SizedBox(height: 12),
                      _summaryCards(),
                      const SizedBox(height: 8),
                      _postsSection(),
                      _reactionsSection(),
                      _followingSection(),
                      if (_hasReports) _reportsSection(),
                      if (_loadingMore)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.kSkyBlue,
                            ),
                          ),
                        ),
                      if (_canLoadMore && !_loadingMore)
                        Center(
                          child: TextButton(
                            onPressed: () => _loadPage(_requestedPage + 1),
                            child: const Text('Load more'),
                          ),
                        ),
                      if (!_canLoadMore && !_loadingMore)
                        const SizedBox(height: 12),
                    ],
                  ),
                ),
    );
  }

  Widget _profileHeader() {
    final name = _person['name'] as String? ?? 'Community member';
    final type = (_person['type'] as String? ?? widget.authorType);
    final imagePath = _person['profileImage'] as String?;
    final avatar = imagePath == null || imagePath.isEmpty
        ? ''
        : _service.imageUrl(imagePath);
    final badge = _person['professionalBadge'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.kDarkBlue,
            backgroundImage:
                avatar.isEmpty ? null : CachedNetworkImageProvider(avatar),
            child: avatar.isEmpty
                ? const Icon(Icons.person, color: Colors.white70, size: 32)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _label(type),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                if (type == 'guard' && badge != null) ...[
                  const SizedBox(height: 7),
                  _badge(badge.toString()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCards() {
    const labels = [
      ('posts', 'Posts'),
      ('comments', 'Comments'),
      ('reactions', 'Reactions'),
      ('following', 'Following'),
      ('followers', 'Followers'),
      ('reports', 'Reports'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: _cardDecoration(),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisExtent: 42,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: labels.map((entry) {
          return Column(
            children: [
              Text(
                _asInt(_summary[entry.$1]).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                entry.$2,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white60, fontSize: 10),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _postsSection() {
    final posts = _items['posts']!;
    return _section(
      'Posts',
      _asInt(_summary['posts']),
      posts.isEmpty
          ? _empty('No posts yet.')
          : Column(
              children: posts.map((post) {
                final author = _asMap(post['author']) ?? const {};
                return LinkedInPostCard(
                  post: post,
                  service: _service,
                  accountLabel: _label,
                  dateLabel: _dateLabel,
                  isFollowed: false,
                  canFollow: false,
                  onFollowToggle: () {},
                  onOpenThread: () => _openPost(post['id']?.toString()),
                  onOpenAuthor: () => _openHistory(author),
                  onReact: (_) {},
                  onEdit: () {},
                  onDelete: () {},
                  onReport: () {},
                  onOpenJob: _openJob,
                  canEdit: false,
                  ownPost: false,
                  isReported: false,
                  showMoreOptions: false,
                );
              }).toList(),
            ),
    );
  }

  Widget _reactionsSection() {
    final reactions = _items['reactions']!;
    return _section(
      'Reactions',
      _asInt(_summary['reactions']),
      reactions.isEmpty
          ? _empty('No reactions yet.')
          : Column(
              children: reactions.map((reaction) {
                final target = _asMap(reaction['target']);
                final targetType = reaction['targetType']?.toString();
                final post =
                    targetType == 'comment' ? _asMap(target?['post']) : target;
                final postId = targetType == 'comment'
                    ? (target?['postId'] ?? post?['id'])?.toString()
                    : (target?['postId'] ?? target?['id'])?.toString();
                return _historyRow(
                  onTap: postId == null ? null : () => _openPost(postId),
                  child: Row(
                    children: [
                      Icon(
                        _reactionIcon(reaction['type']?.toString()),
                        color: AppColors.kSkyBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          target == null
                              ? 'Content no longer available'
                              : '${_label(reaction['type']?.toString())} · ${target['text'] ?? post?['text'] ?? 'Content'}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                target == null ? Colors.white38 : Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (postId != null)
                        const Icon(Icons.chevron_right, color: Colors.white38),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _followingSection() {
    final following = _items['following']!;
    return _section(
      'Following',
      _asInt(_summary['following']),
      following.isEmpty
          ? _empty('Not following anyone yet.')
          : Column(
              children: following.map((entry) {
                final author = _asMap(entry['author']) ??
                    _asMap(entry['following']) ??
                    _asMap(entry['target']) ??
                    entry;
                final type = author['type']?.toString() ?? '';
                final id = author['id']?.toString() ?? '';
                final image = author['profileImage']?.toString();
                final imageUrl = image == null || image.isEmpty
                    ? ''
                    : _service.imageUrl(image);
                return _historyRow(
                  onTap: type.isEmpty || id.isEmpty
                      ? null
                      : () => _openHistory(author),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 23,
                        backgroundColor: AppColors.kDarkBlue,
                        backgroundImage: imageUrl.isEmpty
                            ? null
                            : CachedNetworkImageProvider(imageUrl),
                        child: imageUrl.isEmpty
                            ? const Icon(Icons.person, color: Colors.white70)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              author['name']?.toString() ?? 'Community member',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${_label(type)} · Followed ${_dateLabel(entry['followedAt']?.toString())}',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white38),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _reportsSection() {
    final reports = _items['reports']!;
    final reportCount = _asInt(_summary['reports']);
    return _section(
      'Reports',
      reportCount,
      reports.isEmpty
          ? _empty('No reports.')
          : Column(
              children: reports.map((report) {
                final target = _asMap(report['target']);
                final targetAuthor = _asMap(report['targetAuthor']) ??
                    _asMap(target?['author']) ??
                    _asMap(_asMap(target?['post'])?['author']);
                final targetName = report['targetName'] ??
                    report['name'] ??
                    target?['name'] ??
                    targetAuthor?['name'];
                return _historyRow(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report['reason']?.toString() ?? 'Report',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${_label(report['status']?.toString())} · ${_label(report['targetType']?.toString())} · ${targetName?.toString() ?? 'Name unavailable'}',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _dateLabel(report['createdAt']?.toString()),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _section(String title, int count, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  count.toString(),
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          content,
        ],
      ),
    );
  }

  Widget _historyRow({required Widget child, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      decoration: _cardDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _empty(String message) => _historyRow(
        child: Text(message, style: const TextStyle(color: Colors.white54)),
      );

  Widget _badge(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.kSkyBlue.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.kSkyBlue.withValues(alpha: 0.4)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.kSkyBlue,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      );

  void _openHistory(Map<String, dynamic> author) {
    final type = author['type']?.toString();
    final id = author['id']?.toString();
    if (type == null ||
        (type != 'guard' && type != 'contractor') ||
        id == null ||
        id.isEmpty) {
      return;
    }
    Get.to<void>(() => CommunityHistoryScreen(authorType: type, authorId: id));
  }

  void _openPost(String? postId) {
    if (postId == null || postId.isEmpty) return;
    Get.to<void>(() => _CommunityHistoryPostScreen(
          service: _service,
          postId: postId,
        ));
  }

  void _openJob(Map<String, dynamic> job) {
    final id = job['id']?.toString();
    if (id == null || id.isEmpty) return;
    Get.to<void>(() => JobDetailsScreen(
          jobData: JobData(
            id: id,
            title: job['title']?.toString() ?? 'Job',
            description: '',
            responsibilities: '',
            location: job['location']?.toString() ?? '',
            latitude: '',
            longitude: '',
            noOfGuardsRequired: 0,
            leaderRequired: 0,
            payPerHour: job['payPerHour']?.toString() ?? '',
            jobSOPs: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            contractorId: '',
            contractorName: '',
            categoryName: '',
            premisesTypeName: '',
            shifts: const [],
          ),
          bottomAction: const SizedBox.shrink(),
        ));
  }

  String _dateLabel(String? value) {
    final date = DateTime.tryParse(value ?? '')?.toLocal();
    if (date == null) return 'recently';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _label(String? value) {
    if (value == null || value.isEmpty) return 'Member';
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  IconData _reactionIcon(String? type) => switch (type) {
        'useful' => Icons.lightbulb_rounded,
        'support' => Icons.volunteer_activism_rounded,
        _ => Icons.thumb_up_rounded,
      };

  static Map<String, dynamic>? _asMap(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : null;

  static List<Map<String, dynamic>> _asMapList(dynamic value) => value is List
      ? value.whereType<Map>().map(Map<String, dynamic>.from).toList()
      : [];

  static int _asInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;
}

class _CommunityHistoryPostScreen extends StatelessWidget {
  const _CommunityHistoryPostScreen({
    required this.service,
    required this.postId,
  });

  final CommunityService service;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkBlue,
        foregroundColor: Colors.white,
        title: const Text('Post Thread'),
      ),
      body: CommunityThreadView(
        service: service,
        postId: postId,
        canComment: true,
        onVerifiedPostDenied: () {},
        onHiddenPost: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}
