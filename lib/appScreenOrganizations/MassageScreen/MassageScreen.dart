import 'dart:io';

import 'package:club_app_organizations_section/bloc/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/Cubit.dart';
import '../../ShortCutCode/shortCutCode.dart';
import 'ContactSpecialistsScreen.dart';

class MassageScreens extends StatelessWidget {
   MassageScreens({super.key});


  @override
  Widget build(BuildContext context) {
    Widget _buildSettingButton(
        BuildContext context, {
          required IconData icon,
          required String text,
          required VoidCallback onTap,
          Color? color,
        })
    {
      final theme = Theme.of(context);

      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28.sp,
                color: color ?? theme.primaryColor,
              ),
              SizedBox(width: 16.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: color ?? Colors.black87,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 18.sp,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
    }


    final theme = Theme.of(context);

    return BlocProvider(
      create: (BuildContext context) => CubitApp()..getInfoOrganization(),
      child: BlocConsumer<CubitApp, StatesApp>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          final cubit = CubitApp.get(context);
          DateTime? _lastPressed;

          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: const Text('انتهاء الاشتراك'),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
              automaticallyImplyLeading: false,
            ),
            body: WillPopScope(
              onWillPop: () async{
                if (_lastPressed == null || DateTime.now().difference(_lastPressed!)
                    > Duration(seconds: 2)) {
                  _lastPressed = DateTime.now();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Press back again to exit'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return false;
                }
                else {
                  exit(0);
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // صورة شعار التطبيق دائرية
                      CircleAvatar(
                        radius: 120.r,
                        backgroundColor: Colors.blue.shade50,
                        backgroundImage: const AssetImage('lib/assets/icon.png'), // ضع مسار شعار التطبيق هنا
                      ),
                      SizedBox(height: 30.h),

                      // أيقونة انتهاء الاشتراك


                      // العنوان الرئيسي
                      Text(
                        'انتهى اشتراك المنظمة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // رسالة التوجيه
                      Text(
                        'للمتابعة في استخدام خدمات إدارة النوادي، يرجى تجديد الاشتراك.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // زر التواصل مع المختصين
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactSpecialistsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.support_agent),
                          label: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            child: Text(
                              'التواصل مع المختصين',
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // زر العودة أو تعليمات إضافية (اختياري)
                      _buildSettingButton(
                        context,
                        icon: Icons.logout,
                        text: "Log Out",
                        color: Colors.red,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Text(
                                  "تأكيد تسجيل الخروج",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                content: Text(
                                  "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // إغلاق الرسالة فقط
                                    },
                                    child: Text(
                                      "لا",
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      cubit.logOutOrganization(context: context);
                                      // تنفيذ تسجيل الخروج
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple.shade800,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      "نعم",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );




  }



}
