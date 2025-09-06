import 'package:flutter/material.dart';

class LifeLineButtons extends StatelessWidget {
  final bool hasPoll;
  final bool hasTime;
  final bool hasBomb;
  final bool hasSkip;
  final Function(String) onUseLifeline;

  const LifeLineButtons({
    super.key,
    required this.hasPoll,
    required this.hasTime,
    required this.hasBomb,
    required this.hasSkip,
    required this.onUseLifeline,
  });

  Widget _lifelineButton(BuildContext context, String label, IconData icon, bool enabled, String key) {
    return GestureDetector(
      onTap: enabled ? () => onUseLifeline(key) : () => _showPurchaseBottomSheet(context, key),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: enabled ? Colors.orange : Colors.grey,
                child: Icon(icon, color: Colors.white),
              ),
              if (!enabled)
                const Positioned(
                  top: 0,
                  right: 2,
                  child: Icon(Icons.lock, size: 16, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }

  void _showPurchaseBottomSheet(BuildContext context, String lifelineType) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lifeline Locked',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You have already used this lifeline. Unlock it with coins?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // No Thanks Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.orange),
                      ),
                      child: Text(
                        'No Thanks',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Purchase Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _purchaseLifeline(lifelineType);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        '50 Coins',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _purchaseLifeline(String lifelineType) {
    // Implement your purchase logic here
    // This would typically involve deducting coins and enabling the lifeline
    print('Purchasing $lifelineType lifeline for 50 coins');

    // After successful purchase, you would call onUseLifeline to enable it
    // onUseLifeline(lifelineType);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _lifelineButton(context, 'Poll', Icons.people, hasPoll, 'poll'),
          _lifelineButton(context, 'Time', Icons.timer, hasTime, 'time'),
          _lifelineButton(context, 'Bomb', Icons.bolt, hasBomb, 'bomb'),
          _lifelineButton(context, 'Skip', Icons.skip_next, hasSkip, 'skip'),
        ],
      ),
    );
  }
}
