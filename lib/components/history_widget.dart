import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:security_home/models/history_model.dart';
import 'package:security_home/pages/detail_image.dart';
import 'package:security_home/utils/fade_animator.dart';
import 'package:security_home/utils/ui.dart';

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({
    Key key,
    @required this.model,
    @required this.index,
  }) : super(key: key);

  final HistoryModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          model.tipe == 'PINTU TERBUKA'
                              ? 'assets/img/main_pintu.svg'
                              : 'assets/img/main_gerakan.svg',
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${model.tanggal}",
                              style: UI.kPrimarySmallText.copyWith(
                                color: Colors.black45,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Jam ${model.jam}",
                              style: UI.kPrimarySmallText.copyWith(
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
                              style: UI.kPrimarySmallText.copyWith(
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
  }
}
