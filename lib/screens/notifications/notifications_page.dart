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
import '../../data/repositories/found_repository.dart';
import '../../data/repositories/unlock_repository.dart';
import '../../services/auth_service.dart';
import '../../widgets/popups/popup_contact_unlocked.dart';
import '../../core/utils/time_formatter.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    super.key,
    this.isVisible = true,
  });

  final bool isVisible;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationCubit _notificationCubit;
  final UserRepository _userRepository = getIt<UserRepository>();
  late final dynamic _currentUserId; // Can be int (SQLite) or String (UUID from Supabase)

  @override
  void initState() {
    super.initState();
    // Get current logged-in user ID from AuthService
    _currentUserId = AuthService().currentUserId ?? 1;
    _notificationCubit = getIt<NotificationCubit>();
    
    print('🔔 NotificationsPage initState: isVisible=${widget.isVisible}, userId=$_currentUserId');
    
    // Load notifications on first init ONLY if visible
    if (widget.isVisible) {
      print('🔔 Loading notifications in initState');
      _notificationCubit.loadAllNotifications(_currentUserId);
    }
  }

  @override
  void didUpdateWidget(NotificationsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    print('🔔 didUpdateWidget: old.isVisible=${oldWidget.isVisible}, new.isVisible=${widget.isVisible}');
    
    // Reload notifications when page becomes visible
    if (!oldWidget.isVisible && widget.isVisible) {
      print('📬 Notifications tab became visible, reloading...');
      _notificationCubit.loadAllNotifications(_currentUserId);
    }
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
    final foundRepository = getIt<FoundRepository>();
    
    final items = <_NotificationItem>[];
    
    for (final notification in notifications) {
      String userName;
      String? avatarUrl;
      bool isAdminNotification = notification.type == 'post_approved' || notification.type == 'post_rejected';
      bool isSystemNotification = notification.type == 'point_change' || notification.type == 'system';
      
      if (isAdminNotification) {
        // Admin notifications - from system/admin, not a user
        userName = 'Admin';
        avatarUrl = null; // Will show admin icon
      } else if (isSystemNotification) {
        // Reward/System notifications
        userName = 'Trust Points';
        avatarUrl = null; // Will show system icon
      } else if (notification.type == 'item_found' && notification.relatedPostId != null) {
        // For "item_found": notification.userId is the post owner (recipient)
        // But we want to show WHO found it - that's in the relatedPostId (the found post)
        try {
          final foundPost = await foundRepository.getPostById(notification.relatedPostId!);
          if (foundPost?.userId != null) {
            final finderUser = await _userRepository.getUserById(foundPost!.userId!);
            if (finderUser != null) {
              userName = finderUser.username;
              avatarUrl = finderUser.photo;
            } else {
              userName = 'User ${foundPost.userId}';
              avatarUrl = null;
            }
          } else {
            userName = l10n.someone;
            avatarUrl = null;
          }
        } catch (e) {
          print('Error fetching finder info: $e');
          userName = l10n.someone;
          avatarUrl = null;
        }
      } else if (notification.type == 'contact_unlocked') {
        // For "contact_unlocked": we don't store who unlocked it in the notification record currently.
        // It's better to show a generic "Someone" or "Unlocker" rather than the recipient's own name.
        userName = l10n.someone;
        avatarUrl = null;
      } else {
        // For other user notifications, try to get user info if available
        if (notification.userId != null) {
          final user = await _userRepository.getUserById(notification.userId!);
          if (user != null) {
            userName = user.username;
            avatarUrl = user.photo;
          } else {
            userName = l10n.userWithId(notification.userId.toString());
            avatarUrl = null;
          }
        } else {
          userName = l10n.someone;
          avatarUrl = null;
        }
      }
      
      // Override for Admin/System after user fetching logic
      if (isAdminNotification) {
        userName = l10n.admin;
      } else if (isSystemNotification) {
        userName = l10n.trustPoints;
      }
      
      // Map notification type to action
      NotificationAction action;
      String actionLabel;
      
      if (notification.type == 'contact_unlocked') {
        action = NotificationAction.confirmReturn;
        actionLabel = l10n.yesIGotMyItemBack;
      } else if (isAdminNotification || isSystemNotification) {
        // Admin and System notifications don't need action buttons
        action = NotificationAction.getContact; // Will be hidden via UI
        actionLabel = '';
      } else {
        action = NotificationAction.getContact;
        actionLabel = l10n.getContact;
      }
      
      items.add(_NotificationItem(
        userName: userName,
        message: notification.message,
        timeAgo: TimeFormatter.formatTimeAgoFromString(notification.createdAt, l10n),
        avatarUrl: avatarUrl,
        action: action,
        actionLabel: actionLabel,
        itemTitle: null,
        isAdmin: isAdminNotification,
        isSystem: isSystemNotification,
      ));
    }
    
    return items;
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
                                  child: Text(AppLocalizations.of(context)!.retry),
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
                                state.message ?? AppLocalizations.of(context)!.noNotificationsYet,
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

  void _handleAction(BuildContext context, _NotificationItem item, NotificationModel notification) async {
    // Mark notification as read when user interacts with it
    if (!notification.isRead && notification.id != null) {
      _notificationCubit.markAsRead(notification.id!, _currentUserId);
    }
    
    switch (item.action) {
      case NotificationAction.getContact:
        if (notification.relatedPostId != null) {
          final postType = notification.type == 'item_found' ? 'found' : 'found';
          final unlockRepo = getIt<UnlockRepository>();
          
          // Check if already unlocked
          final isUnlocked = await unlockRepo.isPostUnlocked(
            notification.relatedPostId!.toString(), 
            postType
          );

          if (isUnlocked) {
            // Already unlocked, show contact info directly
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (_) => ContactUnlockedPopup(
                  userName: item.userName,
                  postId: notification.relatedPostId!,
                  postType: postType,
                ),
              );
            }
          } else {
            // Not unlocked, show payment popup
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (_) => PaymentPopup(
                  userName: item.userName,
                  itemTitle: item.itemTitle ?? AppLocalizations.of(context)!.yourItem,
                  postId: notification.relatedPostId!,
                  postType: postType,
                ),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.postIdNotAvailable),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
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

  Widget _buildAvatarPlaceholder() {
    IconData icon;
    if (item.isAdmin) {
      icon = Icons.admin_panel_settings;
    } else if (item.isSystem) {
      icon = Icons.stars;
    } else {
      icon = Icons.person;
    }
    
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: AppColors.primaryPurple,
        size: 24,
      ),
    );
  }

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
                child: (item.avatarUrl != null && item.avatarUrl!.isNotEmpty)
                    ? Image.network(
                        item.avatarUrl!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
                      )
                    : _buildAvatarPlaceholder(),
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
          // Only show action button if there's an action label (hide for admin notifications)
          if (item.actionLabel.isNotEmpty) ...[
            const SizedBox(height: 16),
            _NotificationActionButton(
              label: item.actionLabel,
              action: item.action,
              onTap: onAction,
            ),
          ],
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
    this.avatarUrl,
    required this.action,
    required this.actionLabel,
    this.itemTitle,
    this.isAdmin = false,
    this.isSystem = false,
  });

  final String userName;
  final String message;
  final String timeAgo;
  final String? avatarUrl;
  final NotificationAction action;
  final String actionLabel;
  final String? itemTitle;
  final bool isAdmin;
  final bool isSystem;
}

enum NotificationAction { getContact, confirmReturn }

