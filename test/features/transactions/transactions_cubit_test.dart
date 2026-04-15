import 'package:bloc_test/bloc_test.dart';
import 'package:btg/core/error/failures.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:btg/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:btg/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// {@template mock_get_transactions_usecase}
/// Mock del caso de uso para obtener transacciones.
/// {@endtemplate}
class MockGetTransactionsUsecase extends Mock
    implements GetTransactionsUsecase {}

/// {@template transactions_cubit_test}
/// Suite de pruebas para [TransactionsCubit].
///
/// Verifica el flujo de carga del historial de transacciones, incluyendo
/// estados de éxito, error y limpieza de mensajes previos.
/// {@endtemplate}
void main() {
  late TransactionsCubit cubit;
  late MockGetTransactionsUsecase mockGetTransactions;

  final tTransactions = [
    Transaction(
      id: 'tx-1',
      fundId: '1',
      fundName: 'FPV_BTG_RECAUDADORA',
      amount: 75000,
      type: TransactionType.subscription,
      notificationMethod: 'email',
      date: DateTime(2025, 1, 15, 10, 30),
    ),
    Transaction(
      id: 'tx-2',
      fundId: '2',
      fundName: 'DEUDAPRIVADA',
      amount: 50000,
      type: TransactionType.cancellation,
      date: DateTime(2025, 1, 14, 9),
    ),
  ];

  setUp(() {
    mockGetTransactions = MockGetTransactionsUsecase();
    cubit = TransactionsCubit(getTransactionsUsecase: mockGetTransactions);
  });

  tearDown(() => cubit.close());

  group('TransactionsCubit Tests', () {
    /// {@template transactions_load_success_test}
    /// Verifica que se emitan los estados [loading, loaded] con la lista de datos.
    /// {@endtemplate}
    blocTest<TransactionsCubit, TransactionsState>(
      'debe emitir [loading, loaded] cuando loadTransactions tiene éxito',
      build: () {
        when(() => mockGetTransactions.call()).thenAnswer(
          (_) async => Success(tTransactions),
        );
        return cubit;
      },
      act: (c) => c.loadTransactions(),
      expect: () => [
        const TransactionsState(status: TransactionsStatus.loading),
        TransactionsState(
          status: TransactionsStatus.loaded,
          transactions: tTransactions,
        ),
      ],
    );

    /// {@template transactions_load_empty_test}
    /// Verifica el comportamiento cuando no existen transacciones registradas.
    /// {@endtemplate}
    blocTest<TransactionsCubit, TransactionsState>(
      'debe emitir [loading, loaded] con lista vacía si no hay datos',
      build: () {
        when(() => mockGetTransactions.call()).thenAnswer(
          (_) async => const Success([]),
        );
        return cubit;
      },
      act: (c) => c.loadTransactions(),
      expect: () => [
        const TransactionsState(status: TransactionsStatus.loading),
        const TransactionsState(
          status: TransactionsStatus.loaded,
        ),
      ],
    );

    /// {@template transactions_load_error_test}
    /// Verifica que se capture el error y se asigne el mensaje al estado.
    /// {@endtemplate}
    blocTest<TransactionsCubit, TransactionsState>(
      'debe emitir [loading, error] cuando loadTransactions falla',
      build: () {
        when(() => mockGetTransactions.call()).thenAnswer(
          (_) async => const Error(CacheFailure('Error al leer caché')),
        );
        return cubit;
      },
      act: (c) => c.loadTransactions(),
      expect: () => [
        const TransactionsState(status: TransactionsStatus.loading),
        predicate<TransactionsState>(
          (s) =>
              s.status == TransactionsStatus.error &&
              s.errorMessage == 'Error al leer caché',
        ),
      ],
    );

    /// {@template transactions_clear_error_test}
    /// Valida que el [errorMessage] previo sea eliminado al iniciar una nueva carga.
    /// {@endtemplate}
    blocTest<TransactionsCubit, TransactionsState>(
      'debe limpiar errorMessage previo al iniciar una nueva carga',
      build: () {
        when(() => mockGetTransactions.call()).thenAnswer(
          (_) async => const Success([]),
        );
        return cubit;
      },
      seed: () => const TransactionsState(
        status: TransactionsStatus.error,
        errorMessage: 'Error anterior',
      ),
      act: (c) => c.loadTransactions(),
      expect: () => [
        const TransactionsState(status: TransactionsStatus.loading),
        const TransactionsState(
          status: TransactionsStatus.loaded,
        ),
      ],
    );
  });
}
