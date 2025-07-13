import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationCardWidget extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onMarkAsRead;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
    required this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification['isRead'] as bool;
    final type = notification['type'] as String;
    final priority = notification['priority'] as String;
    final timestamp = notification['timestamp'] as DateTime;

    return Dismissible(
      key: Key(notification['id']),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Mark as read/unread
          onMarkAsRead();
          return false;
        } else {
          // Delete
          return await _showDeleteConfirmation(context);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isRead
                    ? Theme.of(context).dividerColor
                    : Theme.of(context).colorScheme.primary.withAlpha(77),
                width: isRead ? 1 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withAlpha(26),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Type indicator
                    Container(
                      padding: EdgeInsets.all(1.5.w),
                      decoration: BoxDecoration(
                        color: _getTypeColor(context, type).withAlpha(26),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getTypeIcon(type),
                        color: _getTypeColor(context, type),
                        size: 16,
                      ),
                    ),

                    SizedBox(width: 2.w),

                    // Type label
                    Text(
                      type,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: _getTypeColor(context, type),
                      ),
                    ),

                    // Priority indicator
                    if (priority == 'high') ...[
                      SizedBox(width: 2.w),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],

                    Spacer(),

                    // Timestamp
                    Text(
                      _formatTimestamp(timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    // Unread indicator
                    if (!isRead) ...[
                      SizedBox(width: 2.w),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 2.h),

                // Title
                Text(
                  notification['title'],
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 1.h),

                // Message
                Text(
                  notification['message'],
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),

                // Additional content based on type
                if (notification['symbol'] != null) ...[
                  SizedBox(height: 2.h),
                  _buildAdditionalContent(context),
                ],

                // Action buttons
                if (_hasActions()) ...[
                  SizedBox(height: 2.h),
                  _buildActionButtons(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: isLeft
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isLeft ? Icons.mark_email_read : Icons.delete,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isLeft ? 'Mark Read' : 'Delete',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalContent(BuildContext context) {
    final symbol = notification['symbol'] as String?;
    final confidence = notification['confidence'] as double?;
    final price = notification['price'] as double?;
    final pnl = notification['pnl'] as int?;
    final percentage = notification['percentage'] as double?;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          if (symbol != null) ...[
            Icon(
              Icons.trending_up,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 1.w),
            Text(
              symbol,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
          if (price != null) ...[
            if (symbol != null) SizedBox(width: 4.w),
            Icon(
              Icons.currency_rupee,
              size: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            Text(
              price.toStringAsFixed(2),
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
          if (confidence != null) ...[
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getConfidenceColor(confidence).withAlpha(26),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${(confidence * 100).toInt()}% confidence',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: _getConfidenceColor(confidence),
                ),
              ),
            ),
          ],
          if (pnl != null && percentage != null) ...[
            Spacer(),
            Icon(
              pnl >= 0 ? Icons.trending_up : Icons.trending_down,
              size: 16,
              color: pnl >= 0 ? Colors.green : Colors.red,
            ),
            SizedBox(width: 1.w),
            Text(
              '${pnl >= 0 ? '+' : ''}₹${pnl.abs()}',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: pnl >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final type = notification['type'] as String;

    return Row(
      children: [
        if (type == 'Trade Alert' || type == 'AI Signal') ...[
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to trade execution
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Opening trade execution...',
                      style: GoogleFonts.inter(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Trade Now',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // View details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Opening details...',
                    style: GoogleFonts.inter(),
                  ),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'View Details',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _hasActions() {
    final type = notification['type'] as String;
    return type == 'Trade Alert' ||
        type == 'AI Signal' ||
        type == 'Market Update';
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete Notification',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Are you sure you want to delete this notification?',
              style: GoogleFonts.inter(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel', style: GoogleFonts.inter()),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Delete',
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Trade Alert':
        return Icons.trending_up;
      case 'Market Update':
        return Icons.show_chart;
      case 'AI Signal':
        return Icons.psychology;
      case 'System Message':
        return Icons.info_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getTypeColor(BuildContext context, String type) {
    switch (type) {
      case 'Trade Alert':
        return Theme.of(context).colorScheme.primary;
      case 'Market Update':
        return Theme.of(context).colorScheme.secondary;
      case 'AI Signal':
        return Theme.of(context).colorScheme.tertiary;
      case 'System Message':
        return Theme.of(context).colorScheme.outline;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
