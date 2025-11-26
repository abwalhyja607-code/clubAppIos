import 'package:club_app_organizations_section/appScreenOrganizations/subscriptionsScreen/subscriptionsType.dart';
import 'package:club_app_organizations_section/appScreenOrganizations/subscriptionsScreen/threeScreenSubscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ShortCutCode/shortCutCode.dart';
import '../../bloc/Cubit.dart';
import '../../bloc/states.dart';

class SubscriptionsScreen extends StatefulWidget {
  final int id_section;

  SubscriptionsScreen({super.key, required this.id_section});
  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  late int id_section;


  @override
  void initState() {
    super.initState();
    // تحديث البيانات عند الدخول
    id_section = widget.id_section;

    final cubit = CubitApp.get(context);
    cubit.getSubscriptionsMember(section_id: id_section);
    cubit.getSubscriptionsType();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StatesApp>(
      listener: (context, state) {
        if (state is AddSubscriptionsMembersState) {
          final cubit = CubitApp.get(context);
          cubit.getSubscriptionsMember(section_id: id_section);
          cubit.getSubscriptionsType();
        }
      },
      builder: (context, state) {
        final cubit = CubitApp.get(context);

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              title: Text(
                "الاشتراكات",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 8,
              actions: [
                IconButton(
                  onPressed: () {
                    NavigatorMethod(
                        context: context, screen: const SubscriptionsType());
                  },
                  icon: const Icon(
                    Icons.subscriptions_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
              bottom: TabBar(
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.6),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.check_circle, color: Colors.green),
                    text: 'نشط',
                  ),
                  Tab(
                    icon: Icon(Icons.pause_circle, color: Colors.orange),
                    text: 'غير نشط',
                  ),
                  Tab(
                    icon: Icon(Icons.cancel, color: Colors.grey),
                    text: 'غير مشترك',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // تبويب الاشتراكات النشطة
                active(
                  context: context,
                  data: cubit.dataSubscriptionsMemberActive,
                  index: cubit.indexSubscriptionsMemberActive,
                ),
                // تبويب الاشتراكات غير النشطة
                inactive(
                  context: context,
                  data: cubit.dataSubscriptionsMemberNonActive,
                  index: cubit.indexSubscriptionsMemberNonActive,
                ),
                // تبويب الأعضاء غير المشتركين
                nonSubscription(
                  context: context,
                  data: cubit.dataSubscriptionsMemberNonSubscribed,
                  index: cubit.indexSubscriptionsMemberNonSubscribed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
