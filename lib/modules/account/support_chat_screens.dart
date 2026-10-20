import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/dataproviders/support_chat_service.dart';
import 'package:tac/models/support_chat_model.dart';
import 'package:tac/modules/Messages/socket_file.dart';
import 'package:tac/routes/app_routes.dart';

class SupportChatListScreen extends StatefulWidget {
  const SupportChatListScreen({super.key});

  @override
  State<SupportChatListScreen> createState() => _SupportChatListScreenState();
}

class _SupportChatListScreenState extends State<SupportChatListScreen> {
  final SupportChatService _service = SupportChatService();
  final SocketService _socket = SocketService();
  final List<SupportTicket> _tickets = [];
  late final StreamSubscription<Map<String, dynamic>> _socketSubscription;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  int _page = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _socket.initialize();
    _socketSubscription = _socket.supportStream.listen(_handleSocketEvent);
    _loadTickets(reset: true);
  }

  @override
  void dispose() {
    _socketSubscription.cancel();
    super.dispose();
  }

  Future<void> _loadTickets({required bool reset}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    } else {
      if (_isLoadingMore || _page >= _totalPages) return;
      setState(() => _isLoadingMore = true);
    }

    try {
      final result = await _service.getTickets(page: reset ? 1 : _page + 1);
      if (!mounted) return;
      setState(() {
        if (reset) _tickets.clear();
        _upsertTickets(result.tickets);
        _page = result.page;
        _totalPages = result.totalPages;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _errorText(error);
        _isLoading = false;
        _isLoadingMore = false;
      });
      _handleAuthFailure(error);
    }
  }

  void _handleSocketEvent(Map<String, dynamic> envelope) {
    final payload = _asMap(envelope['data']);
    if (envelope['event'] == 'support:error') {
      final message = payload?['error']?.toString();
      if (message != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
      return;
    }
    if (envelope['event'] == 'support:message' && payload != null) {
      final ticketId = payload['ticketId']?.toString();
      final rawMessage = _asMap(payload['message']);
      if (ticketId == null || rawMessage == null) return;
      final index = _tickets.indexWhere((ticket) => ticket.id == ticketId);
      if (index < 0) return;
      setState(() {
        final ticket = _tickets[index];
        _tickets[index] = ticket.copyWith(
          lastMessageAt: rawMessage['createdAt']?.toString(),
          lastMessagePreview: rawMessage['text']?.toString(),
          requesterUnreadCount: int.tryParse(
                payload['requesterUnreadCount']?.toString() ?? '',
              ) ??
              ticket.requesterUnreadCount,
        );
        _tickets.sort((a, b) {
          final aTime = DateTime.tryParse(a.lastMessageAt ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = DateTime.tryParse(b.lastMessageAt ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });
      });
      return;
    }
    final rawTicket = _asMap(payload?['ticket']);
    if (rawTicket == null || !mounted) return;
    final ticket = SupportTicket.fromJson(rawTicket);
    setState(() {
      if (ticket.status == 'closed') {
        final index = _tickets.indexWhere((item) => item.id == ticket.id);
        if (index >= 0) _tickets[index] = ticket;
      } else {
        _upsertTickets([ticket]);
      }
    });
  }

  void _upsertTickets(List<SupportTicket> tickets) {
    for (final ticket in tickets) {
      final index = _tickets.indexWhere((item) => item.id == ticket.id);
      if (index >= 0) {
        _tickets[index] = ticket;
      } else {
        _tickets.add(ticket);
      }
    }
    _tickets.sort((a, b) {
      final aTime = DateTime.tryParse(a.lastMessageAt ?? '') ??
          DateTime.tryParse(a.closedAt ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = DateTime.tryParse(b.lastMessageAt ?? '') ??
          DateTime.tryParse(b.closedAt ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
  }

  Future<void> _openThread(SupportTicket ticket) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => SupportThreadScreen(ticketId: ticket.id),
      ),
    );
    if (mounted) _loadTickets(reset: true);
  }

  Future<void> _startNewChat() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const NewSupportChatScreen()),
    );
    if (mounted) _loadTickets(reset: true);
  }

  bool get _hasActiveTicket => _tickets
      .any((ticket) => ticket.status == 'open' || ticket.status == 'claimed');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kWhite),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Support chats',
          style: TextStyle(color: AppColors.kWhite, fontSize: 18),
        ),
      ),
      floatingActionButton: !_hasActiveTicket && !_isLoading
          ? FloatingActionButton.extended(
              onPressed: _startNewChat,
              backgroundColor: AppColors.kSkyBlue,
              foregroundColor: AppColors.kDarkestBlue,
              icon: const Icon(Icons.add_comment_outlined),
              label: const Text('New chat'),
            )
          : null,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.kSkyBlue))
          : _error != null && _tickets.isEmpty
              ? _ErrorPanel(
                  message: _error!,
                  onRetry: () => _loadTickets(reset: true),
                )
              : RefreshIndicator(
                  onRefresh: () => _loadTickets(reset: true),
                  color: AppColors.kSkyBlue,
                  child: _tickets.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 140),
                            Icon(Icons.support_agent,
                                size: 52, color: AppColors.kinput),
                            SizedBox(height: 12),
                            Center(
                              child: Text(
                                'No support chats yet.\nStart a chat if you need help.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.ktextlight),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          itemCount:
                              _tickets.length + (_page < _totalPages ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _tickets.length) {
                              return Center(
                                child: TextButton(
                                  onPressed: _isLoadingMore
                                      ? null
                                      : () => _loadTickets(reset: false),
                                  child: _isLoadingMore
                                      ? const CircularProgressIndicator(
                                          color: AppColors.kSkyBlue)
                                      : const Text('Load older chats'),
                                ),
                              );
                            }
                            final ticket = _tickets[index];
                            return _SupportTicketTile(
                              ticket: ticket,
                              onTap: () => _openThread(ticket),
                            );
                          },
                        ),
                ),
    );
  }
}

class NewSupportChatScreen extends StatefulWidget {
  const NewSupportChatScreen({super.key});

  @override
  State<NewSupportChatScreen> createState() => _NewSupportChatScreenState();
}

class _NewSupportChatScreenState extends State<NewSupportChatScreen> {
  final SupportChatService _service = SupportChatService();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final List<SupportFile> _attachments = [];
  String? _subjectError;
  String? _messageError;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _addAttachments() async {
    final files = await _pickSupportFiles(_attachments);
    if (files == null || !mounted) return;
    setState(() {
      _attachments
        ..clear()
        ..addAll(files);
    });
  }

  Future<void> _submit() async {
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();
    setState(() {
      _subjectError = subject.isEmpty
          ? 'Subject is required'
          : subject.length > 120
              ? 'Subject must be 120 characters or fewer'
              : null;
      _messageError = message.isEmpty
          ? 'Message is required'
          : message.length > 2000
              ? 'Message must be 2000 characters or fewer'
              : null;
    });
    if (_subjectError != null || _messageError != null || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      final created = await _service.createTicket(
        subject: subject,
        text: message,
        attachments: _attachments,
      );
      if (!mounted) return;
      await Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => SupportThreadScreen(initialThread: created),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      if (error is SupportApiException &&
          error.statusCode == 409 &&
          error.message.contains('active support chat')) {
        try {
          final tickets = await _service.getTickets();
          final active = tickets.tickets.where(
            (ticket) => ticket.status == 'open' || ticket.status == 'claimed',
          );
          if (active.isNotEmpty && mounted) {
            await Navigator.of(context).pushReplacement<void, void>(
              MaterialPageRoute<void>(
                builder: (_) => SupportThreadScreen(ticketId: active.first.id),
              ),
            );
            return;
          }
        } catch (refreshError) {
          _showError(context, refreshError);
        }
      }
      if (error is SupportApiException) {
        setState(() {
          _subjectError = error.fieldErrors['subject'];
          _messageError = error.fieldErrors['text'];
        });
      }
      _showError(context, error);
      _handleAuthFailure(error);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        title: const Text('New support chat',
            style: TextStyle(color: AppColors.kWhite, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kWhite),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, 24 + MediaQuery.of(context).viewInsets.bottom),
        children: [
          const Text(
            'Tell us what you need help with. A support admin will join your chat.',
            style: TextStyle(color: AppColors.ktextlight, height: 1.4),
          ),
          const SizedBox(height: 24),
          _InputLabel(
            label: 'Subject',
            controller: _subjectController,
            hint: 'e.g. Help with my shift',
            maxLength: 120,
            errorText: _subjectError,
          ),
          const SizedBox(height: 16),
          _InputLabel(
            label: 'Message',
            controller: _messageController,
            hint: 'Describe how we can help',
            maxLength: 2000,
            maxLines: 6,
            errorText: _messageError,
          ),
          const SizedBox(height: 16),
          _AttachmentSection(
            attachments: _attachments,
            onAdd: _addAttachments,
            onRemove: (index) => setState(() => _attachments.removeAt(index)),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kSkyBlue,
                foregroundColor: AppColors.kDarkestBlue,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Start chat',
                      style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class SupportThreadScreen extends StatefulWidget {
  final String? ticketId;
  final SupportThreadPage? initialThread;

  const SupportThreadScreen({
    super.key,
    this.ticketId,
    this.initialThread,
  }) : assert(ticketId != null || initialThread != null);

  @override
  State<SupportThreadScreen> createState() => _SupportThreadScreenState();
}

class _SupportThreadScreenState extends State<SupportThreadScreen> {
  final SupportChatService _service = SupportChatService();
  final SocketService _socket = SocketService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<SupportMessage> _messages = [];
  late final StreamSubscription<Map<String, dynamic>> _socketSubscription;
  late final StreamSubscription<bool> _connectionSubscription;
  SupportTicket? _ticket;
  bool _isLoading = true;
  bool _isSending = false;
  bool _isClosing = false;
  bool _isLoadingOlder = false;
  bool _hasJoinedTicket = false;
  int _page = 1;
  List<SupportFile> _attachments = [];

  String get _ticketId => widget.initialThread?.ticket.id ?? widget.ticketId!;

  @override
  void initState() {
    super.initState();
    _socket.initialize();
    _socketSubscription = _socket.supportStream.listen(_handleSocketEvent);
    _connectionSubscription = _socket.connectionStream.listen((connected) {
      if (connected && _hasJoinedTicket) {
        _socket.joinSupportTicket(_ticketId);
      }
    });
    _initializeThread();
  }

  @override
  void dispose() {
    _socket.leaveSupportTicket(_ticketId);
    _socketSubscription.cancel();
    _connectionSubscription.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeThread() async {
    final initial = widget.initialThread;
    if (initial != null) {
      setState(() {
        _ticket = initial.ticket;
        _messages.addAll(initial.messages);
        _isLoading = false;
      });
      _joinTicket();
      return;
    }
    await _loadThread();
    if (mounted && _ticket != null) _joinTicket();
  }

  void _joinTicket() {
    _hasJoinedTicket = true;
    _socket.joinSupportTicket(_ticketId);
  }

  Future<void> _loadThread() async {
    try {
      final thread = await _service.getThread(_ticketId);
      if (!mounted) return;
      setState(() {
        _ticket = thread.ticket.copyWith(requesterUnreadCount: 0);
        _messages
          ..clear()
          ..addAll(thread.messages);
        _page = thread.page;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError(context, error);
      _handleAuthFailure(error);
      if (error is SupportApiException && error.statusCode == 404) {
        Navigator.of(context).maybePop();
      }
    }
  }

  void _handleSocketEvent(Map<String, dynamic> envelope) {
    if (!mounted) return;
    final eventName = envelope['event']?.toString();
    final payload = _asMap(envelope['data']);
    if (payload == null) return;
    if (eventName == 'support:error') {
      _showMessage(
          context, payload['error']?.toString() ?? 'Support socket error.');
      return;
    }

    if (eventName == 'support:message' &&
        payload['ticketId']?.toString() == _ticketId) {
      final rawMessage = _asMap(payload['message']);
      if (rawMessage == null) return;
      final message = SupportMessage.fromJson(rawMessage);
      setState(() {
        _appendMessage(message);
        final current = _ticket;
        if (current != null) {
          _ticket = current.copyWith(
            requesterUnreadCount: 0,
            lastMessageAt: message.createdAt,
            lastMessagePreview: message.text,
          );
        }
      });
      return;
    }

    if (eventName == 'support:ticket-updated') {
      final rawTicket = _asMap(payload['ticket']);
      if (rawTicket == null || rawTicket['id']?.toString() != _ticketId) return;
      final updated = SupportTicket.fromJson(rawTicket);
      setState(() => _ticket = updated.copyWith(requesterUnreadCount: 0));
    }
  }

  void _appendMessage(SupportMessage message) {
    if (message.id.isNotEmpty &&
        _messages.any((existing) => existing.id == message.id)) {
      return;
    }
    _messages.add(message);
  }

  Future<void> _loadOlderMessages() async {
    if (_isLoadingOlder || _page <= 1) return;
    setState(() => _isLoadingOlder = true);
    try {
      final older = await _service.getThread(_ticketId, page: _page - 1);
      if (!mounted) return;
      setState(() {
        final knownIds = _messages.map((message) => message.id).toSet();
        _messages.insertAll(
          0,
          older.messages.where((message) => !knownIds.contains(message.id)),
        );
        _page = older.page;
        _isLoadingOlder = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoadingOlder = false);
      _showError(context, error);
      _handleAuthFailure(error);
    }
  }

  Future<void> _addAttachments() async {
    final files = await _pickSupportFiles(_attachments);
    if (files != null && mounted) setState(() => _attachments = files);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (_isSending) return;
    if (text.isEmpty) {
      _showMessage(context, 'Write a message before sending.');
      return;
    }
    if (text.length > 2000) {
      _showMessage(context, 'Message must be 2000 characters or fewer.');
      return;
    }
    setState(() => _isSending = true);
    try {
      final message = await _service.sendMessage(
        _ticketId,
        text: text,
        attachments: _attachments,
      );
      if (!mounted) return;
      setState(() {
        _appendMessage(message);
        _messageController.clear();
        _attachments = [];
        final ticket = _ticket;
        if (ticket != null) {
          _ticket = ticket.copyWith(
            lastMessageAt: message.createdAt,
            lastMessagePreview: message.text,
            requesterUnreadCount: 0,
          );
        }
      });
    } catch (error) {
      if (!mounted) return;
      if (error is SupportApiException &&
          error.message.toLowerCase().contains('chat is closed')) {
        setState(() => _ticket = _ticket?.copyWith(status: 'closed'));
      }
      _showError(context, error);
      _handleAuthFailure(error);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _closeChat() async {
    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kJobCardColor,
        title: const Text('Close this chat?',
            style: TextStyle(color: AppColors.kWhite)),
        content: const Text(
          'You can start a new support chat if you need help again.',
          style: TextStyle(color: AppColors.ktextlight),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Close chat')),
        ],
      ),
    );
    if (shouldClose != true || _isClosing) return;
    setState(() => _isClosing = true);
    try {
      final updated = await _service.closeTicket(_ticketId);
      if (mounted) setState(() => _ticket = updated);
    } catch (error) {
      if (mounted) _showError(context, error);
      _handleAuthFailure(error);
    } finally {
      if (mounted) setState(() => _isClosing = false);
    }
  }

  String get _statusText {
    final ticket = _ticket;
    if (ticket == null) return '';
    switch (ticket.status) {
      case 'claimed':
        return '${ticket.claimedBy?['name'] ?? 'A support admin'} is helping you';
      case 'closed':
        return 'This chat is closed';
      default:
        return 'Waiting for an admin. You can keep writing.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticket = _ticket;
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        titleSpacing: 0,
        title: Text(
          ticket?.subject ?? 'Support chat',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.kWhite, fontSize: 17),
        ),
        actions: [
          if (ticket != null && ticket.status != 'closed')
            IconButton(
              onPressed: _isClosing ? null : _closeChat,
              tooltip: 'Close chat',
              icon: _isClosing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check_circle_outline,
                      color: AppColors.kWhite),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.kSkyBlue))
          : ticket == null
              ? const Center(
                  child: Text('Support chat could not be loaded.',
                      style: TextStyle(color: AppColors.ktextlight)))
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      color: AppColors.kJobCardColor,
                      child: Text(
                        _statusText,
                        style: const TextStyle(
                            color: AppColors.ktextlight, fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: _messages.isEmpty
                          ? const Center(
                              child: Text('No messages yet',
                                  style:
                                      TextStyle(color: AppColors.ktextlight)))
                          : NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification is ScrollUpdateNotification &&
                                    notification.metrics.pixels >=
                                        notification.metrics.maxScrollExtent -
                                            80) {
                                  _loadOlderMessages();
                                }
                                return false;
                              },
                              child: ListView.builder(
                                controller: _scrollController,
                                reverse: true,
                                padding: const EdgeInsets.all(16),
                                itemCount: _messages.length +
                                    (_isLoadingOlder ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (_isLoadingOlder &&
                                      index == _messages.length) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: CircularProgressIndicator(
                                            color: AppColors.kSkyBlue),
                                      ),
                                    );
                                  }
                                  return _SupportMessageBubble(
                                    message:
                                        _messages[_messages.length - 1 - index],
                                  );
                                },
                              ),
                            ),
                    ),
                    if (ticket.status == 'closed')
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 20),
                        child: Text(
                          'This chat is closed. Start a new chat for more help.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.kinput),
                        ),
                      )
                    else
                      _buildComposer(),
                  ],
                ),
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        color: AppColors.kJobCardColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_attachments.isNotEmpty)
              _AttachmentSection(
                attachments: _attachments,
                onAdd: _attachments.length < 4 ? _addAttachments : null,
                onRemove: (index) =>
                    setState(() => _attachments.removeAt(index)),
                compact: true,
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _attachments.length >= 4 ? null : _addAttachments,
                  icon:
                      const Icon(Icons.attach_file, color: AppColors.kSkyBlue),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLength: 2000,
                    maxLines: 4,
                    minLines: 1,
                    style: const TextStyle(color: AppColors.kWhite),
                    decoration: const InputDecoration(
                      hintText: 'Write a message...',
                      hintStyle: TextStyle(color: AppColors.kinput),
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isSending ? null : _sendMessage,
                  icon: _isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.send, color: AppColors.kSkyBlue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportTicketTile extends StatelessWidget {
  final SupportTicket ticket;
  final VoidCallback onTap;

  const _SupportTicketTile({required this.ticket, required this.onTap});

  String get _status {
    switch (ticket.status) {
      case 'claimed':
        return '${ticket.claimedBy?['name'] ?? 'An admin'} is helping you';
      case 'closed':
        return 'Closed';
      default:
        return 'Waiting for an admin';
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = DateTime.tryParse(ticket.lastMessageAt ?? '');
    return Card(
      color: AppColors.kJobCardColor,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
        title: Row(
          children: [
            Expanded(
              child: Text(ticket.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.kWhite, fontWeight: FontWeight.w600)),
            ),
            if (ticket.requesterUnreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                    color: AppColors.kSkyBlue, shape: BoxShape.circle),
                child: Text('${ticket.requesterUnreadCount}',
                    style: const TextStyle(
                        color: AppColors.kDarkestBlue,
                        fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ticket.lastMessagePreview ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.ktextlight)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Text(_status,
                        style: const TextStyle(
                            color: AppColors.kSkyBlue, fontSize: 12)),
                  ),
                  if (time != null)
                    Text(DateFormat('MMM d, h:mm a').format(time.toLocal()),
                        style: const TextStyle(
                            color: AppColors.kinput, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.kinput),
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final int maxLines;
  final String? errorText;

  const _InputLabel({
    required this.label,
    required this.controller,
    required this.hint,
    required this.maxLength,
    this.maxLines = 1,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.kWhite, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.kWhite),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.kinput),
            counterStyle: const TextStyle(color: AppColors.kinput),
            errorText: errorText,
            filled: true,
            fillColor: AppColors.kJobCardColor,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}

class _AttachmentSection extends StatelessWidget {
  final List<SupportFile> attachments;
  final VoidCallback? onAdd;
  final ValueChanged<int> onRemove;
  final bool compact;

  const _AttachmentSection({
    required this.attachments,
    required this.onAdd,
    required this.onRemove,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty && compact) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact)
          Row(
            children: [
              const Expanded(
                child: Text('Attachments (up to 4)',
                    style: TextStyle(
                        color: AppColors.kWhite, fontWeight: FontWeight.w600)),
              ),
              TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.attach_file, size: 18),
                label: const Text('Add file'),
              ),
            ],
          ),
        ...List.generate(
          attachments.length,
          (index) => Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.kDarkBlue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file_outlined,
                    color: AppColors.kSkyBlue, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(attachments[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.ktextlight, fontSize: 12)),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => onRemove(index),
                  icon: const Icon(Icons.close,
                      color: AppColors.kinput, size: 18),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportMessageBubble extends StatelessWidget {
  final SupportMessage message;
  const _SupportMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.senderType == 'system') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(message.text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.kinput, fontSize: 12)),
        ),
      );
    }
    final ownMessage = message.senderType.toLowerCase() ==
        Get.find<UserController>().accountType.value.toLowerCase();
    final time = DateTime.tryParse(message.createdAt ?? '');
    return Align(
      alignment: ownMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ownMessage ? AppColors.kPrimary : AppColors.kJobCardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!ownMessage && (message.senderName?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(message.senderName!,
                    style: const TextStyle(
                        color: AppColors.kSkyBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            if (message.text.isNotEmpty)
              Text(message.text,
                  style: const TextStyle(color: AppColors.kWhite, height: 1.3)),
            for (final attachment in message.attachments)
              _MessageAttachment(value: attachment),
            if (time != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(DateFormat('h:mm a').format(time.toLocal()),
                    style:
                        const TextStyle(color: Colors.white60, fontSize: 10)),
              ),
          ],
        ),
      ),
    );
  }
}

class _MessageAttachment extends StatelessWidget {
  final String value;
  const _MessageAttachment({required this.value});

  @override
  Widget build(BuildContext context) {
    final url = value.startsWith('http')
        ? value
        : 'https://api.control1security.com.au/uploads/$value';
    final isImage =
        RegExp(r'\.(png|jpe?g|gif|webp)(\?.*)?$', caseSensitive: false)
            .hasMatch(url);
    if (isImage) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            url,
            width: 220,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _attachmentLabel(value),
          ),
        ),
      );
    }
    return _attachmentLabel(value);
  }

  Widget _attachmentLabel(String value) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insert_drive_file_outlined,
                color: AppColors.kSkyBlue, size: 17),
            const SizedBox(width: 5),
            Flexible(
              child: Text(value.split('/').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.ktextlight, fontSize: 12)),
            ),
          ],
        ),
      );
}

class _ErrorPanel extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorPanel({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.ktextlight)),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

Future<List<SupportFile>?> _pickSupportFiles(List<SupportFile> current) async {
  final remaining = 4 - current.length;
  if (remaining <= 0) {
    Get.snackbar('Attachment limit', 'You can attach up to 4 files.');
    return null;
  }
  final result = await FilePicker.platform.pickFiles(
    type: FileType.any,
    allowMultiple: true,
    withData: true,
  );
  if (result == null) return null;
  if (result.files.length > remaining) {
    Get.snackbar('Attachment limit', 'You can attach up to 4 files.');
    return null;
  }

  final selected = <SupportFile>[];
  for (final file in result.files) {
    final bytes = file.bytes;
    if (bytes == null) {
      Get.snackbar('Could not attach file',
          'Unable to read ${file.name}. Please select it again.');
      return null;
    }
    final encoded = base64Encode(bytes);
    final mimeType = lookupMimeType(file.name, headerBytes: bytes) ??
        'application/octet-stream';
    final dataUri = 'data:$mimeType;base64,$encoded';
    if (dataUri.length > 15000000) {
      Get.snackbar(
          'File too large', '${file.name} exceeds the 15 MB upload limit.');
      return null;
    }
    selected.add(SupportFile(
      name: file.name,
      dataUri: dataUri,
    ));
  }
  return [...current, ...selected];
}

void _showError(BuildContext context, Object error) {
  final message = error is SupportApiException
      ? error.message
      : error is StateError
          ? error.message
          : 'Unable to connect to support. Please try again.';
  _showMessage(context, message);
}

String _errorText(Object error) {
  if (error is SupportApiException) return error.message;
  if (error is StateError) return error.message;
  return 'Unable to load support chats. Please try again.';
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

void _handleAuthFailure(Object error) {
  if (error is SupportApiException && error.statusCode == 401) {
    Get.offAllNamed(AppRoutes.getSignInRoute());
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
