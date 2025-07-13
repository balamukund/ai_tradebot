import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivePositionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> positions;
  final Function(String) onModifyStopLoss;
  final Function(String) onBookProfit;
  final Function(String) onClosePosition;

  const ActivePositionsWidget({
    Key? key,
    required this.positions,
    required this.onModifyStopLoss,
    required this.onBookProfit,
    required this.onClosePosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return Container(
        height: 30.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'trending_flat',
                color: Colors.grey,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'No Active Positions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Start trading to see your positions here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final position = positions[index];
        return _buildPositionCard(context, position);
      },
    );
  }

  Widget _buildPositionCard(
      BuildContext context, Map<String, dynamic> position) {
    final symbol = position["symbol"] as String;
    final entryPrice = position["entryPrice"] as double;
    final currentPrice = position["currentPrice"] as double;
    final quantity = position["quantity"] as int;
    final pnl = position["pnl"] as double;
    final pnlPercent = position["pnlPercent"] as double;
    final stopLoss = position["stopLoss"] as double;
    final target = position["target"] as double;

    final isProfit = pnl >= 0;

    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Dismissible(
        key: Key(symbol),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.getErrorColor(true),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Close',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Close Position'),
              content:
                  Text('Are you sure you want to close \$symbol position?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Close'),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          onClosePosition(symbol);
        },
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '\$quantity shares',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${pnl.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isProfit
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.getErrorColor(true),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    '${pnlPercent >= 0 ? '+' : ''}${pnlPercent.toStringAsFixed(2)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isProfit
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.getErrorColor(true),
                        ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(context, 'Entry Price',
                          '₹${entryPrice.toStringAsFixed(2)}'),
                      _buildDetailItem(context, 'Current Price',
                          '₹${currentPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailItem(context, 'Stop Loss',
                          '₹${stopLoss.toStringAsFixed(2)}'),
                      _buildDetailItem(
                          context, 'Target', '₹${target.toStringAsFixed(2)}'),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => onModifyStopLoss(symbol),
                          icon: CustomIconWidget(
                            iconName: 'edit',
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          ),
                          label: Text('Modify SL'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onBookProfit(symbol),
                          icon: CustomIconWidget(
                            iconName: 'monetization_on',
                            color: Colors.white,
                            size: 16,
                          ),
                          label: Text('Book Profit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
