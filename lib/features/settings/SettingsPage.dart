import 'package:flutter/material.dart';
import 'package:myapp/common/theme/theme_provider.dart';
import 'package:myapp/features/settings/SettingsComponents.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/locale/locale_provider.dart';
import '../../l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri.parse(
        'mailto:missioninvictus@gmail.com?subject=Pet Tracker Support');
    try {
      if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch email');
      }
    } catch (e) {
      print('Error launching email: $e');
    }
  }

  void _launchPlayStore() async {
    final Uri playStoreUri = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.invictus.pettracker');

    if (await canLaunchUrl(playStoreUri)) {
      await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  final bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            fontFamily: 'PTSerif',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            theme,
            AppLocalizations.of(context)!.appearance,
            [
              _buildThemeModeSelector(theme, themeProvider),
              const SizedBox(height: 16),
              _buildColorThemeSelector(theme, themeProvider),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            theme,
            AppLocalizations.of(context)!.settingsSection,
            [
              SettingsListTile(
                title: AppLocalizations.of(context)!.basicSettings,
                icon: Icons.settings_rounded,
                onTap: () async {
                  // await ProteinTargetSheet.show(context);
                },
              ),
              const SizedBox(height: 12),
              SettingsListTile(
                title: AppLocalizations.of(context)!.support,
                icon: Icons.support_agent_rounded,
                onTap: widget._launchEmail,
              ),
              const SizedBox(height: 12),
              SettingsListTile(
                title: AppLocalizations.of(context)!.privacyPolicy,
                icon: 'assets/images/privacy_icon.svg',
                onTap: () => widget._launchURL(
                    'https://animal-tracker.blogspot.com/p/privacy-policy.html'),
              ),
              const SizedBox(height: 12),
              SettingsListTile(
                title: AppLocalizations.of(context)!.termsOfService,
                icon: 'assets/images/terms_icon.svg',
                onTap: () => widget._launchURL(
                    'https://animal-tracker.blogspot.com/p/terms-and-conditions.html'),
              ),
              const SizedBox(height: 12),
              SettingsListTile(
                title: AppLocalizations.of(context)!.language,
                icon: Icons.language_rounded,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.language),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text("English"),
                            onTap: () async {
                              await context
                                  .read<LocaleProvider>()
                                  .setLocale(const Locale('en'));
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text("हिन्दी"),
                            onTap: () async {
                              await context
                                  .read<LocaleProvider>()
                                  .setLocale(const Locale('hi'));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // const SizedBox(height: 12),
              // SettingsListTile(
              //   title: 'Generate Sample Data',
              //   icon: 'assets/images/data_icon.svg',
              //   onTap: _generateSampleData,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeSelector(ThemeData theme, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.themeMode,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          segments: <ButtonSegment<ThemeMode>>[
            ButtonSegment<ThemeMode>(
              value: ThemeMode.system,
              label: Text(AppLocalizations.of(context)!.system),
              icon: const Icon(Icons.brightness_auto),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.light,
              label: Text(AppLocalizations.of(context)!.light),
              icon: const Icon(Icons.light_mode),
            ),
          ],
          selected: const {ThemeMode.light},
          onSelectionChanged: (Set<ThemeMode> selected) async {
            await themeProvider.setThemeMode(ThemeMode.light);
          },
        ),
      ],
    );
  }

  Widget _buildColorThemeSelector(
      ThemeData theme, ThemeProvider themeProvider) {
    final List<Color> themeColors = [
      const Color(0xFF6750A4), // Purple
      const Color(0xFF006C51), // Green
      const Color(0xFF0061A4), // Blue
      const Color(0xFFB3261E), // Red
      const Color(0xFF006874), // Teal
      const Color(0xFFFFC0CB), // Pink
    ];

    final List<String> themeNames = [
      AppLocalizations.of(context)!.purple,
      AppLocalizations.of(context)!.green,
      AppLocalizations.of(context)!.blue,
      AppLocalizations.of(context)!.red,
      AppLocalizations.of(context)!.teal,
      AppLocalizations.of(context)!.pink,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.colorTheme,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            themeColors.length,
            (index) => GestureDetector(
              onTap: () async {
                if (_isPremium || index == 0) {
                  await themeProvider.setColorTheme(index);
                } else {}
              },
              child: Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: themeColors[index],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: themeProvider.colorTheme == index
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: themeProvider.colorTheme == index
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                  if (!_isPremium && index > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_rounded,
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(ThemeData theme, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
