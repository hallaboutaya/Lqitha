import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/background_gradient.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/popups/popup_payment.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static final List<_NotificationItem> _notifications = [
    _NotificationItem(
      userName: 'Ahmed Benali',
      message: 'says they found your lost wallet!',
      timeAgo: '5 min ago',
      avatarUrl: 'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=200',
      action: NotificationAction.getContact,
      actionLabel: 'Get Contact',
      itemTitle: 'Black leather wallet',
    ),
    _NotificationItem(
      userName: 'Sarah Johnson',
      message: 'unlocked your contact information',
      timeAgo: '1 hour ago',
      avatarUrl: 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=200',
      action: NotificationAction.confirmReturn,
      actionLabel: 'Yes, I got my item back',
    ),
    _NotificationItem(
      userName: 'Karim Meziane',
      message: 'says they found your phone!',
      timeAgo: '3 hours ago',
      avatarUrl: 'https://images.unsplash.com/photo-1544723795-432537bda887?w=200',
      action: NotificationAction.getContact,
      actionLabel: 'Get Contact',
      itemTitle: 'Silver iPhone 13',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'Notifications',
                  subtitle: 'Stay updated on your items',
                  accentColor:  AppColors.primaryPurple,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: _notifications.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24, top: 12),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _notifications[index];
                      return _NotificationCard(
                        item: item,
                        onAction: () => _handleAction(context, item),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, _NotificationItem item) {
    switch (item.action) {
      case NotificationAction.getContact:
        showDialog(
          context: context,
          builder: (_) => PaymentPopup(
            userName: item.userName,
            itemTitle: item.itemTitle ?? 'your item',
          ),
        );
        break;
      case NotificationAction.confirmReturn:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thanks! We marked ${item.userName} as reunited.'),
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

