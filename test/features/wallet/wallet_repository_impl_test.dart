import 'package:btg/core/error/failures.dart';
import 'package:btg/core/result/result.dart';
import 'package:btg/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:btg/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:btg/features/wallet/domain/entities/wallet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWalletLocalDatasource extends Mock implements WalletLocalDatasource {}

void main() {
  late WalletRepositoryImpl repository;
  late MockWalletLocalDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockWalletLocalDatasource();
    repository = WalletRepositoryImpl(mockDatasource);
  });

  group('WalletRepositoryImpl', () {
    group('getWallet()', () {
      test('debe retornar Success con el saldo actual del datasource', () async {
        when(() => mockDatasource.getBalance()).thenAnswer((_) async => 500000);

        final result = await repository.getWallet();

        expect(result, isA<Success<Wallet>>());
        expect((result as Success<Wallet>).data.balance, 500000);
        verify(() => mockDatasource.getBalance()).called(1);
      });

      test('debe retornar CacheFailure cuando el datasource lanza excepción',
          () async {
        when(() => mockDatasource.getBalance())
            .thenThrow(Exception('Error de lectura'));

        final result = await repository.getWallet();

        expect(result, isA<Error<Wallet>>());
        expect((result as Error<Wallet>).failure, isA<CacheFailure>());
      });
    });

    group('deductAmount()', () {
      test('debe restar el monto y retornar el saldo actualizado', () async {
        when(() => mockDatasource.deductAmount(75000))
            .thenAnswer((_) async {});
        when(() => mockDatasource.getBalance()).thenAnswer((_) async => 425000);

        final result = await repository.deductAmount(75000);

        expect(result, isA<Success<Wallet>>());
        expect((result as Success<Wallet>).data.balance, 425000);
        verify(() => mockDatasource.deductAmount(75000)).called(1);
      });

      test('debe retornar CacheFailure si deductAmount lanza excepción',
          () async {
        when(() => mockDatasource.deductAmount(any()))
            .thenThrow(Exception('Error al escribir'));

        final result = await repository.deductAmount(75000);

        expect(result, isA<Error<Wallet>>());
        expect((result as Error<Wallet>).failure, isA<CacheFailure>());
      });
    });

    group('addAmount()', () {
      test('debe sumar el monto y retornar el saldo actualizado', () async {
        when(() => mockDatasource.addAmount(50000))
            .thenAnswer((_) async {});
        when(() => mockDatasource.getBalance()).thenAnswer((_) async => 550000);

        final result = await repository.addAmount(50000);

        expect(result, isA<Success<Wallet>>());
        expect((result as Success<Wallet>).data.balance, 550000);
        verify(() => mockDatasource.addAmount(50000)).called(1);
      });

      test('debe retornar CacheFailure si addAmount lanza excepción', () async {
        when(() => mockDatasource.addAmount(any()))
            .thenThrow(Exception('Error al escribir'));

        final result = await repository.addAmount(50000);

        expect(result, isA<Error<Wallet>>());
        expect((result as Error<Wallet>).failure, isA<CacheFailure>());
      });
    });
  });
}
