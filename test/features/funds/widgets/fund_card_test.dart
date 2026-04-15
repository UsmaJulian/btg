import 'package:btg/core/utils/currency_formatter.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/funds/presentation/widgets/fund_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// {@template fund_card_test}
/// Pruebas unitarias y de widgets para [FundCard].
///
/// Verifica la correcta visualización de la información del fondo,
/// los estados de suscripción y la interacción con los botones de acción.
/// {@endtemplate}
void main() {
  group('FundCard Widget Test', () {
    const tFund = Fund(
      id: '1',
      name: 'Fondo de Deuda',
      minAmount: 75000,
      category: FundCategory.fic,
    );

    /// {@template fund_card_rendering_test}
    /// Prueba la renderización inicial del card con datos base.
    /// {@endtemplate}
    testWidgets('debe mostrar información básica del fondo', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FundCard(fund: tFund),
          ),
        ),
      );

      expect(find.text('Fondo de Deuda'), findsOneWidget);
      expect(
        find.text('Monto mínimo: ${CurrencyFormatter.format(75000)}'),
        findsOneWidget,
      );
      expect(find.text('SUSCRIBIRSE'), findsOneWidget);
    });

    /// {@template fund_card_subscribed_state_test}
    /// Verifica que el widget cambie visualmente cuando el fondo ya está suscrito.
    /// {@endtemplate}
    testWidgets(
      'debe mostrar estado suscrito cuando fund.isSubscribed es true',
      (tester) async {
        final subscribedFund = tFund.copyWith(isSubscribed: true);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FundCard(fund: subscribedFund),
            ),
          ),
        );

        expect(find.text('Suscrito'), findsOneWidget);
        expect(find.text('CANCELAR'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
      },
    );

    /// {@template fund_card_interaction_test}
    /// Valida que el callback [onSubscribe] se ejecute al interactuar con el botón.
    /// {@endtemplate}
    testWidgets('debe llamar a onSubscribe cuando se presiona el botón', (
      tester,
    ) async {
      var called = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FundCard(
              fund: tFund,
              onSubscribe: () => called = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('SUSCRIBIRSE'));
      expect(called, isTrue);
    });
  });
}
