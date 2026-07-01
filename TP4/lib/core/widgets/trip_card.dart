import 'package:flutter/material.dart';

import '../../models/trip.dart';
import 'network_image_box.dart';
import 'pc_badge.dart';
import 'pc_button.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.isFavorite,
    this.onDetails,
    this.onBuy,
    this.onFavorite,
  });

  final Trip trip;
  final bool isFavorite;
  final VoidCallback? onDetails;
  final VoidCallback? onBuy;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final highContrast = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: highContrast ? colors.outline : const Color(0xFFF3F4F6),
          width: highContrast ? 2 : 1,
        ),
        boxShadow: [
          if (!highContrast)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              NetworkImageBox(
                url: trip.imageUrl,
                height: 150,
                width: double.infinity,
                borderRadius: 0,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.70),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              if (trip.seats == 0)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                    child: const Center(
                      child: PcBadge(label: 'Esgotado', tone: PcBadgeTone.red),
                    ),
                  ),
                )
              else if (trip.seats <= 4)
                Positioned(
                  top: 12,
                  left: 12,
                  child: PcBadge(
                    label: 'Últimas ${trip.seats} vagas',
                    tone: PcBadgeTone.orange,
                  ),
                ),
              Positioned(
                left: 16,
                bottom: 14,
                child: Text(
                  trip.vessel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  onPressed: onFavorite,
                  tooltip: isFavorite
                      ? 'Remover dos favoritos'
                      : 'Adicionar aos favoritos',
                  constraints: const BoxConstraints.tightFor(
                    width: 48,
                    height: 48,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: highContrast
                        ? colors.surfaceContainerHighest
                        : Colors.white.withValues(alpha: 0.92),
                    shape: const CircleBorder(),
                  ),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? (highContrast ? colors.primary : Colors.redAccent)
                        : colors.onSurfaceVariant,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      color: colors.onSurfaceVariant,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${trip.origin} -> ${trip.destination}',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(Icons.star, color: colors.primary, size: 15),
                    Text(
                      '${trip.rating}',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Meta(
                      icon: Icons.calendar_month_outlined,
                      label: trip.date,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Meta(
                        icon: Icons.schedule,
                        label: '${trip.time} - ${trip.duration}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'R\$ ${trip.price}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: colors.primary,
                                    fontSize: 18,
                                  ),
                            ),
                            TextSpan(
                              text: '/pessoa',
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PcButton(
                      label: 'Detalhes',
                      variant: PcButtonVariant.outline,
                      small: true,
                      onPressed: onDetails,
                    ),
                    const SizedBox(width: 8),
                    if (trip.seats > 0)
                      PcButton(label: 'Comprar', small: true, onPressed: onBuy),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
