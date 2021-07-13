import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:security_home/components/history_widget.dart';
import 'package:security_home/controllers/data_controller.dart';
import 'package:security_home/models/history_model.dart';
import 'package:security_home/utils/fade_animator.dart';
import 'package:security_home/utils/ui.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// buat referensi ke controller
  final DataController dataController = Get.put(DataController());

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
                child: GetX<DataController>(builder: (c) {
                  final List<HistoryModel> listHistoryModel = c.$listData;

                  if (c.$isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (listHistoryModel.length < 1) {
                    return Center(
                      child: Text(
                        "Belum ada data",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final model = listHistoryModel[index];
                      return HistoryWidget(model: model, index: index);
                    },
                    itemCount:
                        listHistoryModel == null ? 0 : listHistoryModel.length,
                    scrollDirection: Axis.horizontal,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => dataController.$listData.length < 1
            ? null
            : FloatingActionButton(
                onPressed: () async {
                  await dataController.deleteAllData();
                },
                child: Icon(Icons.delete_forever),
                tooltip: 'Hapus Semua data',
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
