import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/features/mainPage/settings/preferences_provider.dart';

class SettingsComponents {
  static const String currencyKey = 'currency_preference';
  static const String weightUnitKey = 'weight_unit_preference';
}

class ProteinTargetTile extends StatefulWidget {
  const ProteinTargetTile({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<ProteinTargetTile> createState() => _ProteinTargetTileState();
}

class _ProteinTargetTileState extends State<ProteinTargetTile> {
  final _preferencesProvider = PreferencesProvider();

  @override
  void initState() {
    super.initState();
    _preferencesProvider.loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(15),
      child: ListenableBuilder(
        listenable: _preferencesProvider,
        builder: (context, _) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/target_icon.svg",
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic Setting',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Currency:- ${_preferencesProvider.currency}, Weight:- ${_preferencesProvider.weightUnit}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final String title;
  final dynamic icon;
  final VoidCallback onTap;
  final Widget? trailing;

  const SettingsListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: icon is IconData
                    ? Icon(
                        icon as IconData,
                        color: theme.colorScheme.onSecondaryContainer,
                      )
                    : SvgPicture.asset(
                        icon as String,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onSecondaryContainer,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 16),
                trailing!,
              ] else ...[
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
