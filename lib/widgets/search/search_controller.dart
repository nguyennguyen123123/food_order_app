import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SearchController {
  SearchController({
    required this.onGetValue,
    this.updateSearchingStatus,
    String initialTxt = '',
  }) {
    _searchCtrl = StreamController<String>.broadcast(onListen: onStreamListener);
    _searchCtrl.add(initialTxt);
  }

  final void Function(String) onGetValue;
  final void Function(bool)? updateSearchingStatus;
  String value = '';

  late StreamController<String> _searchCtrl;

  final _searhStatusCtrl = ValueNotifier<bool>(false);
  ValueNotifier<bool> get searchStatus => _searhStatusCtrl;
  bool get isSearching => _searhStatusCtrl.value;

  final debouceDuration = const Duration(milliseconds: 800);

  Stream<String> get searchStream =>
      _searchCtrl.stream.distinct().debounceTime(debouceDuration).doOnData(doOnData).doOnError(doOnError);

  void onStreamListener() async {
    try {
      if (!_searchCtrl.isClosed && (await searchStream.length) == 1) {
        // unawaited(
        Future.delayed(debouceDuration).then((_) async {
          if (!_searchCtrl.isClosed) {
            final length = await searchStream.length;
            if (length == 1) {
              insertNewText(value);
            }
          }
        });
        // );
      }
    } catch (e) {
      print(e);
    }
  }

  void insertNewText(String newValue) async {
    if (!_searchCtrl.isClosed && value != newValue) {
      value = newValue;
      if (!isSearching) {
        updateSearchStatus(true);
      }
      _searchCtrl.add(newValue);
    }
  }

  void doOnData(String value) {
    if (isSearching) {
      updateSearchStatus(false);
      onGetValue(value);
    }
  }

  void doOnError(Object error, StackTrace onError) {
    //handle error of stream
  }

  void updateSearchStatus(bool value) {
    if (updateSearchingStatus != null) {
      updateSearchingStatus!(value);
    }
    _searhStatusCtrl.value = value;
  }

  void dispose() {
    _searchCtrl.close();
    _searhStatusCtrl.dispose();
  }
}
