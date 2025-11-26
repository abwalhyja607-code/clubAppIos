import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../ShortCutCode/shortCutCode.dart';
import 'package:intl/intl.dart';

import '../../bloc/Cubit.dart';

// دالة لبناء صف التفاصيل
Widget _buildDetailRow( String label,  String value) {
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

// ======================================================================
// قائمة الأعضاء النشطين
// ======================================================================
Widget active({data , index , context }){

  return data.isEmpty ? Center(
      child: Text(
        "لا توجد بيانات للأعضاء النشطين",
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey,
        ),
      )
  )
      : Padding(
    padding: const EdgeInsets.all(20.0),
    child: ListView.builder(
      itemCount: index,
      itemBuilder: (context, i) {
        return AnimationConfiguration.staggeredList(
          delay: const Duration(milliseconds: 100),
          position: index,
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
                  color: Colors.white,
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
                          // المؤشر
                          Container(
                            width: 10.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          // اسم العضو
                          Expanded(
                            child: Text(
                              data[i]["member_name"] ?? "بدون اسم",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // زر التفاصيل
                          IconButton(
                            icon: Icon(
                              Icons.info_outline,
                              color: Theme.of(context).primaryColor,
                              size: 24.sp,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Center(
                                    child: Text(
                                      "تفاصيل الاشتراك",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildDetailRow(":اسم العضو", data[i]["member_name"]),
                                        _buildDetailRow(":المنظمة", data[i]["organization_name"]),
                                        _buildDetailRow(":تاريخ البداية", data[i]["start_date"]),
                                        _buildDetailRow(":تاريخ النهاية", data[i]["end_date"]),
                                        _buildDetailRow(":نوع الاشتراك", data[i]["subscription_type"] ),
                                        _buildDetailRow(":تاريخ الإنشاء", data[i]["created_at"]),
                                        _buildDetailRow(":السعر", "${data[i]["price"].toString()} ${data[i]["currency"].toString()}"),
                                        _buildDetailRow(":ملاحظة", data[i]["note"]),
                                      ],
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
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${data[i]["start_date"]}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "إلى",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "${data[i]["end_date"]}" ,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
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
  );
}

// ======================================================================
// قائمة الأعضاء غير النشطين
// ======================================================================
Widget inactive({data , index , context }){

  final _formKey = GlobalKey<FormState>();
  final theme = Theme.of(context);
  DateTime? selectedDate;
  TextEditingController dateController = TextEditingController();
  final note = TextEditingController();

  String? selectedItem;
  Map items = {};

  final cubit = CubitApp.get(context);
  items = {
    for (int i = 0; i < cubit.indexSubscriptionsType; i++)
      cubit.dataSubscriptionsType[i]["id"]: cubit.dataSubscriptionsType[i]["name"],
  };

  return data.isEmpty ? Center(
    child: Text(
      "لا توجد بيانات للأعضاء غير النشطين",
      style: TextStyle(
        fontSize: 16.sp,
        color: Colors.grey,
      ),
    ),
  )
      : AnimationLimiter(
    child: ListView.builder(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: index,
      itemBuilder: (context, i) {
        return AnimationConfiguration.staggeredList(
          position: index,
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
              child: Slidable(
                key: ValueKey(data[i]["id"]),
                startActionPane: ActionPane(
                  motion: const BehindMotion(),
                  extentRatio: 0.4,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        // فتح نافذة لتجديد الاشتراك
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
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
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
                                        "تجديد الاشتراك",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      TextFormField(
                                        controller: dateController,
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime initialDate = selectedDate ?? DateTime.now();
                                          DateTime? picked = await showDatePicker(
                                            context: context,
                                            initialDate: initialDate,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (picked != null) {
                                            selectedDate = picked;
                                            dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'يرجى اختيار تاريخ البداية';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          label: Text(
                                            "تاريخ البداية",
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.r),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          prefixIcon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      DropdownButtonFormField<String>(
                                        value: selectedItem,
                                        onChanged: (value) {
                                          selectedItem = value;
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'يرجى اختيار نوع الاشتراك';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          label: Text(
                                            "اختر نوع الاشتراك",
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.list,
                                            color: Colors.black54,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.r),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                        ),
                                        items: items.entries.map((entry) {
                                          return DropdownMenuItem<String>(
                                            value: entry.key.toString(),
                                            child: Text(entry.value),
                                          );
                                        }).toList(),
                                      ),
                                      InputText(
                                        controller: note,
                                        inputType: TextInputType.text,
                                        prefixIcon: Icons.note,
                                        labelText: "ملاحظة",
                                      ),
                                      SizedBox(height: 10.h),
                                      Button(
                                        title: "تجديد",
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            await cubit.addSubscriptionsMembers(
                                                note: note.text,
                                                memberId: data[i]["member_id"],
                                                startDate: dateController.text,
                                                typeId: selectedItem
                                            );
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  cubit.dataAddSubscriptionsMembers["message"],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                                backgroundColor: cubit.dataAddSubscriptionsMembers["status"] == "success"
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
                      backgroundColor: Colors.white,
                      foregroundColor: theme.primaryColor,
                      icon: Icons.replay,
                      label: 'تجديد',
                      borderRadius: BorderRadius.circular(15),
                    )
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                            // مؤشر الحالة
                            Container(
                              width: 10.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // اسم العضو
                            Expanded(
                              child: Text(
                                data[i]["member_name"] ,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // زر التفاصيل
                            IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: theme.primaryColor,
                                size: 24.sp,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Center(
                                      child: Text(
                                        "تفاصيل الاشتراك",
                                        style: TextStyle(
                                          color: theme.primaryColor,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildDetailRow(":اسم العضو", data[i]["member_name"]),
                                          _buildDetailRow(":المنظمة", data[i]["organization_name"]),
                                          _buildDetailRow(":تاريخ البداية", data[i]["start_date"]),
                                          _buildDetailRow(":تاريخ النهاية", data[i]["end_date"]),
                                          _buildDetailRow(":نوع الاشتراك", data[i]["subscription_type"]),
                                          _buildDetailRow(":تاريخ الإنشاء", data[i]["created_at"]),
                                          _buildDetailRow(":السعر", "${data[i]["price"].toString()} ${data[i]["currency"].toString()}"),
                                          _buildDetailRow(":ملاحظة", data[i]["note"]),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          "إغلاق",
                                          style: TextStyle(color: theme.primaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${data[i]["start_date"]}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              "إلى",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              "${data[i]["end_date"]}" ,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

// ======================================================================
// قائمة الأعضاء غير المشتركين
// ======================================================================
Widget nonSubscription({data , index , context }){

  final _formKey = GlobalKey<FormState>();
  final theme = Theme.of(context);
  DateTime? selectedDate;
  TextEditingController dateController = TextEditingController();
  final note = TextEditingController();

  String? selectedItem;
  Map items = {};

  final cubit = CubitApp.get(context);
  items = {
    for (int i = 0; i < cubit.indexSubscriptionsType; i++)
      cubit.dataSubscriptionsType[i]["id"]: cubit.dataSubscriptionsType[i]["name"],
  };

  return data.isEmpty ? Center(
    child: Text(
      "لا توجد بيانات للأعضاء غير المشتركين",
      style: TextStyle(
        fontSize: 16.sp,
        color: Colors.grey,
      ),
    ),
  )
      : AnimationLimiter(
    child: ListView.builder(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: index,
      itemBuilder: (context, i) {
        return AnimationConfiguration.staggeredList(
          position: index,
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
              child: Slidable(
                key: ValueKey(data[i]["id"]),
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  extentRatio: 0.4,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        // فتح نافذة لإضافة الاشتراك
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
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
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
                                        "إضافة اشتراك",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      TextFormField(
                                        controller: dateController,
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime initialDate = selectedDate ?? DateTime.now();
                                          DateTime? picked = await showDatePicker(
                                            context: context,
                                            initialDate: initialDate,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (picked != null) {
                                            selectedDate = picked;
                                            dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'يرجى اختيار تاريخ البداية';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          label: Text(
                                            "تاريخ البداية",
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.r),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          prefixIcon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      DropdownButtonFormField<String>(
                                        value: selectedItem,
                                        onChanged: (value) {
                                          selectedItem = value;
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'يرجى اختيار نوع الاشتراك';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          label: Text(
                                            "اختر نوع الاشتراك",
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.list,
                                            color: Colors.black54,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.r),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                        ),
                                        items: items.entries.map((entry) {
                                          return DropdownMenuItem<String>(
                                            value: entry.key.toString(),
                                            child: Text(entry.value),
                                          );
                                        }).toList(),
                                      ),
                                      InputText(
                                        controller: note,
                                        inputType: TextInputType.text,
                                        prefixIcon: Icons.note,
                                        labelText: "ملاحظة",
                                      ),
                                      SizedBox(height: 10.h),
                                      Button(
                                        title: "إضافة",
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            await cubit.addSubscriptionsMembers(
                                                note: note.text,
                                                memberId: data[i]["member_id"],
                                                startDate: dateController.text,
                                                typeId: selectedItem
                                            );
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  cubit.dataAddSubscriptionsMembers["message"],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                                backgroundColor: cubit.dataAddSubscriptionsMembers["status"] == "success"
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
                      backgroundColor: Colors.white,
                      foregroundColor: theme.primaryColor,
                      icon: Icons.add,
                      label: 'إضافة',
                      borderRadius: BorderRadius.circular(15),
                    )
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    child: Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            data[i]["member_name"],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.info_outline,
                            color: theme.primaryColor,
                            size: 24.sp,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Center(
                                  child: Text(
                                    "تفاصيل العضو",
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow(":اسم العضو", data[i]["member_name"].toString()),
                                      _buildDetailRow(":المنظمة", data[i]["organization_name"].toString()),
                                      _buildDetailRow(":ملاحظة", data[i]["note"] == null ?" " :data[i]["note"].toString() ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "إغلاق",
                                      style: TextStyle(color: theme.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
