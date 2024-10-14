import 'package:esmorga_flutter/data/event/event_repository_impl.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_api.dart';
import 'package:esmorga_flutter/datasource_remote/event/event_remote_datasource.dart';
import 'package:esmorga_flutter/domain/event/event_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerSingleton<EsmorgaApi>(EsmorgaApi());
  getIt.registerFactory(() => EventRemoteDatasourceImpl(getIt<EsmorgaApi>()));
  getIt.registerFactory(() => EventRepositoryImpl(getIt<EventRemoteDatasourceImpl>()));
  getIt.registerFactory(() => EventBloc(eventRepository: getIt<EventRepositoryImpl>()));
}
