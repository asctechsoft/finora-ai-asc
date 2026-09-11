import 'package:dsp_base/app_localize.dart';
import 'package:dsp_base/convenience_imports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../configs/pref_const.dart';
import '../../controller/user_profile_controller.dart';
import '../../models/ui_models/currency_info.dart';
import '../../models/ui_models/life_mode.dart';
import '../../values/app_colors.dart';
import '../../values/route_name.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (!mounted) return;
      setState(() => _version = '${info.version} (${info.buildNumber})');
    });
  }

  static const _sectionStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.heading);
  static const _divider = Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16);

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<UserProfileController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('tab_settings'.tr)),
      body: Obx(() => ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            children: [
              _ProfileHeader(profile: profile, onEditName: () => _editName(context, profile)),
              const SizedBox(height: 24),
              Text('settings_preferences'.tr, style: _sectionStyle),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _SettingsTile(
                  icon: profile.lifeMode.value.icon,
                  iconColor: profile.lifeMode.value.accent,
                  title: 'settings_life_mode'.tr,
                  value: profile.lifeMode.value.title,
                  onTap: () => _pickLifeMode(context, profile),
                ),
                _divider,
                _SettingsTile(
                  icon: Icons.attach_money_rounded,
                  iconColor: AppColors.positive,
                  title: 'settings_currency'.tr,
                  value: profile.baseCurrency.value,
                  onTap: () => _pickCurrency(context, profile),
                ),
                _divider,
                _SettingsTile(
                  icon: Icons.language_rounded,
                  iconColor: AppColors.info,
                  title: 'settings_language'.tr,
                  value: profile.language.value.startsWith('vi')
                      ? 'language_vietnamese'.tr
                      : 'language_english'.tr,
                  onTap: () => _pickLanguage(context, profile),
                ),
              ]),
              const SizedBox(height: 24),
              Text('settings_app'.tr, style: _sectionStyle),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _SettingsTile(
                  icon: Icons.notifications_rounded,
                  iconColor: AppColors.warning,
                  title: 'settings_notifications'.tr,
                  onTap: () => Get.toNamed(RouteName.notifications),
                ),
                _divider,
                _SettingsTile(
                  icon: Icons.pie_chart_rounded,
                  iconColor: AppColors.entertainment,
                  title: 'settings_budgets'.tr,
                  onTap: () => Get.toNamed(RouteName.budgetList),
                ),
                _divider,
                _SettingsTile(
                  icon: Icons.calendar_month_rounded,
                  iconColor: AppColors.livingTogether,
                  title: 'settings_calendar'.tr,
                  onTap: () => Get.toNamed(RouteName.calendar),
                ),
              ]),
              const SizedBox(height: 24),
              Text('settings_about'.tr, style: _sectionStyle),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: AppColors.textSecondary,
                  title: 'settings_app_version'.tr,
                  value: _version,
                ),
              ]),
            ],
          )),
    );
  }

  void _editName(BuildContext context, UserProfileController profile) {
    final ctrl = TextEditingController(text: profile.name.value);
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('settings_edit_name'.tr),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(hintText: 'settings_name_hint'.tr),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dctx), child: Text('cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(90, 44)),
            onPressed: () {
              final v = ctrl.text.trim();
              if (v.isNotEmpty) profile.setName(v);
              Navigator.pop(dctx);
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  void _pickLifeMode(BuildContext context, UserProfileController profile) {
    _showPicker(
      context,
      title: 'settings_choose_life_mode'.tr,
      children: LifeMode.values
          .map((mode) => _PickerRow(
                leading: Icon(mode.icon, color: mode.accent),
                title: mode.title,
                selected: profile.lifeMode.value == mode,
                onTap: () {
                  profile.setLifeMode(mode);
                  Navigator.pop(context);
                },
              ))
          .toList(),
    );
  }

  void _pickCurrency(BuildContext context, UserProfileController profile) {
    _showPicker(
      context,
      title: 'settings_choose_currency'.tr,
      children: CurrencyInfo.all
          .map((info) => _PickerRow(
                leading: Text(info.flag, style: const TextStyle(fontSize: 20)),
                title: '${info.code} — ${info.name}',
                selected: profile.baseCurrency.value == info.code,
                onTap: () {
                  profile.setBaseCurrency(info.code);
                  Navigator.pop(context);
                },
              ))
          .toList(),
    );
  }

  void _pickLanguage(BuildContext context, UserProfileController profile) {
    final options = [
      (code: 'en_US', locale: const Locale('en', 'US'), label: 'language_english'.tr),
      (code: 'vi_VN', locale: const Locale('vi', 'VN'), label: 'language_vietnamese'.tr),
    ];
    _showPicker(
      context,
      title: 'settings_choose_language'.tr,
      children: options
          .map((opt) => _PickerRow(
                leading: const Icon(Icons.language_rounded, color: AppColors.info),
                title: opt.label,
                selected: profile.language.value == opt.code,
                onTap: () {
                  profile.language.value = opt.code;
                  PrefAssist.setString(PrefConst.language, opt.code);
                  CommLocalize.setAppLocale(opt.locale);
                  Get.updateLocale(opt.locale);
                  Navigator.pop(context);
                },
              ))
          .toList(),
    );
  }

  void _showPicker(BuildContext context, {required String title, required List<Widget> children}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.heading)),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.5),
                child: SingleChildScrollView(child: Column(children: children)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserProfileController profile;
  final VoidCallback onEditName;
  const _ProfileHeader({required this.profile, required this.onEditName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration:
                const BoxDecoration(color: AppColors.primaryTintSoft, shape: BoxShape.circle),
            child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(profile.name.value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.heading)),
          ),
          IconButton(
            onPressed: onEditName,
            icon: const Icon(Icons.edit_rounded, color: AppColors.textSecondary, size: 20),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? value;
  final VoidCallback? onTap;
  const _SettingsTile(
      {required this.icon, required this.iconColor, required this.title, this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.heading, fontSize: 14)),
            ),
            if (value != null && value!.isNotEmpty)
              Text(value!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            if (onTap != null) ...[
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final bool selected;
  final VoidCallback onTap;
  const _PickerRow(
      {required this.leading, required this.title, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 30, child: Center(child: leading)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.heading, fontSize: 14)),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
