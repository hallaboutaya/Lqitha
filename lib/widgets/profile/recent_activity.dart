import 'package:flutter/material.dart';
import 'package:hopefully_last/l10n/app_localizations.dart';
import '../../core/utils/time_formatter.dart';
import '../../data/repositories/rewards_repository.dart';
import '../../data/models/point_transaction.dart';
import '../../services/auth_service.dart';

class RecentActivity extends StatefulWidget {
  const RecentActivity({super.key});

  @override
  State<RecentActivity> createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
  final RewardsRepository _rewardsRepo = RewardsRepository();
  final AuthService _authService = AuthService();
  List<PointTransaction> _transactions = [];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Delay until after first frame to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransactions();
    });
  }

  Future<void> _loadTransactions() async {
    try {
      final userId = _authService.currentUserId;
      
      if (userId != null) {
        final transactions = await _rewardsRepo.getTransactions(userId.toString(), limit: 5);
        
        if (mounted) {
          setState(() {
            _transactions = transactions;
            _loading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _loading = false;
            _errorMessage = 'Not logged in';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recentActivity,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_errorMessage != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red),
            ),
            child: Text(
              '${l10n.error}: ${_errorMessage == 'Not logged in' ? l10n.notLoggedIn : _errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          )
        else if (_transactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  l10n.noRecentActivity,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.createPostToEarnPoints,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          )
        else
          ..._transactions.map((t) => _activityTile(t, l10n)),
      ],
    );
  }

  String _localizeDescription(String description, AppLocalizations l10n) {
    // Basic mapping for backend-provided descriptions
    if (description.contains('Your found post was approved')) return l10n.postApproved;
    if (description.contains('Your found post was rejected')) return l10n.postRejected;
    if (description.contains('Your lost post was approved')) return l10n.postApproved;
    if (description.contains('Your lost post was rejected')) return l10n.postRejected;
    return description;
  }

  Widget _activityTile(PointTransaction transaction, AppLocalizations l10n) {
    final isPositive = transaction.points > 0;
    final timeAgo = TimeFormatter.formatTimeAgoFromString(transaction.createdAt, l10n);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _localizeDescription(transaction.description, l10n),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  timeAgo,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${transaction.points}',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
