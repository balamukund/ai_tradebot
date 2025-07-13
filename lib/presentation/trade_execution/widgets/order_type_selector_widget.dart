import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderTypeSelectorWidget extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const OrderTypeSelectorWidget({
    Key? key,
    required this.selectedType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderTypes = ['Market', 'Limit', 'Stop-Loss'];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Type',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: orderTypes.map((type) {
                final isSelected = selectedType == type;
                final isFirst = orderTypes.first == type;
                final isLast = orderTypes.last == type;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTypeChanged(type),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft:
                              isFirst ? const Radius.circular(8) : Radius.zero,
                          bottomLeft:
                              isFirst ? const Radius.circular(8) : Radius.zero,
                          topRight:
                              isLast ? const Radius.circular(8) : Radius.zero,
                          bottomRight:
                              isLast ? const Radius.circular(8) : Radius.zero,
                        ),
                      ),
                      child: Text(
                        type,
                        textAlign: TextAlign.center,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (selectedType != 'Market') ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    size: 16,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      selectedType == 'Limit'
                          ? 'Order will execute only at specified price or better'
                          : 'Order will trigger when price reaches stop-loss level',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
