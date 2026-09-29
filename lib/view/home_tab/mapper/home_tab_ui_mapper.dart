import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/home_tab/model/home_tab_ui_model.dart';

extension HomeTabUiMapper on Event {
  HomeTabUiModel toHomeTabUi() {
    final formatter = getIt<EsmorgaDateTimeFormatter>();

    return HomeTabUiModel(
      id: id,
      imageUrl: _safeDecodeImageUrl(imageUrl),
      cardTitle: name,
      cardSubtitle1: formatter.formatEventDate(date),
      cardSubtitle2: location.name,
    );
  }
}

extension HomeTabUiMapperList on List<Event> {
  List<HomeTabUiModel> toHomeTabUiList() {
    return map((event) => event.toHomeTabUi()).toList();
  }
}

// Falls back to the raw URL if it contains a malformed percent-encoding.
String? _safeDecodeImageUrl(String? rawUrl) {
  if (rawUrl == null) return null;
  try {
    return Uri.decodeComponent(rawUrl);
  } catch (_) {
    return rawUrl;
  }
}
