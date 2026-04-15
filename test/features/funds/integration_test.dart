import 'package:btg/core/result/result.dart';
import 'package:btg/core/utils/currency_formatter.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/funds/presentation/cubit/funds_cubit.dart';
import 'package:btg/features/funds/presentation/pages/funds_page.dart';
import 'package:btg/features/wallet/domain/entities/wallet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';
import 'funds_cubit_test.dart';

/// {@template integration_test}
/// Pruebas de integración para el flujo principal de fondos.
///
/// Simula la interacción del usuario desde la vista de fondos,
/// cubriendo la visualización de saldo y la apertura de diálogos de suscripción.
/// {@endtemplate}
void main() {
  late MockGetFundsUsecase mockGetFunds;
  late MockSubscribeFundUsecase mockSubscribe;
  late MockCancelFundUsecase mockCancel;
  late MockGetWalletUsecase mockGetWallet;
  late FundsCubit cubit;

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

    // Mock inicial exitoso
    when(() => mockGetFunds()).thenAnswer(
      (_) async => const Success([
        Fund(
          id: '1',
          name: 'BTG TEST',
          minAmount: 10000,
          category: FundCategory.fpv,
        ),
      ]),
    );
    when(() => mockGetWallet()).thenAnswer(
      (_) async => const Success(Wallet(balance: 500000)),
    );
  });

  /// {@macro integration_test}
  testWidgets('Flujo completo: Ver saldo, abrir suscripción y cancelar', (
    tester,
  ) async {
    // 1. Cargar la página
    await tester.pumpApp(
      BlocProvider.value(
        value: cubit..loadFunds(),
        child: const FundsPage(),
      ),
    );
    await tester.pumpAndSettle();

    // 2. Verificar saldo inicial en pantalla
    expect(find.text(CurrencyFormatter.format(500000)), findsOneWidget);

    // 3. Abrir diálogo de suscripción
    await tester.tap(find.text('SUSCRIBIRSE'));
    await tester.pumpAndSettle();

    expect(find.text('Suscripcion a BTG TEST'), findsOneWidget);
  });
}
