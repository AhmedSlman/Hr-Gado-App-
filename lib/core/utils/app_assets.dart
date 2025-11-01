import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

/// نظام إدارة الأصول البسيط - Simple Assets Management
/// استدعي الصور والـ SVG بسهولة
class AppAssets {
  AppAssets._();

  // ==================== IMAGES ====================

  /// الصور الأساسية
  static const String logo = 'assets/images/logo.png';
  static const String logoDark = 'assets/images/logo_dark.png';
  static const String placeholder = 'assets/images/placeholder.png';
  static const String error = 'assets/images/error.png';
  static const String success = 'assets/images/success.png';
  static const String loading = 'assets/images/loading.png';
  static const String profile = "assets/images/profile.png";
  static const String emptyMeeting = "assets/images/empty_meeting.png";
  static const String gado = "assets/images/gado.png";

  /// صور الخلفيات
  static const String background1 = 'assets/images/background_1.png';
  static const String background2 = 'assets/images/background_2.png';
  static const String background3 = 'assets/images/background_3.png';

  /// صور المستخدمين
  static const String userDefault = 'assets/images/user_default.png';
  static const String userAvatar = 'assets/images/user_avatar.png';

  // ==================== SVG ICONS ====================

  /// الأيقونات الأساسية
  // static const String profile = 'assets/icons/profile.svg';
  static const String settings = 'assets/icons/settings.svg';
  static const String search = 'assets/icons/search.svg';
  static const String notification = 'assets/icons/notification.svg';
  static const String googleMeet = 'assets/icons/google-meet.svg';
  static const String badge = 'assets/icons/badge.svg';

// bottom navigation icons
  static const String homeIcon = 'assets/icons/home.svg';
  static const String categoryIcon = 'assets/icons/category.svg';
  static const String accountIcon = 'assets/icons/account.svg';

  /// أيقونات التنقل
  static const String back = 'assets/icons/back.svg';
  static const String forward = 'assets/icons/forward.svg';
  static const String close = 'assets/icons/close.svg';
  static const String menu = 'assets/icons/menu.svg';

  /// أيقونات الحالة
  static const String successIcon = 'assets/icons/success.svg';
  static const String errorIcon = 'assets/icons/error.svg';
  static const String warning = 'assets/icons/warning.svg';
  static const String info = 'assets/icons/info.svg';

  /// أيقونات الوسائط
  static const String camera = 'assets/icons/camera.svg';
  static const String gallery = 'assets/icons/gallery.svg';
  static const String video = 'assets/icons/video.svg';
  static const String audio = 'assets/icons/audio.svg';

  /// أيقونات التواصل
  static const String phone = 'assets/icons/phone.svg';
  static const String email = 'assets/icons/email.svg';
  static const String message = 'assets/icons/message.svg';
  static const String location = 'assets/icons/location.svg';

  static const String correctIcon = "assets/icons/correct_icon.svg";

  /// أيقونات الموارد البشرية
  static const String cat1 = "assets/images/cat1.png";
  static const String cat2 = 'assets/images/cat2.png';
  static const String cat3 = 'assets/images/cat3.png';
  static const String cat4 = 'assets/images/cat4.png';
  static const String cat5 = 'assets/images/cat5.png';
  static const String cat6 = 'assets/images/cat6.png';
  static const String cat7 = 'assets/images/cat7.png';
  static const String cat8 = 'assets/images/cat8.png';
  static const String cat9 = 'assets/images/cat9.png';

  // ==================== HELPER METHODS ====================

  /// إنشاء صورة
  static Widget image(
    String path, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  /// إنشاء صورة من الإنترنت مع التخزين المؤقت والـ Shimmer
  static Widget imageNetwork(
    String path, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    Widget? placeholder,
    Widget? errorWidget,
    Duration fadeInDuration = const Duration(milliseconds: 300),
  }) {
    return CachedNetworkImage(
      imageUrl: path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      fadeInDuration: fadeInDuration,
      placeholder: (context, url) =>
          placeholder ?? _buildShimmerPlaceholder(width, height),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildErrorWidget(width, height),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
    );
  }

  /// بناء Shimmer placeholder
  static Widget _buildShimmerPlaceholder(double? width, double? height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// بناء Error widget
  static Widget _buildErrorWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.error_outline, color: Colors.grey, size: 32),
    );
  }

  /// إنشاء SVG
  static Widget svg(
    String path, {
    double? width,
    double? height,
    Color? color,
  }) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  /// إنشاء أيقونة
  static Widget icon(String path, {double size = 24.0, Color? color}) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  /// الحصول على اللوجو حسب الثيم
  static String getLogo(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? logoDark : logo;
  }

  // ==================== QUICK ACCESS ====================
}

/// الوصول السريع للصور
abstract class ImagesAssets {
  static const String logo = AppAssets.logo;
  static const String logoDark = AppAssets.logoDark;
  static const String placeholder = AppAssets.placeholder;
  static const String error = AppAssets.error;
  static const String success = AppAssets.success;
  static const String loading = AppAssets.loading;
  static const String profile = AppAssets.profile;
  static const String emptyMeeting = AppAssets.emptyMeeting;
  static const String gado = AppAssets.gado;
}

/// الوصول السريع للأيقونات
abstract class IconsAssets {
  static const String home = AppAssets.homeIcon;
  static const String category = AppAssets.categoryIcon;
  static const String account = AppAssets.accountIcon;
  static const String settings = AppAssets.settings;
  static const String search = AppAssets.search;
  static const String notification = AppAssets.notification;
  static const String back = AppAssets.back;
  static const String forward = AppAssets.forward;
  static const String close = AppAssets.close;
  static const String menu = AppAssets.menu;
  static const String correctIcon = AppAssets.correctIcon;
  

  /// أيقونات الموارد البشرية
  static const String cat1 = AppAssets.cat1;
  static const String cat2 = AppAssets.cat2;
  static const String cat3 = AppAssets.cat3;
  static const String cat4 = AppAssets.cat4;
  static const String cat5 = AppAssets.cat5;
  static const String cat6 = AppAssets.cat6;
  static const String cat7 = AppAssets.cat7;
  static const String cat8 = AppAssets.cat8;
  static const String cat9 = AppAssets.cat9;
}
