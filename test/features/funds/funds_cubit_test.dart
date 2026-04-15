import 'package:bloc_test/bloc_test.dart';
import 'package:btg/core/error/failures.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/funds/domain/usecases/cancel_fund_usecase.dart';
import 'package:btg/features/funds/domain/usecases/get_funds_usecase.dart';
import 'package:btg/features/funds/domain/usecases/subscribe_fund_usecase.dart';
import 'package:btg/features/funds/presentation/cubit/funds_cubit.dart';

import 'package:btg/features/wallet/domain/entities/wallet.dart';
import 'package:btg/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFundsUsecase extends Mock implements GetFundsUsecase {}

class MockSubscribeFundUsecase extends Mock implements SubscribeFundUsecase {}

class MockCancelFundUsecase extends Mock implements CancelFundUsecase {}

class MockGetWalletUsecase extends Mock implements GetWalletUsecase {}

/// {@template funds_cubit_test}
/// Suite de pruebas para [FundsCubit] utilizando el patrón [blocTest].
///
/// Cubre escenarios de carga de fondos, suscripciones exitosas, fallos por saldo
/// insuficiente y cancelaciones.
/// {@endtemplate}
void main() {
  late FundsCubit cubit;
  late MockGetFundsUsecase mockGetFunds;
  late MockSubscribeFundUsecase mockSubscribe;
  late MockCancelFundUsecase mockCancel;
  late MockGetWalletUsecase mockGetWallet;

  const tFunds = [
    Fund(
      id: '1',
      name: 'Test Fund',
      minAmount: 50000,
      category: FundCategory.fic,
    ),
  ];
  const tWallet = Wallet(balance: 500000);

  setUp(() {
    mockGetFunds = MockGetFundsUsecase();
    mockSubscribe = MockSubscribeFundUsecase();
    mockCancel = MockCancelFundUsecase();
    mockGetWallet = MockGetWalletUsecase();
    cubit = FundsCubit(
      getFundsUsecase: mockGetFunds,
      subscribeFundUsecase: mockSubscribe,
      cancelFundUsecase: mockCancel,
      getWalletUsecase: mockGetWallet,
    );
  });

  tearDown(() => cubit.close());

  /// {@macro funds_cubit_test}
  group('FundsCubit', () {
    /// {@template funds_load_test}
    /// Verifica que el estado cambie a cargado tras obtener datos de fondos y saldo.
    /// {@endtemplate}
    blocTest<FundsCubit, FundsState>(
      'debe emitir [loading, loaded] cuando se cargan los fondos con éxito',
      build: () {
        when(
          () => mockGetFunds(),
        ).thenAnswer((_) async => const Success(tFunds));
        when(
          () => mockGetWallet(),
        ).thenAnswer((_) async => const Success(tWallet));
        return cubit;
      },
      act: (cubit) => cubit.loadFunds(),
      expect: () => [
        const FundsState(status: FundsStatus.loading),
        const FundsState(
          status: FundsStatus.loaded,
          funds: tFunds,
        ),
      ],
    );

    /// {@template funds_insufficient_balance_test}
    /// Valida el manejo de errores cuando el saldo es insuficiente para suscribirse.
    /// {@endtemplate}
    blocTest<FundsCubit, FundsState>(
      'debe emitir [loading, error] cuando el saldo es insuficiente',
      build: () {
        when(
          () => mockSubscribe.call(
            fundId: any(named: 'fundId'),
            notificationMethod: any(named: 'notificationMethod'),
          ),
        ).thenAnswer(
          (_) async =>
              Error(InsufficientBalanceFailure(required: 1000, available: 0)),
        );
        return cubit;
      },
      act: (cubit) =>
          cubit.subscribeToFund(fundId: '1', notificationMethod: 'sms'),
      expect: () => [
        const FundsState(status: FundsStatus.loading),
        predicate<FundsState>(
          (state) =>
              state.status == FundsStatus.error &&
              state.errorMessage!.contains('Saldo insuficiente'),
        ),
      ],
    );
  });
}
