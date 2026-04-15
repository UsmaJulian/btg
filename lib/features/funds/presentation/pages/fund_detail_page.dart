import 'package:btg/core/theme/app_theme.dart';
import 'package:btg/core/utils/currency_formatter.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// {@template fund_detail_page}
/// Página de detalle que muestra la información extendida de un fondo.
///
/// Recibe la entidad [Fund] a través del objeto extra del router.
/// {@endtemplate}
class FundDetailPage extends StatelessWidget {
  /// {@macro fund_detail_page}
  const FundDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fund = GoRouterState.of(context).extra as Fund?;

    if (fund == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del Fondo')),
        body: const Center(
          child: Text('No se encontró información del fondo.'),
        ),
      );
    }

    final isFpv = fund.category == FundCategory.fpv;
    final categoryColor = isFpv ? Colors.blue : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text(fund.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de encabezado
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Ícono de categoría
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isFpv ? Icons.account_balance : Icons.trending_up,
                            color: categoryColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fund.category.name.toUpperCase(),
                                style: TextStyle(
                                  color: categoryColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                fund.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(),
                    ),
                    _DetailRow(
                      icon: Icons.monetization_on_outlined,
                      label: 'Monto mínimo de vinculación',
                      value: CurrencyFormatter.format(fund.minAmount),
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(
                      icon: Icons.fingerprint,
                      label: 'Identificador del fondo',
                      value: fund.id,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SubscriptionStatus(isSubscribed: fund.isSubscribed),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionStatus extends StatelessWidget {
  const _SubscriptionStatus({required this.isSubscribed});

  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSubscribed
            ? AppTheme.success.withOpacity(0.1)
            : AppTheme.textSecondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSubscribed
              ? AppTheme.success.withOpacity(0.2)
              : AppTheme.textSecondary.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSubscribed ? Icons.check_circle : Icons.info_outline,
            color: isSubscribed ? AppTheme.success : AppTheme.textSecondary,
          ),
          const SizedBox(width: 12),
          Text(
            isSubscribed
                ? 'Estás suscrito a este fondo'
                : 'No tienes suscripción activa en este fondo',
            style: TextStyle(
              color: isSubscribed ? AppTheme.success : AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
