import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../bloc/Cubit.dart';
import '../../../bloc/states.dart';
import '../../ShortCutCode/shortCutCode.dart';

class SubscriptionsAdminsType extends StatelessWidget {
  const SubscriptionsAdminsType({super.key});

  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center ,
        children: [

          Expanded(
            child: Text(
              value.isNotEmpty ? value : "غير متوفر",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.end,

            ),
          ),
          SizedBox(width: 10.w),
          Text(
            "$label",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.end,
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteController = TextEditingController();

    return BlocProvider(
      create: (context) => CubitApp()..getSubscriptionsTypeAdmin(),
      child: BlocConsumer<CubitApp, StatesApp>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = CubitApp.get(context);

          void addSuspend({required String id}) {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "إيقاف الاشتراك مؤقتًا",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InputText(
                          controller: noteController,
                          inputType: TextInputType.text,
                          prefixIcon: Icons.note,
                          labelText: "ملاحظة",
                        ),
                        const SizedBox(height: 20),
                        Button(
                          title: "تم",
                          onPressed: () async {
                            await cubit.addSuspendSubscriptions(
                                note: noteController.text, subscriptions_id: id);

                            Navigator.pop(context);

                            final status = cubit.dataAddSuspendSubscriptions["status"];
                            final message = cubit.dataAddSuspendSubscriptions["message"];

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                status == "success" ? Colors.green : Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "أنواع الاشتراكات",
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.white),
              ),
              centerTitle: true,
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 8,
            ),
            body: SafeArea(
              child: cubit.dataSubscriptionsTypeAdmin.isEmpty
                  ? Center(
                child: Text(
                  "لا توجد اشتراكات",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey,
                  ),
                ),
              )
                  : AnimationLimiter(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  physics: const BouncingScrollPhysics(),
                  itemCount: cubit.indexSubscriptionsTypeAdmin,
                  itemBuilder: (context, i) {
                    final subscription =
                    cubit.dataSubscriptionsTypeAdmin[i];
                    return AnimationConfiguration.staggeredList(
                      position: i,
                      delay: const Duration(milliseconds: 100),
                      child: SlideAnimation(
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        horizontalOffset: 30,
                        verticalOffset: 50.0,
                        child: FlipAnimation(
                          duration: const Duration(milliseconds: 2000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          flipAxis: FlipAxis.y,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.grey.shade50,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Status indicator (دائرة صغيرة)
                                      Container(
                                        width: 12.w,
                                        height: 12.w,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),

                                      // اسم الاشتراك
                                      Expanded(
                                        child: Text(
                                          "${subscription["name"]}",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      // زر المعلومات
                                      IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: Theme.of(context).primaryColor,
                                          size: 24.sp,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              title: Center(
                                                child: Text(
                                                  "تفاصيل نوع الاشتراك",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 18.sp,
                                                  ),
                                                ),
                                              ),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    _buildDetailRow(
                                                        label: ":الاسم ",
                                                        value: subscription["name"]
                                                            .toString()),
                                                    _buildDetailRow(
                                                        label: ":السعر ",
                                                        value:
                                                        "${subscription["price"]} JD"),
                                                    _buildDetailRow(
                                                        label: ":عدد الأيام ",
                                                        value: subscription[
                                                        "number_days"]
                                                            .toString()),

                                                    _buildDetailRow(
                                                        label: ":عدد الحسابات ",
                                                        value:
                                                        subscription["num_of_accunts"]
                                                            .toString()),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text(
                                                    "إغلاق",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
