import 'package:btg/core/theme/app_theme.dart';
import 'package:btg/core/utils/currency_formatter.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FundDetailPage extends StatelessWidget {
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
                            color: categoryColor.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: categoryColor.shade200),
                          ),
                          child: Icon(
                            isFpv
                                ? Icons.savings_outlined
                                : Icons.account_balance_outlined,
                            color: categoryColor.shade700,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fund.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: categoryColor.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: categoryColor.shade200,
                                  ),
                                ),
                                child: Text(
                                  fund.category.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: categoryColor.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Estado de suscripción
            _StatusBanner(isSubscribed: fund.isSubscribed),

            const SizedBox(height: 16),

            // Detalles del fondo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información del fondo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(height: 24),
                    _DetailRow(
                      icon: Icons.attach_money,
                      label: 'Monto mínimo de inversión',
                      value: CurrencyFormatter.format(fund.minAmount),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.category_outlined,
                      label: 'Tipo de fondo',
                      value: isFpv
                          ? 'FPV — Fondo de Pensiones Voluntarias'
                          : 'FIC — Fondo de Inversión Colectiva',
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.tag,
                      label: 'Identificador',
                      value: fund.id,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.isSubscribed});

  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSubscribed
            ? AppTheme.success.withValues(alpha: 0.1)
            : AppTheme.textSecondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSubscribed
              ? AppTheme.success.withValues(alpha: 0.3)
              : AppTheme.textSecondary.withValues(alpha: 0.2),
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
