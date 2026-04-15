import 'package:bloc/bloc.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/funds/domain/entities/fund.dart';
import 'package:btg/features/funds/domain/usecases/cancel_fund_usecase.dart';
import 'package:btg/features/funds/domain/usecases/get_funds_usecase.dart';
import 'package:btg/features/funds/domain/usecases/subscribe_fund_usecase.dart';
import 'package:btg/features/wallet/domain/entities/wallet.dart';
import 'package:btg/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'funds_state.dart';

/// {@template funds_cubit}
/// Manejador de la lógica de negocio para la gestión de fondos de inversión.
///
/// Este [Cubit] coordina la carga de fondos disponibles, el saldo de la billetera
/// y las operaciones de suscripción o cancelación, interactuando con la capa
/// de dominio a través de múltiples casos de uso.
/// {@endtemplate}
@injectable
class FundsCubit extends Cubit<FundsState> {
  /// {@macro funds_cubit}
  FundsCubit({
    required GetFundsUsecase getFundsUsecase,
    required SubscribeFundUsecase subscribeFundUsecase,
    required CancelFundUsecase cancelFundUsecase,
    required GetWalletUsecase getWalletUsecase,
  }) : _getFundsUsecase = getFundsUsecase,
       _subscribeFundUsecase = subscribeFundUsecase,
       _cancelFundUsecase = cancelFundUsecase,
       _getWalletUsecase = getWalletUsecase,
       super(const FundsState());

  final GetFundsUsecase _getFundsUsecase;
  final SubscribeFundUsecase _subscribeFundUsecase;
  final CancelFundUsecase _cancelFundUsecase;
  final GetWalletUsecase _getWalletUsecase;

  /// {@template load_funds}
  /// Carga de forma concurrente la lista de fondos y el estado de la billetera.
  ///
  /// Actualiza el estado a [FundsStatus.loading] y, tras la respuesta de los
  /// casos de uso, emite [FundsStatus.loaded] o [FundsStatus.error].
  /// {@endtemplate}
  Future<void> loadFunds() async {
    emit(state.copyWith(status: FundsStatus.loading, clearError: true));

    final results = await Future.wait<dynamic>([
      _getFundsUsecase(),
      _getWalletUsecase(),
    ]);

    final fundsResult = results[0] as Result<List<Fund>>;
    final walletResult = results[1] as Result<Wallet>;

    if (fundsResult is Success<List<Fund>> && walletResult is Success<Wallet>) {
      emit(
        state.copyWith(
          status: FundsStatus.loaded,
          funds: fundsResult.data,
          balance: walletResult.data.balance,
        ),
      );
    } else {
      final error = fundsResult is Error
          ? (fundsResult as Error).failure.message
          : (walletResult as Error).failure.message;
      emit(
        state.copyWith(
          status: FundsStatus.error,
          errorMessage: error,
        ),
      );
    }
  }

  /// Gestiona la suscripción del usuario a un fondo específico.
  ///
  /// Requiere el [fundId] y el [notificationMethod]. En caso de éxito,
  /// refresca la información global de fondos.
  Future<void> subscribeToFund({
    required String fundId,
    required String notificationMethod,
  }) async {
    emit(state.copyWith(status: FundsStatus.loading, clearError: true));

    final result = await _subscribeFundUsecase(
      fundId: fundId,
      notificationMethod: notificationMethod,
    );

    if (result is Success) {
      await loadFunds();
    } else if (result is Error) {
      emit(
        state.copyWith(
          status: FundsStatus.error,
          errorMessage: (result as Error).failure.message,
        ),
      );
    }
  }

  /// Cancela una suscripción activa a un fondo.
  Future<void> cancelFund({required String fundId}) async {
    emit(state.copyWith(status: FundsStatus.loading, clearError: true));

    final result = await _cancelFundUsecase(fundId: fundId);

    if (result is Success) {
      await loadFunds();
    } else if (result is Error) {
      emit(
        state.copyWith(
          status: FundsStatus.error,
          errorMessage: (result as Error).failure.message,
        ),
      );
    }
  }
}
