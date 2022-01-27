// ignore_for_file: directives_ordering

// 📦 Package imports:
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tat_core/tat_core.dart';

// 🌎 Project imports:
import 'package:tat/bloc/auth/auth_bloc.dart';

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

final _httpClientCookieJar = PersistCookieJar();

final _httpClientInterceptors = [
  LogInterceptor(request: false, requestHeader: false, responseHeader: false),
  ResponseCookieFilter(blockedCookieNamePatterns: _blockedCookieNamePatterns),
  CookieManager(_httpClientCookieJar),
];

final _schoolApiService = SchoolApiService(interceptors: _httpClientInterceptors);

final _simpleLoginRepository = SimpleLoginRepository(apiService: _schoolApiService);
final _simpleLoginUseCase = SimpleLoginUseCase(_simpleLoginRepository);

final authBlocProvider = Provider((_) => AuthBloc(simpleLoginUseCase: _simpleLoginUseCase));
