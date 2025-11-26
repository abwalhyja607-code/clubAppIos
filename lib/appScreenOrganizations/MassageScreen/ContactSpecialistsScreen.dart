import 'package:club_app_organizations_section/ShortCutCode/shortCutCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../subscriptionsScreen/subscriptionsType.dart';
import 'SubscriptionsTypeState.dart';



/// شاشة التواصل مع المختصين
class ContactSpecialistsScreen extends StatelessWidget {
  const ContactSpecialistsScreen({Key? key}) : super(key: key);

  // دوال التواصل الحقيقية مع SnackBar عند الفشل
  Future<void> _launchPhone(BuildContext context, String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن إجراء الاتصال بالرقم: $phoneNumber')),
      );
    }
  }




  Future<void> _launchEmail(BuildContext context, String emailAddress, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (!await launchUrl(emailUri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن فتح تطبيق البريد على هذا الجهاز')),
      );
    }
  }






  Future<void> _launchWhatsApp(BuildContext context) async {
    int phone =  962789003018;
    var whatsappUrl = "whatsapp://send?phone=$phone";
    await UrlLauncher.canLaunch(whatsappUrl) != null
        ? UrlLauncher.launch(whatsappUrl)
        : print(
        "open WhatsApp app link or do a snackbar with notification that there is no WhatsApp installed");
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('تجديد الاشتراك والتواصل'),
        backgroundColor: Colors.transparent,

        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // شعار التطبيق في الأعلى
            CircleAvatar(
              radius: 60.r,
              backgroundColor: Colors.blue.shade50,
              backgroundImage: const AssetImage('lib/assets/icon.png'),
            ),
            SizedBox(height: 20.h),

            const Text(
              'لإتمام عملية تجديد الاشتراك، يرجى التواصل معنا عبر إحدى القنوات التالية:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 25.h),

            _buildContactCard(
              context,
              icon: Icons.phone_forwarded,
              title: 'الاتصال الهاتفي المباشر',
              subtitle: '+962789003018',
              color: Colors.green.shade600,
              onTap: () => _launchPhone(context, '+962789003018'),
            ),
            SizedBox(height: 15.h),

            _buildContactCard(
              context,
              icon: Icons.email,
              title: 'البريد الإلكتروني للدعم',
              subtitle: 'muhammad.adel.abualhaijaa@gmail.com',
              color: Colors.red.shade600,
              onTap: () => _launchEmail(
                  context,
                  'muhammad.adel.abualhaijaa@gmail.com',
                  'تجديد الاشتراك',
                  'مرحباً، أود تجديد الاشتراك.'
              ),

            ),
            SizedBox(height: 15.h),

            _buildContactCard(
              context,
              icon: FontAwesomeIcons.whatsapp,
              title: 'تواصل عبر واتساب',
              subtitle: '+962789003018',
              color: Colors.teal.shade600,
              onTap: () => _launchWhatsApp(context),
            ),
            SizedBox(height: 30.h),

            const Text(
              'سنقوم بالرد على استفساراتكم وتوجيهكم لإتمام عملية التجديد في أسرع وقت ممكن.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),



            SizedBox(height: 15.h),

            _buildContactCard(
              context,
              icon: FontAwesomeIcons.listAlt,
              title: 'انواع الاشتراكات الموجوده',
              subtitle: 'الاشتراكات',
              color: Colors.teal.shade600,
              onTap: () {
                NavigatorMethod(context: context, screen: SubscriptionsAdminsType());
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        leading: CircleAvatar(
          radius: 25.r,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
