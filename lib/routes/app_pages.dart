import 'package:get/get.dart';
import 'package:mine_ecommerce/features/cart/binding/cart_binding.dart';
import 'package:mine_ecommerce/features/cart/view/cart_view.dart';
import 'package:mine_ecommerce/features/checkout/binding/checkout_binding.dart';
import 'package:mine_ecommerce/features/checkout/view/checkout_view.dart';
import 'package:mine_ecommerce/features/home/binding/home_binding.dart';
import 'package:mine_ecommerce/features/home/view/home_view.dart';
import 'package:mine_ecommerce/features/login/binding/login_binding.dart';
import 'package:mine_ecommerce/features/login/view/login_view.dart';
import 'package:mine_ecommerce/features/profile/binding/profile_binding.dart';
import 'package:mine_ecommerce/features/profile/view/profile_view.dart';
import 'package:mine_ecommerce/features/order_confirmation/binding/order_confirmation_binding.dart';
import 'package:mine_ecommerce/features/order_confirmation/view/order_confirmation_view.dart';
import 'package:mine_ecommerce/features/product_detail/binding/product_detail_binding.dart';
import 'package:mine_ecommerce/features/product_detail/view/product_detail_view.dart';
import 'package:mine_ecommerce/features/register/binding/register_binding.dart';
import 'package:mine_ecommerce/features/register/view/register_view.dart';
import 'package:mine_ecommerce/features/search/binding/search_binding.dart';
import 'package:mine_ecommerce/features/search/view/search_view.dart';
import 'package:mine_ecommerce/features/splash/binding/splash_binding.dart';
import 'package:mine_ecommerce/features/splash/view/splash_view.dart';
import 'package:mine_ecommerce/routes/app_routes.dart';

abstract final class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: SplashView.new,
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: LoginView.new,
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: RegisterView.new,
      binding: RegisterBinding(),
    ),
    GetPage(name: AppRoutes.home, page: HomeView.new, binding: HomeBinding()),
    GetPage(
      name: AppRoutes.search,
      page: SearchView.new,
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: ProductDetailView.new,
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.orderConfirmation,
      page: OrderConfirmationView.new,
      binding: OrderConfirmationBinding(),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: CheckoutView.new,
      binding: CheckoutBinding(),
    ),
    GetPage(name: AppRoutes.cart, page: CartView.new, binding: CartBinding()),
    GetPage(
      name: AppRoutes.profile,
      page: ProfileView.new,
      binding: ProfileBinding(),
    ),
  ];
}
