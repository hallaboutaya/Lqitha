import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/background_gradient.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/popups/popup_payment.dart';
import '../../cubits/notification/notification_cubit.dart';
import '../../cubits/notification/notification_state.dart';
import '../../data/models/notification.dart';
import '../../services/service_locator.dart';
import '../../data/repositories/user_repository.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationCubit _notificationCubit;
  final UserRepository _userRepository = getIt<UserRepository>();
  
  // TODO: Replace with actual logged-in user ID from auth system
  static const int _currentUserId = 1;

  @override
  void initState() {
    super.initState();
    _notificationCubit = getIt<NotificationCubit>();
    _notificationCubit.loadAllNotifications(_currentUserId);
  }

  @override
  void dispose() {
    _notificationCubit.close();
    super.dispose();
  }
  
  Future<List<_NotificationItem>> _mapNotificationsToItems(
    List<NotificationModel> notifications,
    BuildContext context,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    
    final items = <_NotificationItem>[];
    
    for (final notification in notifications) {
      // Get username from database
      String userName = 'User ${notification.userId ?? 'Unknown'}';
      if (notification.userId != null) {
        final username = await _userRepository.getUsernameById(notification.userId!);
        if (username != null) {
          userName = username;
        }
      }
      
      // Map notification type to action
      NotificationAction action;
      String actionLabel;
      
      if (notification.type == 'contact_unlocked') {
        action = NotificationAction.confirmReturn;
        actionLabel = l10n.yesIGotMyItemBack;
      } else {
        action = NotificationAction.getContact;
        actionLabel = l10n.getContact;
      }
      
      items.add(_NotificationItem(
        userName: userName,
        message: notification.message,
        timeAgo: _formatTimeAgo(notification.createdAt),
        avatarUrl: 'https://i.pravatar.cc/150?img=${notification.id ?? 1}',
        action: action,
        actionLabel: actionLabel,
        itemTitle: null,
      ));
    }
    
    return items;
  }
  
  String _formatTimeAgo(String? createdAt) {
    if (createdAt == null) return 'Unknown time';
    
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else {
        return '${difference.inDays ~/ 7} week${(difference.inDays ~/ 7) > 1 ? 's' : ''} ago';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notificationCubit,
      child: Scaffold(
        body: BackgroundGradient(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    title: AppLocalizations.of(context)!.notifications,
                    subtitle: AppLocalizations.of(context)!.stayUpdatedOnItems,
                    accentColor: AppColors.primaryPurple,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: BlocBuilder<NotificationCubit, NotificationState>(
                      builder: (context, state) {
                        if (state is NotificationLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (state is NotificationError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(state.message),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => _notificationCubit.loadAllNotifications(_currentUserId),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        if (state is NotificationLoaded) {
                          final notifications = state.notifications;
                          
                          if (notifications.isEmpty) {
                            return Center(
                              child: Text(
                                state.message ?? 'No notifications yet',
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                            );
                          }
                          
                          return FutureBuilder<List<_NotificationItem>>(
                            future: _mapNotificationsToItems(notifications, context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              
                              final items = snapshot.data ?? [];
                              
                              return RefreshIndicator(
                                onRefresh: () => _notificationCubit.refresh(_currentUserId),
                                child: ListView.separated(
                                  itemCount: items.length,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 24, top: 12),
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final item = items[index];
                                    return _NotificationCard(
                                      item: item,
                                      onAction: () => _handleAction(context, item, notifications[index]),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                        
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, _NotificationItem item, NotificationModel notification) {
    // Mark notification as read when user interacts with it
    if (!notification.isRead && notification.id != null) {
      _notificationCubit.markAsRead(notification.id!, _currentUserId);
    }
    
    switch (item.action) {
      case NotificationAction.getContact:
        showDialog(
          context: context,
          builder: (_) => PaymentPopup(
            userName: item.userName,
            itemTitle: item.itemTitle ?? AppLocalizations.of(context)!.yourItem,
          ),
        );
        break;
      case NotificationAction.confirmReturn:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.thanksMarkedAsReunited(item.userName)),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
    }
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.onAction,
  });

  final _NotificationItem item;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.65),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            width: 1.0,
            color: AppColors.borderPurple,
          ),
        ),
        shadows: const [
          BoxShadow(
            color: AppColors.shadowPurple,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.network(
                  item.avatarUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 48,
                    height: 48,
                    color: AppColors.primaryPurple.withOpacity(0.1),
                    alignment: Alignment.center,
                    child: const Icon(Icons.person, color: AppColors.primaryPurple),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.userName,
                      style: AppTextStyles.cardUserName,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.timeAgo,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.textLight,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _NotificationActionButton(
            label: item.actionLabel,
            action: item.action,
            onTap: onAction,
          ),
        ],
      ),
    );
  }
}

class _NotificationActionButton extends StatelessWidget {
  const _NotificationActionButton({
    required this.label,
    required this.action,
    required this.onTap,
  });

  final String label;
  final NotificationAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = action == NotificationAction.getContact;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: ShapeDecoration(
          color: isPrimary ? AppColors.primaryPurple : AppColors.primaryOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadows: const [
            BoxShadow(
              color: AppColors.shadowBlack,
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.userName,
    required this.message,
    required this.timeAgo,
    required this.avatarUrl,
    required this.action,
    required this.actionLabel,
    this.itemTitle,
  });

  final String userName;
  final String message;
  final String timeAgo;
  final String avatarUrl;
  final NotificationAction action;
  final String actionLabel;
  final String? itemTitle;
}

enum NotificationAction { getContact, confirmReturn }

