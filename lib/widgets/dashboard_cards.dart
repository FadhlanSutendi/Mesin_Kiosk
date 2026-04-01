import 'package:flutter/material.dart';

// ─── MODEL ────────────────────────────────────────────────────────────────────

class MenuCardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  const MenuCardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });
}

// ─── MENU GRID ────────────────────────────────────────────────────────────────

class DashboardMenuGrid extends StatelessWidget {
  final List<MenuCardItem> items;

  const DashboardMenuGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        final double cardHeight = isWide ? 180 : 165;

        if (items.length == 3 && isWide) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: cardHeight,
                      child: _MenuCard(item: items[0]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: cardHeight,
                      child: _MenuCard(item: items[1]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: cardHeight,
                width: double.infinity,
                child: _MenuCard(item: items[2]),
              ),
            ],
          );
        }

        return GridView.count(
          crossAxisCount: isWide ? 2 : 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isWide ? 2.45 : 2.1,
          children: items.map((item) => _MenuCard(item: item)).toList(),
        );
      },
    );
  }
}

// ─── MENU CARD ────────────────────────────────────────────────────────────────

class _MenuCard extends StatelessWidget {
  final MenuCardItem item;

  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: item.cardColor.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5A5855),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── INFO ROW ─────────────────────────────────────────────────────────────────

class DashboardInfoRow extends StatelessWidget {
  final bool isDesktop;

  const DashboardInfoRow({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            label: 'Antrian Aktif',
            value: '47',
            sub: 'pasien menunggu',
            showBadge: false,
            isDesktop: isDesktop,
            cardColor: const Color(0xFFEAF4FC), // Biru redup
            textColor: const Color(0xFF0270B0),
          ),
        ),
        SizedBox(width: isDesktop ? 16 : 12),
        Expanded(
          child: _InfoCard(
            label: 'Dokter Aktif',
            value: '5',
            sub: '',
            showBadge: true,
            isDesktop: isDesktop,
            cardColor: const Color(0xFFEAF4F2), // Hijau redup
            textColor: const Color(0xFF0A8F5E),
          ),
        ),
      ],
    );
  }
}

// ─── INFO CARD ────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final bool showBadge;
  final bool isDesktop;
  final Color cardColor;
  final Color textColor;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.showBadge,
    required this.isDesktop,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: isDesktop ? 180 : 160),
      padding: EdgeInsets.all(isDesktop ? 22 : 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: isDesktop ? 12 : 11,
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.8),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isDesktop ? 40 : 34,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          if (showBadge)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 10 : 8,
                vertical: isDesktop ? 5 : 4,
              ),
              decoration: BoxDecoration(
                color: textColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: textColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'online sekarang',
                    style: TextStyle(
                      fontSize: isDesktop ? 11 : 10,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              sub,
              style: TextStyle(
                fontSize: isDesktop ? 13 : 12,
                color: textColor.withOpacity(0.8),
              ),
            ),
        ],
      ),
    );
  }
}
