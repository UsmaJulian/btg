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

void main() {
  late FundsCubit cubit;
  late MockGetFundsUsecase mockGetFunds;
  late MockSubscribeFundUsecase mockSubscribe;
  late MockCancelFundUsecase mockCancel;
  late MockGetWalletUsecase mockGetWallet;

  final tFunds = [
    const Fund(
      id: '1',
      name: 'Fondo Test',
      minAmount: 50000,
      category: FundCategory.fpv,
    ),
  ];
  final tWallet = const Wallet(balance: 500000);

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

  group('FundsCubit', () {
    blocTest<FundsCubit, FundsState>(
      'debe emitir [loading, loaded] cuando loadFunds es exitoso',
      build: () {
        when(
          () => mockGetFunds.call(),
        ).thenAnswer((_) async => Success(tFunds));
        when(
          () => mockGetWallet.call(),
        ).thenAnswer((_) async => Success(tWallet));
        return cubit;
      },
      act: (cubit) => cubit.loadFunds(),
      expect: () => [
        const FundsState(status: FundsStatus.loading),
        FundsState(status: FundsStatus.loaded, funds: tFunds, balance: 500000),
      ],
    );

    blocTest<FundsCubit, FundsState>(
      'debe emitir error cuando no hay saldo suficiente al suscribirse',
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
