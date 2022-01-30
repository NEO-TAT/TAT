// ignore_for_file: directives_ordering

// 📦 Package imports:
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tat_core/tat_core.dart';

// 🌎 Project imports:
import 'package:tat/bloc/auth/auth_bloc.dart';
import 'package:tat/providers/storage_providers.dart';

final _blockedCookieNamePatterns = [
  // The school backend added a cookie to the response header,
  // and its name style is BIGipServerVPFl/...........,
  // and in this name, there are characters that do not meet the requirements (/),
  // which will cause dio parsing errors, so it needs to be filtered out.
  // Please refer to this article
  // https://juejin.cn/post/6844903934042046472
  // for more details.
  RegExp('BIGipServer'),
];

final _httpClientCookieJarProvider = FutureProvider(
  (ref) async => PersistCookieJar(
    storage: await ref.watch(tatCookieStorageProvider.future),
  ),
);

final _httpClientInterceptorsProvider = FutureProvider(
  (ref) async => [
    LogInterceptor(request: false, requestHeader: false, responseHeader: false),
    ResponseCookieFilter(blockedCookieNamePatterns: _blockedCookieNamePatterns),
    CookieManager(await ref.watch(_httpClientCookieJarProvider.future)),
  ],
);

final _schoolApiServiceProvider = FutureProvider(
  (ref) async => SchoolApiService(interceptors: await ref.watch(_httpClientInterceptorsProvider.future)),
);

final _simpleLoginRepositoryProvider = FutureProvider(
  (ref) async => SimpleLoginRepository(apiService: await ref.watch(_schoolApiServiceProvider.future)),
);

final _simpleLoginUseCaseProvider = FutureProvider(
  (ref) async => SimpleLoginUseCase(await ref.watch(_simpleLoginRepositoryProvider.future)),
);

final authBlocProvider = FutureProvider(
  (ref) async => AuthBloc(
    storage: await ref.watch(storageManagerProvider.future),
    simpleLoginUseCase: await ref.watch(_simpleLoginUseCaseProvider.future),
  ),
);
