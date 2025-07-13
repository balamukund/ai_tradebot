import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChartBottomSheetWidget extends StatefulWidget {
  final DraggableScrollableController controller;
  final Function(String) onIndicatorToggle;
  final bool showVolume;
  final bool showRSI;
  final bool showMACD;
  final bool showAISignals;

  const ChartBottomSheetWidget({
    Key? key,
    required this.controller,
    required this.onIndicatorToggle,
    required this.showVolume,
    required this.showRSI,
    required this.showMACD,
    required this.showAISignals,
  }) : super(key: key);

  @override
  State<ChartBottomSheetWidget> createState() => _ChartBottomSheetWidgetState();
}

class _ChartBottomSheetWidgetState extends State<ChartBottomSheetWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: widget.controller,
      initialChildSize: 0.15,
      minChildSize: 0.15,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.shadowColor,
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      icon: CustomIconWidget(
                        iconName: 'tune',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                      text: 'Indicators',
                    ),
                    Tab(
                      icon: CustomIconWidget(
                        iconName: 'draw',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                      text: 'Drawing',
                    ),
                    Tab(
                      icon: CustomIconWidget(
                        iconName: 'filter_alt',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                      text: 'Filters',
                    ),
                  ],
                  labelColor: AppTheme.lightTheme.primaryColor,
                  unselectedLabelColor:
                      AppTheme.lightTheme.textTheme.bodyMedium?.color,
                  indicatorColor: AppTheme.lightTheme.primaryColor,
                  dividerColor: Colors.transparent,
                ),
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildIndicatorsTab(scrollController),
                    _buildDrawingTab(scrollController),
                    _buildFiltersTab(scrollController),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIndicatorsTab(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      children: [
        // Technical Indicators Section
        _buildSectionHeader('Technical Indicators'),
        SizedBox(height: 2.h),

        _buildIndicatorTile(
          'Volume',
          'Display volume bars below price chart',
          'bar_chart',
          widget.showVolume,
          () => widget.onIndicatorToggle('volume'),
        ),

        _buildIndicatorTile(
          'RSI (14)',
          'Relative Strength Index momentum oscillator',
          'trending_up',
          widget.showRSI,
          () => widget.onIndicatorToggle('rsi'),
        ),

        _buildIndicatorTile(
          'MACD (12,26,9)',
          'Moving Average Convergence Divergence',
          'show_chart',
          widget.showMACD,
          () => widget.onIndicatorToggle('macd'),
        ),

        SizedBox(height: 3.h),

        // AI Features Section
        _buildSectionHeader('AI Features'),
        SizedBox(height: 2.h),

        _buildIndicatorTile(
          'AI Signals',
          'Machine learning generated buy/sell signals',
          'psychology',
          widget.showAISignals,
          () => widget.onIndicatorToggle('signals'),
        ),

        _buildFeatureTile(
          'Pattern Recognition',
          'Identify chart patterns automatically',
          'pattern',
          false,
        ),

        _buildFeatureTile(
          'Support & Resistance',
          'AI-detected key price levels',
          'horizontal_rule',
          true,
        ),

        SizedBox(height: 3.h),

        // Moving Averages Section
        _buildSectionHeader('Moving Averages'),
        SizedBox(height: 2.h),

        _buildFeatureTile(
          'SMA (20, 50)',
          'Simple Moving Averages',
          'timeline',
          false,
        ),

        _buildFeatureTile(
          'EMA (12, 26)',
          'Exponential Moving Averages',
          'timeline',
          true,
        ),

        SizedBox(height: 10.h), // Extra space for scrolling
      ],
    );
  }

  Widget _buildDrawingTab(ScrollController scrollController) {
    final drawingTools = [
      {
        'name': 'Trend Line',
        'icon': 'trending_up',
        'description': 'Draw trend lines'
      },
      {
        'name': 'Horizontal Line',
        'icon': 'horizontal_rule',
        'description': 'Support/Resistance levels'
      },
      {
        'name': 'Rectangle',
        'icon': 'crop_square',
        'description': 'Price ranges'
      },
      {
        'name': 'Fibonacci',
        'icon': 'functions',
        'description': 'Fibonacci retracements'
      },
      {
        'name': 'Text Note',
        'icon': 'text_fields',
        'description': 'Add text annotations'
      },
      {
        'name': 'Arrow',
        'icon': 'arrow_forward',
        'description': 'Point to specific areas'
      },
    ];

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      children: [
        _buildSectionHeader('Drawing Tools'),
        SizedBox(height: 2.h),
        ...drawingTools.map((tool) => _buildDrawingTool(
              tool['name'] as String,
              tool['description'] as String,
              tool['icon'] as String,
            )),
        SizedBox(height: 3.h),
        _buildSectionHeader('Actions'),
        SizedBox(height: 2.h),
        _buildActionTile(
          'Clear All Drawings',
          'Remove all drawn objects',
          'clear',
          () => _clearAllDrawings(),
        ),
        _buildActionTile(
          'Save Template',
          'Save current chart setup',
          'save',
          () => _saveTemplate(),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildFiltersTab(ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      children: [
        _buildSectionHeader('Signal Filters'),
        SizedBox(height: 2.h),
        _buildFilterSlider(
          'Minimum Confidence',
          'Only show signals above this confidence level',
          0.7,
          (value) {},
        ),
        SizedBox(height: 2.h),
        _buildFilterDropdown(
          'Signal Types',
          'Filter by signal type',
          ['All Signals', 'Buy Only', 'Sell Only'],
          'All Signals',
          (value) {},
        ),
        SizedBox(height: 3.h),
        _buildSectionHeader('Chart Settings'),
        SizedBox(height: 2.h),
        _buildFilterDropdown(
          'Chart Type',
          'Select chart display type',
          ['Candlestick', 'Line', 'Area', 'OHLC'],
          'Candlestick',
          (value) {},
        ),
        SizedBox(height: 2.h),
        _buildFilterDropdown(
          'Color Scheme',
          'Chart color theme',
          ['Default', 'Dark', 'High Contrast'],
          'Default',
          (value) {},
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  Widget _buildIndicatorTile(
    String title,
    String description,
    String iconName,
    bool isEnabled,
    VoidCallback onToggle,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEnabled
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3)
              : AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.dividerColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: isEnabled
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.textTheme.bodyMedium?.color ??
                      Colors.grey,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) => onToggle(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(
    String title,
    String description,
    String iconName,
    bool isEnabled,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.lightTheme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.textTheme.bodyMedium?.color ??
                  Colors.grey,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: null, // Disabled for demo
          ),
        ],
      ),
    );
  }

  Widget _buildDrawingTool(String name, String description, String iconName) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          name,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          description,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        onTap: () => _selectDrawingTool(name),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String description,
    String iconName,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.getWarningColor(true),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          description,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      ),
    );
  }

  Widget _buildFilterSlider(
    String title,
    String description,
    double value,
    Function(double) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text('0%', style: AppTheme.lightTheme.textTheme.labelSmall),
              Expanded(
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                  min: 0.0,
                  max: 1.0,
                ),
              ),
              Text('100%', style: AppTheme.lightTheme.textTheme.labelSmall),
            ],
          ),
          Center(
            child: Text(
              '${(value * 100).toStringAsFixed(0)}%',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String title,
    String description,
    List<String> options,
    String selectedValue,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(height: 2.h),
          DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            ),
            items: options
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _selectDrawingTool(String toolName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$toolName selected. Tap on chart to draw.'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _clearAllDrawings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All drawings cleared'),
        backgroundColor: AppTheme.getWarningColor(true),
      ),
    );
  }

  void _saveTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chart template saved'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }
}
