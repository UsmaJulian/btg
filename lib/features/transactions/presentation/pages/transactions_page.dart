import 'package:btg/core/utils/currency_formatter.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:btg/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones'),
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          if (state.status == TransactionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TransactionsStatus.error) {
            return Center(
              child: Text('Error: ${state.errorMessage}'),
            );
          }

          if (state.transactions.isEmpty) {
            return const Center(
              child: Text('No hay transacciones registradas'),
            );
          }

          return ListView.builder(
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return ListTile(
                leading: Icon(
                  transaction.type == TransactionType.subscription
                      ? Icons.arrow_circle_down
                      : Icons.arrow_circle_up,
                  color: transaction.type == TransactionType.subscription
                      ? Colors.green
                      : Colors.orange,
                ),
                title: Text(transaction.fundName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${transaction.type == TransactionType.subscription ? 'Suscripcion' : 'Cancelacion'} - ${DateFormat('dd/MM/yyyy HH:mm').format(transaction.date)}',
                    ),
                    if (transaction.notificationMethod != null)
                      Text(
                        'Notificacion: ${transaction.notificationMethod}',
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
                trailing: Text(
                  CurrencyFormatter.format(transaction.amount),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
