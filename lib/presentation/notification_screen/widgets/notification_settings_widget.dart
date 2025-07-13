import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  bool _pushNotifications = true;
  bool _tradeAlerts = true;
  bool _marketUpdates = true;
  bool _aiSignals = true;
  bool _systemMessages = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';
  bool _weekendNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                Text(
                  'Notification Settings',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Theme.of(context).dividerColor),

          // Settings content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // General settings
                  _buildSectionHeader('General'),
                  _buildSettingItem(
                    title: 'Push Notifications',
                    subtitle: 'Receive notifications on this device',
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                    },
                    icon: Icons.notifications_outlined,
                  ),

                  SizedBox(height: 3.h),

                  // Notification types
                  _buildSectionHeader('Notification Types'),
                  _buildSettingItem(
                    title: 'Trade Alerts',
                    subtitle: 'Buy/sell signals and order updates',
                    value: _tradeAlerts,
                    onChanged: (value) {
                      setState(() {
                        _tradeAlerts = value;
                      });
                    },
                    icon: Icons.trending_up,
                    enabled: _pushNotifications,
                  ),
                  _buildSettingItem(
                    title: 'Market Updates',
                    subtitle: 'Market opening, closing, and major events',
                    value: _marketUpdates,
                    onChanged: (value) {
                      setState(() {
                        _marketUpdates = value;
                      });
                    },
                    icon: Icons.show_chart,
                    enabled: _pushNotifications,
                  ),
                  _buildSettingItem(
                    title: 'AI Signals',
                    subtitle: 'Lorentzian and ML strategy alerts',
                    value: _aiSignals,
                    onChanged: (value) {
                      setState(() {
                        _aiSignals = value;
                      });
                    },
                    icon: Icons.psychology,
                    enabled: _pushNotifications,
                  ),
                  _buildSettingItem(
                    title: 'System Messages',
                    subtitle: 'App updates and maintenance alerts',
                    value: _systemMessages,
                    onChanged: (value) {
                      setState(() {
                        _systemMessages = value;
                      });
                    },
                    icon: Icons.info_outline,
                    enabled: _pushNotifications,
                  ),

                  SizedBox(height: 3.h),

                  // Sound & vibration
                  _buildSectionHeader('Sound & Vibration'),
                  _buildSettingItem(
                    title: 'Sound',
                    subtitle: 'Play sound for notifications',
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                    },
                    icon: Icons.volume_up_outlined,
                    enabled: _pushNotifications,
                  ),
                  _buildSettingItem(
                    title: 'Vibration',
                    subtitle: 'Vibrate for notifications',
                    value: _vibrationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _vibrationEnabled = value;
                      });
                    },
                    icon: Icons.vibration,
                    enabled: _pushNotifications,
                  ),

                  SizedBox(height: 3.h),

                  // Quiet hours
                  _buildSectionHeader('Quiet Hours'),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.do_not_disturb_on_outlined,
                              color: _pushNotifications
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                'Quiet Hours',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _pushNotifications
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTimeSelector(
                                label: 'Start',
                                time: _quietHoursStart,
                                onChanged: (time) {
                                  setState(() {
                                    _quietHoursStart = time;
                                  });
                                },
                                enabled: _pushNotifications,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: _buildTimeSelector(
                                label: 'End',
                                time: _quietHoursEnd,
                                onChanged: (time) {
                                  setState(() {
                                    _quietHoursEnd = time;
                                  });
                                },
                                enabled: _pushNotifications,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Advanced settings
                  _buildSectionHeader('Advanced'),
                  _buildSettingItem(
                    title: 'Weekend Notifications',
                    subtitle: 'Receive notifications on weekends',
                    value: _weekendNotifications,
                    onChanged: (value) {
                      setState(() {
                        _weekendNotifications = value;
                      });
                    },
                    icon: Icons.weekend_outlined,
                    enabled: _pushNotifications,
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    bool enabled = true,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: enabled
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled ? value : false,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required String time,
    required Function(String) onChanged,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled
          ? () async {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: int.parse(time.split(':')[0]),
                  minute: int.parse(time.split(':')[1]),
                ),
              );
              if (selectedTime != null) {
                onChanged(
                  '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                );
              }
            }
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: enabled
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
