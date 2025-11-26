import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ShortCutCode/shortCutCode.dart';
import '../../bloc/Cubit.dart';


Widget _buildSettingButton(
    BuildContext context, {
      required IconData icon,
      required String text,
      required VoidCallback onTap,
      Color? color,
    }) {
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
          Icon(icon, size: 28.sp, color: color ?? theme.primaryColor),
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
          Icon(Icons.arrow_forward_ios, size: 18.sp, color: Colors.grey),
        ],
      ),
    ),
  );
}




Future editSection({context, id}) {
  final title = TextEditingController();
  final description = TextEditingController();
  final messenger = ScaffoldMessenger.of(context);

  final theme = Theme.of(context);
  final formKey = GlobalKey<FormState>();
  var cubit = CubitApp.get(context);

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          "تعديل بيانات الاقسام",
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18.sp),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- تعديل الاسم ----------------
            _buildSettingButton(
              context,
              icon: Icons.title,
              text: "تعديل العنوان",
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
                                "تعديل العنوان",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              InputText(
                                controller: title,
                                inputType: TextInputType.name,
                                prefixIcon: Icons.title,
                                labelText: "العنوان",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال العنوان';
                                  }
                                  if (value.length < 2) {
                                    return 'العنوان يجب أن يحتوي على حرفين على الأقل';
                                  }

                                  return null;
                                },
                              ),
                              Button(
                                title: "تعديل",
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await cubit.editSectionTitle(id: id.toString(), title: title.text);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          cubit.dataEditSectionTitle["message"],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.white),

                                        ),
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
              icon: Icons.description,
              text: "تعديل التفاصيل",
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
                                "تعديل التفاصيل",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              InputText(
                                controller: description,
                                inputType: TextInputType.name,
                                prefixIcon: Icons.description,
                                labelText: "التفاصيل",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال التفاصيل';
                                  }
                                  if (value.length < 2) {
                                    return 'التفاصيل يجب أن يحتوي على حرفين على الأقل';
                                  }

                                  return null;
                                },
                              ),
                              Button(
                                title: "تعديل",
                                onPressed: () async {
                                  if (formKey.currentState!.validate())  {
                                    await cubit.editSectionDescription(id: id.toString(), description: description.text);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          cubit.dataEditSectionDescription["message"],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.white),

                                        ),
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
              icon: Icons.person,
              text: "تعديل المسؤول",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {

                    Map<String, dynamic>? selectedManager;



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
                                "تعديل المسؤول",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),

                              DropdownInput(
                                labelText: "اختر المدير المسؤول",
                                prefixIcon: Icons.person,
                                itemsList: cubit.dataManagers,
                                selectedValue: selectedManager,
                                onChanged: (value) {
                                  selectedManager = value;
                                },
                                validator: (value) {
                                  if (selectedManager == null) {
                                    return 'الرجاء اختيار المدير المسؤول';
                                  }
                                  return null;
                                },
                              ),


                              Button(
                                title: "تعديل",
                                onPressed: () async {
                                  if (formKey.currentState!.validate())  {
                                    await cubit.editSectionResponsible(id: id.toString(), id_managers: selectedManager!["id"].toString());
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          cubit.dataEditSectionResponsible["message"],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.white),

                                        ),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("إغلاق", style: TextStyle(color: theme.primaryColor)),
        ),
      ],
    ),
  );
}
