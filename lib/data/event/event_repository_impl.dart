import '../../datasource_remote/event/event_remote_model.dart';
import '../../domain/event/event_repository.dart';
import 'event_datasource.dart';

class EventRepositoryImpl extends EventRepository {
  final EventDatasource _eventRemoteDataSource;

  EventRepositoryImpl(this._eventRemoteDataSource);

  @override
  Future<List<EventRemoteModel>> getEvents() {
    return _eventRemoteDataSource.getEvents();
  }
}
