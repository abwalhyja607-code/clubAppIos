import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/Cubit.dart';
import '../../ShortCutCode/shortCutCode.dart';

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

Future editSubscription({context , id}){
  final name = TextEditingController();
  final passwordName = TextEditingController();

  final price = TextEditingController();
  final passwordPrice = TextEditingController();

  final numberDays = TextEditingController();
  final passwordNumberDays = TextEditingController();

  final note = TextEditingController();
  final passwordNote = TextEditingController();

  final theme = Theme.of(context);
  final formKey = GlobalKey<FormState>();
  var cubit = CubitApp.get(context);

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Center(
        child: Text(
          "تعديل الاشتراك",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18.sp,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _buildSettingButton(
                context,
                icon: Icons.monetization_on_outlined,
                text: "تعديل الاسم",
                onTap: () {
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
                          child: Form(
                            key: formKey,
                            child: Column(
                              spacing: 10.h,
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
                                SizedBox(height: 10.h),
                                Text(
                                  "تعديل الاسم",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                InputText(
                                  controller: name,
                                  inputType: TextInputType.name,
                                  prefixIcon: CupertinoIcons.money_dollar,
                                  labelText: "الاسم",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال الاسم';
                                    }
                                    return null;
                                  },
                                ),
                                InputText(
                                  controller: passwordName,
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: CupertinoIcons.lock,
                                  labelText: "كلمة المرور",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10.h),
                                Button(
                                  title: "تعديل",
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await cubit.editNameSubscription(
                                          id: id, password: passwordName.text, name: name.text);

                                      Navigator.pop(context);
                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            cubit.dataEditNameSubscription["message"],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: cubit.dataEditNameSubscription["status"] == "success"
                                              ? theme.primaryColor
                                              : Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              _buildSettingButton(
                context,
                icon: Icons.price_change,
                text: "تعديل السعر",
                onTap: () {
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
                          child: Form(
                            key: formKey,
                            child: Column(
                              spacing: 10.h,
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
                                SizedBox(height: 10.h),
                                Text(
                                  "تعديل السعر",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                InputText(
                                  controller: price,
                                  inputType: TextInputType.number,
                                  prefixIcon: CupertinoIcons.money_dollar_circle,
                                  labelText: "السعر",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال السعر';
                                    }
                                    // تحقق أن القيمة رقمية
                                    final number = double.tryParse(value);
                                    if (number == null) {
                                      return 'الرجاء إدخال رقم صالح';
                                    }
                                    if (number <= 0) {
                                      return 'الرجاء إدخال رقم أكبر من صفر';
                                    }
                                    if (value.contains(RegExp(r'[A-Za-z]'))) {
                                      return 'السعر يجب أن يحتوي على أرقام فقط';
                                    }
                                    return null;
                                  },
                                ),

                                InputText(
                                  controller: passwordPrice,
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: CupertinoIcons.lock,
                                  labelText: "كلمة المرور",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10.h),
                                Button(
                                  title: "تعديل",
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await cubit.editPriceSubscription(
                                          id: id, password: passwordPrice.text, price: price.text);

                                      Navigator.pop(context);
                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            cubit.dataEditPriceSubscription["message"],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: cubit.dataEditPriceSubscription["status"] == "success"
                                              ? theme.primaryColor
                                              : Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              _buildSettingButton(
                context,
                icon: Icons.calendar_view_day_outlined,
                text: "تعديل عدد الأيام",
                onTap: () {
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
                          child: Form(
                            key: formKey,
                            child: Column(
                              spacing: 10.h,
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
                                SizedBox(height: 10.h),
                                Text(
                                  "تعديل عدد الأيام",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                InputText(
                                  controller: numberDays,
                                  inputType: TextInputType.number,
                                  prefixIcon: CupertinoIcons.calendar,
                                  labelText: "عدد الأيام",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال عدد الأيام';
                                    }
                                    final number = int.tryParse(value);
                                    if (number == null) {
                                      return 'الرجاء إدخال رقم صحيح';
                                    }
                                    if (number <= 0) {
                                      return 'عدد الأيام يجب أن يكون أكبر من صفر';
                                    }
                                    return null;
                                  },
                                ),

                                InputText(
                                  controller: passwordNumberDays,
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: CupertinoIcons.lock,
                                  labelText: "كلمة المرور",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10.h),
                                Button(
                                  title: "تعديل",
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await cubit.editNumberDaysSubscription(
                                          id: id, password: passwordNumberDays.text, NumberDays: numberDays.text);

                                      Navigator.pop(context);
                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            cubit.dataEditNumberDaysSubscription["message"],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: cubit.dataEditNumberDaysSubscription["status"] == "success"
                                              ? theme.primaryColor
                                              : Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              _buildSettingButton(
                context,
                icon: Icons.note,
                text: "تعديل الملاحظة",
                onTap: () {
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
                          child: Form(
                            key: formKey,
                            child: Column(
                              spacing: 10.h,
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
                                SizedBox(height: 10.h),
                                Text(
                                  "تعديل الملاحظة",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                InputText(
                                  controller: note,
                                  inputType: TextInputType.text,
                                  prefixIcon: CupertinoIcons.text_bubble,
                                  labelText: "الملاحظة",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال الملاحظة';
                                    }
                                    return null;
                                  },
                                ),
                                InputText(
                                  controller: passwordNote,
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: CupertinoIcons.lock,
                                  labelText: "كلمة المرور",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10.h),
                                Button(
                                  title: "تعديل",
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await cubit.editNoteSubscription(
                                          id: id, password: passwordNote.text, note: note.text);

                                      Navigator.pop(context);
                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            cubit.dataEditNoteSubscription["message"],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: cubit.dataEditNoteSubscription["status"] == "success"
                                              ? theme.primaryColor
                                              : Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

            ]
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "إغلاق",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    ),
  );
}
