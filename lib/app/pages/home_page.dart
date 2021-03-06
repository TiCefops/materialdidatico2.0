import 'package:easmaterialdidatico/app/controller/home_controller.dart';
import 'package:easmaterialdidatico/shared/themes/app_text_stayle.dart';
import 'package:easmaterialdidatico/shared/themes/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/course_button_widget.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuerySnapshot? cache;

    return Scaffold(
      backgroundColor: AppColors.blue,
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/image/brasao.png"),
                opacity: 0.04,
                alignment: Alignment.bottomCenter,
                scale: 0.7),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double sizeForPc = constraints.maxWidth * 0.9;
              if (constraints.maxWidth > 600) {
                sizeForPc = sizeForPc = constraints.maxWidth * 0.5;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: constraints.maxHeight * 0.01,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 12),
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        controller.logout();
                      },
                      child: const Text(
                        "Sair",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.07,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: constraints.maxWidth * 0.7,
                      child: Image.asset(
                        "assets/image/logo.png",
                        width: constraints.maxWidth,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.03,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Text(
                        "MATERIAL \n DID??TICO",
                        style: TextStyle(
                            fontFamily: 'pro',
                            color: Colors.white,
                            fontSize: sizeForPc * 0.06),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.09,
                    child: Text(
                      "Selecione Seu Curso",
                      style: AppTextStyle.titleWithe,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: sizeForPc,
                      height: constraints.maxHeight,
                      child: FutureBuilder<QuerySnapshot>(
                          initialData: cache,
                          future: controller.getCourses(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              cache = snapshot.data;
                              if (snapshot.data?.docs[0]["ativo"] == false) {
                                return Center(
                                  child: Text(
                                    "Em Manuten????o",
                                    style: AppTextStyle.titleRegularWhite,
                                  ),
                                );
                              } else {
                                return ListView.separated(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    Map<String, String> data = {
                                      "nome": snapshot.data
                                          ?.docs[index]["nome"],
                                      "id": snapshot.data?.docs[index]["id"],

                                    };
                                    if(snapshot.data?.docs[index]["nome"]!= "manuten????o"){
                                      return  courseWidget(
                                          snapshot.data?.docs[index]["nome"],
                                          snapshot.data?.docs[index]["ativo"],
                                          data, controller);
                                    }
                                    return const SizedBox();
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: constraints.maxHeight * 0.01,
                                    );
                                  },
                                );
                              }
                            }
                            return const Center(
                              child: CircularProgressIndicator(

                                color: Colors.white,
                                backgroundColor: AppColors.orange,
                              ),
                            );
                          }),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      height: constraints.maxHeight * 0.1,
                      child: Image.asset(
                        "assets/icons/amorEnfer.png",
                        height: constraints.maxHeight,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}
