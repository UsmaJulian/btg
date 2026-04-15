import 'package:btg/core/utils/currency_formatter.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/funds/presentation/cubit/funds_cubit.dart';
import 'package:btg/features/funds/presentation/widgets/fund_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// {@template funds_page}
/// Pantalla principal que visualiza el catálogo de fondos y el saldo del usuario.
///
/// Utiliza un [BlocConsumer] para reaccionar a cambios de estado emitiendo
/// diálogos de error o reconstruyendo la lista de fondos de manera reactiva.
/// {@endtemplate}
class FundsPage extends StatelessWidget {
  /// {@macro funds_page}
  const FundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BTG - Fondos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/transactions'),
          ),
        ],
      ),
      body: BlocConsumer<FundsCubit, FundsState>(
        listener: (context, state) {
          /// Monitoriza el estado para desplegar feedback visual en caso de error.
          if (state.status == FundsStatus.error && state.errorMessage != null) {
            _showErrorDialog(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          if (state.status == FundsStatus.loading && state.funds.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              /// Header que visualiza el saldo actual formateado.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Saldo Disponible:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(state.balance),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              /// Listado dinámico de fondos utilizando tarjetas personalizadas.
              Expanded(
                child: ListView.builder(
                  itemCount: state.funds.length,
                  itemBuilder: (context, index) {
                    final fund = state.funds[index];
                    return FundCard(
                      fund: fund,
                      onTap: () =>
                          context.push('/funds/${fund.id}', extra: fund),
                      onSubscribe: () => _showSubscribeDialog(context, fund),
                      onCancel: fund.isSubscribed
                          ? () => _showCancelDialog(context, fund)
                          : null,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Despliega el flujo de suscripción con selección de método de notificación.
  void _showSubscribeDialog(BuildContext context, Fund fund) {
    var notificationMethod = 'email';
    final fundsCubit = context.read<FundsCubit>();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (statefulContext, setState) => AlertDialog(
          title: Text('Suscripcion a ${fund.name}'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monto mínimo: ${CurrencyFormatter.format(fund.minAmount)}',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Método de notificación:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                RadioListTile<String>(
                  title: const Text('Email'),
                  value: 'email',
                  groupValue: notificationMethod,
                  onChanged: (value) =>
                      setState(() => notificationMethod = value!),
                ),
                RadioListTile<String>(
                  title: const Text('SMS'),
                  value: 'sms',
                  groupValue: notificationMethod,
                  onChanged: (value) =>
                      setState(() => notificationMethod = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                fundsCubit.subscribeToFund(
                  fundId: fund.id,
                  notificationMethod: notificationMethod,
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }

  /// Despliega el diálogo de confirmación para la cancelación de un fondo.
  void _showCancelDialog(BuildContext context, Fund fund) {
    final fundsCubit = context.read<FundsCubit>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancelar suscripción'),
        content: SizedBox(
          width: 400,
          child: Text(
            '¿Deseas cancelar tu participación en ${fund.name}?\n\n'
            'Se reembolsará ${CurrencyFormatter.format(fund.minAmount)} a tu saldo.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              fundsCubit.cancelFund(fundId: fund.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  /// Visualiza errores críticos en la operación del usuario.
  void _showErrorDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('No se puede completar'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
