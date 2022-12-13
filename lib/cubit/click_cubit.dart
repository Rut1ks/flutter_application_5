import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'click_state.dart';

class ClickCubit extends Cubit<ClickState> {
  ClickCubit() : super(ClickInitial()) {
    Timer.periodic(Duration(seconds: 1), (timer) {
      secondCount++;

      if (secondCount >= 5) {
        bool False = false;
        plus(UpdateCount: false);
      }
      emit(state);
    });
  }

  int count = 0;
  bool type = true;
  int secondCount = 0;
  List<String> log = [];

  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      secondCount++;

      if (secondCount >= 5) {
        bool False = false;
        plus(UpdateCount: false);
      }
      emit(state);
    });
  }

  void SaveDataInSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList('log', log);
    prefs.setInt('count', count);
    prefs.setBool('type_theme', type);
  }

  void plus({bool UpdateCount = true}) {
    count += type ? 1 : 2;

    log.add("Прибавили ${type ? 1 : 2}");
    SaveDataInSharedPreferences();
    if (UpdateCount == true) {
      secondCount = 0;
    }
    emit(Click(count, log));
  }

  void minus() {
    count -= type ? 1 : 2;

    log.add("Отняли ${type ? 1 : 2}");

    SaveDataInSharedPreferences();
    secondCount = 0;
    emit(Click(count, log));
  }

  void changeTheme() {
    type = !type;
    log.add("Измнение темы на ${type ? 'светлую' : 'тёмную'}");

    SaveDataInSharedPreferences();
    secondCount = 0;
    emit(Click(count, log));
  }

  void DeleteAllDataInSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('logs');
    prefs.remove('count');
    prefs.remove('type_theme');
    secondCount = 0;
    log.clear();
    count = 0;
    emit(Click(count, log));
  }
}
