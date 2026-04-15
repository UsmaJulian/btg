import 'package:bloc_test/bloc_test.dart';
import 'package:btg/core/error/failures.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/transactions/domain/entities/transaction.dart';
import 'package:btg/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:btg/features/transactions/presentation/cubit/transactions_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTransactionsUsecase extends Mock
    implements GetTransactionsUsecase {}

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
      date: DateTime(2025, 1, 14, 9, 0),
    ),
  ];

  setUp(() {
    mockGetTransactions = MockGetTransactionsUsecase();
    cubit = TransactionsCubit(
      getTransactionsUsecase: mockGetTransactions,
    );
  });

  tearDown(() => cubit.close());

  group('TransactionsCubit', () {
    test('estado inicial debe ser TransactionsStatus.initial con lista vacía',
        () {
      expect(cubit.state.status, TransactionsStatus.initial);
      expect(cubit.state.transactions, isEmpty);
      expect(cubit.state.errorMessage, isNull);
    });

    blocTest<TransactionsCubit, TransactionsState>(
      'debe emitir [loading, loaded] cuando loadTransactions es exitoso',
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

    blocTest<TransactionsCubit, TransactionsState>(
      'debe emitir [loading, loaded] con lista vacía cuando no hay transacciones',
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
          transactions: [],
        ),
      ],
    );

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
        // clearError: true limpia errorMessage al emitir loading
        const TransactionsState(status: TransactionsStatus.loading),
        const TransactionsState(
          status: TransactionsStatus.loaded,
          transactions: [],
        ),
      ],
    );
  });
}
