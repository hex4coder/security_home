import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:security_home/models/history_model.dart';
import 'package:security_home/pages/detail_image.dart';
import 'package:security_home/utils/fade_animator.dart';
import 'package:security_home/utils/ui.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// buat referensi ke firebase database
  final FirebaseDatabase db = FirebaseDatabase();
  DatabaseReference dbRef;
  StreamSubscription<Event> _dataSubscription;
  List<HistoryModel> listHistoryModel;

  /// inisialisasi data
  @override
  void initState() {
    super.initState();
    dbRef = db.reference().child('esp32-cam');
    _dataSubscription = dbRef.onValue.listen((event) {
      if (!mounted) return;

      setState(() {
        listHistoryModel = [];
        final data = event.snapshot.value;
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
        }
      });
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

  /// lepaskan memory yang tidak dibutuhkan
  @override
  void dispose() {
    _dataSubscription.cancel();
    super.dispose();
  }

  /// render UI
  @override
  Widget build(BuildContext context) {
    // buat skala size
    final s = MediaQuery.of(context).size;

    // render UI
    return Scaffold(
      body: Container(
        height: s.height,
        width: s.width,
        decoration: BoxDecoration(
          gradient: UI.kPrimaryGradient,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),

              // top logo
              FadeAnimator(
                delay: .5,
                child: titleLogo(),
              ),

              const SizedBox(
                height: 40,
              ),

              // header
              FadeAnimator(
                delay: .7,
                child: headerInfo(),
              ),

              const SizedBox(
                height: 40,
              ),

              // detail
              FadeAnimator(
                child: detailInfo(),
                delay: .9,
              ),

              // daftar data
              Container(
                padding: const EdgeInsets.only(left: 20),
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    final model = listHistoryModel[index];

                    return GestureDetector(
                      onTap: () => Get.to(
                        () => DetailImage(id: model.id, gambar: model.gambar),
                      ),
                      child: FadeAnimator(
                        delay: index * .1,
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          height: 300,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Hero(
                                tag: model.id,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: MemoryImage(model.gambar),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 300 * .7,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 300 * .3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                          model.tipe == 'PINTU TERBUKA'
                                              ? 'assets/img/main_pintu.svg'
                                              : 'assets/img/main_gerakan.svg',
                                          height: 30,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${model.tanggal}",
                                              style:
                                                  UI.kPrimarySmallText.copyWith(
                                                color: Colors.black45,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "Jam ${model.jam}",
                                              style:
                                                  UI.kPrimarySmallText.copyWith(
                                                color: Colors.black45,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              model.tipe == 'GERAKAN TERDETEKSI'
                                                  ? "Gerakan Terdeteksi"
                                                  : 'Pintu Terbuka',
                                              style:
                                                  UI.kPrimarySmallText.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount:
                      listHistoryModel == null ? 0 : listHistoryModel.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding detailInfo() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/img/detail_icon.svg'),
          const SizedBox(
            width: 20,
          ),
          Text(
            "Detail Informasi",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Text titleLogo() {
    return Text(
      "Smart Security Home",
      style: UI.kPrimaryText,
    );
  }

  Row headerInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // card detektor
        Card(
          child: Container(
            width: MediaQuery.of(context).size.width * .4,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // logo
                SvgPicture.asset('assets/img/main_pintu.svg'),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Pintu",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Terbuka",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(
          width: 20,
        ),

        // card pintu
        Card(
          child: Container(
            width: MediaQuery.of(context).size.width * .4,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/img/main_gerakan.svg',
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Gerakan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Terdeteksi",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
