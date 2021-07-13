import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:security_home/models/history_model.dart';

class DataController extends GetxController {
  /// firebase database RTDB
  /// buat referensi ke firebase database
  final FirebaseDatabase db = FirebaseDatabase();
  DatabaseReference dbRef;
  StreamSubscription<Event> _dataSubscription, _notifSubscription;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// variables
  var $listData = <HistoryModel>[].obs;
  var $isFirst = true.obs;
  var $isLoading = false.obs;

  /// init method
  @override
  void onInit() {
    initNotifPlugin();
    initDatabase();
    super.onInit();
  }

  @override
  void onClose() {
    _notifSubscription.cancel();
    _dataSubscription.cancel();
    super.onClose();
  }

  /// inisialisasi firebase database
  void initDatabase() {
    dbRef = db.reference().child('esp32-cam');

    /// notif
    _notifSubscription = dbRef.onChildAdded.listen((event) async {
      final newDataList = getListHistoryFromSnapshot(event.snapshot);
      await Future.forEach(newDataList, (HistoryModel model) async {
        await displayNotif(
            model.tipe,
            model.tipe +
                ' pada jam ' +
                model.jam +
                ' tanggal ' +
                model.tanggal);
      });
    });

    /// data
    _dataSubscription = dbRef.onValue.listen((event) async {
      $isLoading.value = true;
      List<HistoryModel> listHistoryModel =
          getListHistoryFromSnapshot(event.snapshot);

      // if (!$isFirst.value && listHistoryModel.length > 0) {
      //   // sudah bukan yang pertama lagi dan masih ada data, lakukan pengecekan untuk notifikasi
      //   await parseHistoryDataForNotif(listHistoryModel);
      // }

      $listData.assignAll(listHistoryModel);
      // $isFirst.value = false;
      $isLoading.value = false;
    });
  }

  /// dapatkan data dari snapshot
  List<HistoryModel> getListHistoryFromSnapshot(DataSnapshot snapshot) {
    List<HistoryModel> listHistoryModel = [];
    final data = snapshot.value;
    final keys = data.keys;

    for (var key in keys) {
      final history = (data[key]) as String;
      final arHistory = history.split('~');
      final mikroData = arHistory[0];
      final gambar = arHistory[1];
      print(mikroData);
      final finalMikroData =
          mikroData.replaceAll('*BOF*', '').replaceAll('*EOF*', '');
      final arMikroData = finalMikroData.split('*');
      final tipe = arMikroData[0];
      final ntpString = arMikroData[1];
      final tanggal = getWaktu(ntpString, isTanggal: true);
      final jam = getWaktu(ntpString, isTanggal: false);

      final UriData uri = Uri.parse(gambar).data;
      print(uri.isBase64);
      print(uri.contentAsBytes());

      // buat model baru
      final model = new HistoryModel(
          id: key,
          gambar: uri.contentAsBytes(),
          tanggal: tanggal,
          tipe: tipe,
          jam: jam);

      listHistoryModel.add(model);
    } // end for

    listHistoryModel.sort(
        (HistoryModel a, HistoryModel b) => a.tanggal.compareTo(b.tanggal));

    return listHistoryModel;
  }

  /// inisialisasi notifikasi
  void initNotifPlugin() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: null);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }

  /// munculkan notifikasi
  Future<void> displayNotif(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'org.ua4ever', 'Security Home', 'Sistem Keamanan Rumah',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, '$title', '$body', platformChannelSpecifics, payload: '$body');
  }

  /// fungsi untuk parsing data history untuk notifikasi
  Future<void> parseHistoryDataForNotif(List<HistoryModel> list) async {
    // buat variabel untuk menampung template list
    List<HistoryModel> newDataList = [];

    // looping data yang ada
    if ($listData.length < 1) {
      newDataList.assignAll(list);
    } else {
      list.forEach((HistoryModel currentModel) {
        bool isExists = false;
        for (int i = 0; i < $listData.length; i++) {
          final HistoryModel model = $listData[i];
          if (model.id == currentModel.id) {
            isExists = true;
            return;
          }
        }

        if (!isExists) {
          // jika belum ada, maka tambahkan ke data list
          newDataList.add(currentModel);
        }
      });
    }

    // jika data list ada, maka buat notifikasi
    await Future.forEach(newDataList, (HistoryModel model) async {
      await displayNotif(model.tipe,
          model.tipe + ' pada jam ' + model.jam + ' tanggal ' + model.tanggal);
    });
  }

  /// fungsi mendapatkan tanggal dari string
  String getWaktu(String ntpString, {bool isTanggal = true}) {
    final listBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    final arData =
        ntpString.replaceAll('T', ' ').replaceAll('Z', '').split(' ');
    final tanggal = arData[0];
    final arTanggal = tanggal.split('-');
    final thn = arTanggal[0];
    final bln = listBulan[int.parse(arTanggal[1])];
    final tgl = arTanggal[2];
    final jam = arData[1];

    return isTanggal ? '$tgl $bln $thn' : jam;
  }
}
