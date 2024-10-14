import '../../data/event/event_datasource.dart';
import '../api/esmorga_api.dart';
import 'event_remote_model.dart';

class EventRemoteDatasourceImpl implements EventDatasource {
  final EsmorgaApi esmorgaApi;

  EventRemoteDatasourceImpl(this.esmorgaApi);

  @override
  Future<List<EventRemoteModel>> getEvents() async {
    return esmorgaApi.getEvents();
  }
}
