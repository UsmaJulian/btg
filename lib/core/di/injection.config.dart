// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/funds/data/datasources/funds_local_datasource.dart'
    as _i716;
import '../../features/funds/data/repositories/fund_repository_impl.dart'
    as _i985;
import '../../features/funds/domain/repositories/i_funds_repository.dart'
    as _i382;
import '../../features/funds/domain/usecases/cancel_fund_usecase.dart' as _i592;
import '../../features/funds/domain/usecases/get_funds_usecase.dart' as _i98;
import '../../features/funds/domain/usecases/subscribe_fund_usecase.dart'
    as _i475;
import '../../features/funds/presentation/cubit/funds_cubit.dart' as _i156;
import '../../features/transactions/data/datasources/transactions_local_datasource.dart'
    as _i26;
import '../../features/transactions/data/repositories/transactions_repository_impl.dart'
    as _i373;
import '../../features/transactions/domain/repositories/i_transactions_repository.dart'
    as _i621;
import '../../features/transactions/domain/usecases/get_transactions_usecase.dart'
    as _i974;
import '../../features/transactions/presentation/cubit/transactions_cubit.dart'
    as _i598;
import '../../features/wallet/data/datasources/wallet_local_datasource.dart'
    as _i114;
import '../../features/wallet/data/repositories/wallet_repository_impl.dart'
    as _i690;
import '../../features/wallet/domain/repositories/i_wallet_repository.dart'
    as _i955;
import '../../features/wallet/domain/usecases/get_wallet_usecase.dart' as _i920;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i716.FundsLocalDatasource>(
      () => _i716.FundsLocalDatasource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i26.TransactionsLocalDatasource>(
      () => _i26.TransactionsLocalDatasource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i114.WalletLocalDatasource>(
      () => _i114.WalletLocalDatasource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i955.IWalletRepository>(
      () => _i690.WalletRepositoryImpl(gh<_i114.WalletLocalDatasource>()),
    );
    gh.lazySingleton<_i621.ITransactionsRepository>(
      () => _i373.TransactionsRepositoryImpl(
        gh<_i26.TransactionsLocalDatasource>(),
      ),
    );
    gh.factory<_i974.GetTransactionsUsecase>(
      () => _i974.GetTransactionsUsecase(gh<_i621.ITransactionsRepository>()),
    );
    gh.lazySingleton<_i382.IFundsRepository>(
      () => _i985.FundRepositoryImpl(
        gh<_i716.FundsLocalDatasource>(),
        gh<_i114.WalletLocalDatasource>(),
        gh<_i621.ITransactionsRepository>(),
      ),
    );
    gh.factory<_i920.GetWalletUsecase>(
      () => _i920.GetWalletUsecase(gh<_i955.IWalletRepository>()),
    );
    gh.factory<_i592.CancelFundUsecase>(
      () => _i592.CancelFundUsecase(gh<_i382.IFundsRepository>()),
    );
    gh.factory<_i98.GetFundsUsecase>(
      () => _i98.GetFundsUsecase(gh<_i382.IFundsRepository>()),
    );
    gh.factory<_i475.SubscribeFundUsecase>(
      () => _i475.SubscribeFundUsecase(gh<_i382.IFundsRepository>()),
    );
    gh.factory<_i598.TransactionsCubit>(
      () => _i598.TransactionsCubit(
        getTransactionsUsecase: gh<_i974.GetTransactionsUsecase>(),
      ),
    );
    gh.factory<_i156.FundsCubit>(
      () => _i156.FundsCubit(
        getFundsUsecase: gh<_i98.GetFundsUsecase>(),
        subscribeFundUsecase: gh<_i475.SubscribeFundUsecase>(),
        cancelFundUsecase: gh<_i592.CancelFundUsecase>(),
        getWalletUsecase: gh<_i920.GetWalletUsecase>(),
      ),
    );
    return this;
  }
}
