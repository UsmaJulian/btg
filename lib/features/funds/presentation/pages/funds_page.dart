import 'dart:developer';

import 'package:btg/core/utils/currency_formatter.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/funds/presentation/cubit/funds_cubit.dart';
import 'package:btg/features/funds/presentation/widgets/fund_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:showcaseview/showcaseview.dart';

/// {@template funds_page}
/// Pantalla principal que visualiza el catálogo de fondos y el saldo del usuario.
///
/// Utiliza un [BlocConsumer] para reaccionar a cambios de estado emitiendo
/// diálogos de error o reconstruyendo la lista de fondos de manera reactiva.
///
/// Incluye [ShowcaseView] para guiar al usuario en la navegación al historial,
/// la visualización del saldo disponible y las acciones de los fondos.
/// {@endtemplate}
class FundsPage extends StatefulWidget {
  /// {@macro funds_page}
  const FundsPage({super.key});

  @override
  State<FundsPage> createState() => _FundsPageState();
}

class _FundsPageState extends State<FundsPage> {
  /// Key para el showcase del botón de historial
  final GlobalKey _historyShowcaseKey = GlobalKey();

  /// Key para el showcase del saldo disponible
  final GlobalKey _balanceShowcaseKey = GlobalKey();

  /// Key para el showcase de información general de la tarjeta
  final GlobalKey _cardInfoShowcaseKey = GlobalKey();

  /// Key para el showcase de suscripción
  final GlobalKey _subscribeShowcaseKey = GlobalKey();

  /// Key para el showcase de cancelación
  final GlobalKey _cancelShowcaseKey = GlobalKey();

  /// Bandera para asegurar que el tutorial solo se muestre una vez
  bool _hasShownShowcase = false;

  @override
  void initState() {
    super.initState();

    // Registrar la configuración global de ShowCaseView
    ShowcaseView.register(
      onStart: (index, key) {
        log('Showcase iniciado: index=$index, key=$key');
      },
      onComplete: (index, key) {
        log('Showcase completado: index=$index, key=$key');
      },
      onDismiss: (key) {
        log('Showcase descartado: key=$key');
      },
      globalTooltipActionConfig: const TooltipActionConfig(
        position: TooltipActionPosition.outside,
      ),
      globalTooltipActions: [
        // Se elimina el TooltipActionButton de tipo previous
        TooltipActionButton(
          type: TooltipDefaultActionType.next,
          // Ocultamos el botón "Siguiente" dinámicamente según el último paso posible
          hideActionWidgetForShowcase: [
            _balanceShowcaseKey,
            _cancelShowcaseKey,
            _subscribeShowcaseKey,
            _cardInfoShowcaseKey,
          ],
        ),
      ],
    );

    // Verificamos si ya hay datos en caché para iniciar el showcase inmediatamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkAndStartShowcase(context.read<FundsCubit>().state);
      }
    });
  }

  @override
  void dispose() {
    ShowcaseView.get().unregister();
    super.dispose();
  }

  /// Evalúa el estado actual e inicia el showcase dinámicamente asegurando
  /// que los widgets objetivo ya existan en el árbol.
  void _checkAndStartShowcase(FundsState state) {
    if (_hasShownShowcase || state.status == FundsStatus.loading) return;

    // Si no hay fondos, no podemos mostrar las llaves de las tarjetas
    if (state.funds.isEmpty) return;

    _hasShownShowcase = true;

    // Construimos la lista de llaves de forma dinámica basada en el estado
    final keysToStart = <GlobalKey>[
      _historyShowcaseKey,
      _balanceShowcaseKey,
      _cardInfoShowcaseKey,
    ];

    if (state.funds.any((f) => !f.isSubscribed)) {
      keysToStart.add(_subscribeShowcaseKey);
    }
    if (state.funds.any((f) => f.isSubscribed)) {
      keysToStart.add(_cancelShowcaseKey);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowcaseView.get().startShowCase(keysToStart);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BTG - Fondos'),
        actions: [
          Showcase(
            key: _historyShowcaseKey,
            description:
                'Toca aquí para ver el historial de tus suscripciones y '
                'transacciones realizadas.',
            title: 'Historial de Transacciones',
            tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Colors.white,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            descTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            child: IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => context.push('/transactions'),
            ),
          ),
        ],
      ),
      body: BlocConsumer<FundsCubit, FundsState>(
        listener: (context, state) {
          /// Monitoriza el estado para desplegar feedback visual en caso de error.
          if (state.status == FundsStatus.error && state.errorMessage != null) {
            _showErrorDialog(context, state.errorMessage!);
          }

          /// Dispara el showcase una vez que los datos han sido cargados.
          _checkAndStartShowcase(state);
        },
        builder: (context, state) {
          if (state.status == FundsStatus.loading && state.funds.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Pre-calculamos los índices para evitar lógicas pesadas o estados mutables
          // durante la construcción de la lista.
          final firstIndex = state.funds.isNotEmpty ? 0 : -1;
          final firstUnsubIndex = state.funds.indexWhere(
            (f) => !f.isSubscribed,
          );
          final firstSubIndex = state.funds.indexWhere((f) => f.isSubscribed);

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
                    Showcase(
                      key: _balanceShowcaseKey,
                      description:
                          'Este es tu saldo actual. Asegúrate de tener '
                          'suficiente dinero disponible antes de suscribirte '
                          'a un fondo.',
                      title: 'Tu Saldo',
                      tooltipBackgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondary,
                      textColor: Colors.white,
                      titleTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      descTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      child: Text(
                        CurrencyFormatter.format(state.balance),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
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

                    // Instancia base del widget
                    Widget cardWidget = FundCard(
                      fund: fund,
                      onTap: () =>
                          context.push('/funds/${fund.id}', extra: fund),
                      onSubscribe: () => _showSubscribeDialog(context, fund),
                      onCancel: fund.isSubscribed
                          ? () => _showCancelDialog(context, fund)
                          : null,
                    );

                    // Composición limpia para evitar anidamiento excesivo.
                    // Envolvemos condicionalmente solo las tarjetas objetivo.
                    if (index == firstSubIndex) {
                      cardWidget = Showcase(
                        key: _cancelShowcaseKey,
                        title: 'Cancelar Suscripción',
                        description:
                            'Si ya estás suscrito, utiliza el botón de cancelar en la tarjeta para retirar tu participación y recibir el reembolso de tu dinero.',
                        tooltipBackgroundColor: Theme.of(
                          context,
                        ).colorScheme.error,
                        textColor: Colors.white,
                        titleTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        descTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        child: cardWidget,
                      );
                    }

                    if (index == firstUnsubIndex) {
                      cardWidget = Showcase(
                        key: _subscribeShowcaseKey,
                        title: 'Suscribirse al Fondo',
                        description:
                            'Utiliza el botón de "Suscribirse" en esta tarjeta para invertir tu saldo disponible en este fondo.',
                        tooltipBackgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary,
                        textColor: Colors.white,
                        titleTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        descTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        child: cardWidget,
                      );
                    }

                    if (index == firstIndex) {
                      cardWidget = Showcase(
                        key: _cardInfoShowcaseKey,
                        title: 'Detalles del Fondo',
                        description:
                            'Toca en cualquier parte de la tarjeta para ver información detallada, estadísticas y el rendimiento histórico del fondo.',
                        tooltipBackgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        textColor: Colors.white,
                        titleTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        descTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        child: cardWidget,
                      );
                    }

                    return cardWidget;
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
