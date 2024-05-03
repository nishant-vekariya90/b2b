// ignore_for_file: constant_identifier_names
import 'package:get/get.dart';
import '../bindings/add_money_binding.dart';
import '../bindings/aeps_settlement_binding.dart';
import '../bindings/auth_binding.dart';
import '../bindings/commission_binding.dart';
import '../bindings/distributor/add_user_binding.dart';
import '../bindings/distributor/credit_debit_binding.dart';
import '../bindings/distributor/distributor_dashboard_binding.dart';
import '../bindings/distributor/payment_bank_binding.dart';
import '../bindings/distributor/payment_binding.dart';
import '../bindings/distributor/profile_binding.dart';
import '../bindings/distributor/view_user_binding.dart';
import '../bindings/gift_card_b_binding.dart';
import '../bindings/gift_card_binding.dart';
import '../bindings/internal_transfer_binding.dart';
import '../bindings/kyc_binding.dart';
import '../bindings/news_binding.dart';
import '../bindings/personal_info_binding.dart';
import '../bindings/product_binding.dart';
import '../bindings/receipt_binding.dart';
import '../bindings/report_binding.dart';
import '../bindings/retailer/aeps_binding.dart';
import '../bindings/retailer/bbps_binding.dart';
import '../bindings/retailer/bbps_o_binding.dart';
import '../bindings/retailer/bus_booking_binding.dart';
import '../bindings/retailer/chargeback_binding.dart';
import '../bindings/retailer/cms_binding.dart';
import '../bindings/retailer/credit_card/credit_card_i_binding.dart';
import '../bindings/retailer/credit_card/credit_card_m_binding.dart';
import '../bindings/retailer/credit_card/credit_card_o_binding.dart';
import '../bindings/retailer/credit_card/credit_card_p_binding.dart';
import '../bindings/retailer/credo_pay_binding.dart';
import '../bindings/retailer/dmt/dmt_b_binding.dart';
import '../bindings/retailer/dmt/dmt_binding.dart';
import '../bindings/retailer/dmt/dmt_e_binding.dart';
import '../bindings/retailer/dmt/dmt_i_binding.dart';
import '../bindings/retailer/dmt/dmt_n_binding.dart';
import '../bindings/retailer/dmt/dmt_o_binding.dart';
import '../bindings/retailer/dmt/dmt_p_binding.dart';
import '../bindings/retailer/flight_binding.dart';
import '../bindings/retailer/matm_binding.dart';
import '../bindings/retailer/offline_pos_binding.dart';
import '../bindings/retailer/offline_token_binding.dart';
import '../bindings/retailer/pancard_binding.dart';
import '../bindings/retailer/payment_link_binding.dart';
import '../bindings/retailer/payment_page_binding.dart';
import '../bindings/retailer/recharge_binding.dart';
import '../bindings/retailer/retailer_dashboard_binding.dart';
import '../bindings/retailer/scan_and_pay_binding.dart';
import '../bindings/retailer/upi_payment_binding.dart';
import '../bindings/setting_binding.dart';
import '../bindings/sip_binding.dart';
import '../bindings/topup_binding.dart';
import '../bindings/transaction_report_binding.dart';
import '../screens/add_money/add_money_screen.dart';
import '../screens/add_money/add_money_status_screen.dart';
import '../screens/all_news_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/set_forgot_password_screen.dart';
import '../screens/auth/set_password_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/commission_screen.dart';
import '../screens/contact_us_screen.dart';
import '../screens/distributor/dashboard/add_user_screen.dart';
import '../screens/distributor/dashboard/create_profile_screen.dart';
import '../screens/distributor/dashboard/credit_debit_history_screen.dart';
import '../screens/distributor/dashboard/credit_debit_screen.dart';
import '../screens/distributor/dashboard/get_profiles_screen.dart';
import '../screens/distributor/dashboard/outstanding_collection_screen.dart';
import '../screens/distributor/dashboard/payment_bank/add_payment_bank_screen.dart';
import '../screens/distributor/dashboard/payment_bank/payment_bank_list_screen.dart';
import '../screens/distributor/dashboard/payment_history_screen.dart';
import '../screens/distributor/dashboard/payment_request_screen.dart';
import '../screens/distributor/dashboard/update_profile_screen.dart';
import '../screens/distributor/dashboard/view_child_user_screen.dart';
import '../screens/distributor/dashboard/view_user_screen.dart';
import '../screens/distributor/distributor_dashboard_screen.dart';
import '../screens/id_card_screen.dart';
import '../screens/internal_transfer_screen.dart';
import '../screens/kyc/kyc_screen.dart';
import '../screens/kyc/personal_info_screen.dart';
import '../screens/receipt/balance_enquiry_receipt_screen.dart';
import '../screens/receipt/mini_statement_receipt_screen.dart';
import '../screens/receipt/receipt_screen.dart';
import '../screens/reports/aeps_wallet_passbook_report_screen.dart';
import '../screens/reports/agent_performance_report_screen.dart';
import '../screens/reports/axis_sip_report_screen.dart';
import '../screens/reports/bank_sathi_lead_report_screen.dart';
import '../screens/reports/bank_withdrawal_report_screen.dart';
import '../screens/reports/business_performance_report_screen.dart';
import '../screens/reports/commission_detail_report_screen.dart';
import '../screens/reports/commission_report_screen.dart';
import '../screens/reports/login_report_screen.dart';
import '../screens/reports/notification_report_screen.dart';
import '../screens/reports/offline_token_report_screen.dart';
import '../screens/reports/order_report_screen.dart';
import '../screens/reports/payment_load_report_screen.dart';
import '../screens/reports/raised_complaints_report_screen.dart';
import '../screens/reports/search_transaction_report_screen.dart';
import '../screens/reports/transaction_bulk_report_screen.dart';
import '../screens/reports/transaction_report_details_screen.dart';
import '../screens/reports/transaction_report_screen.dart';
import '../screens/reports/transaction_single_report_screen.dart';
import '../screens/reports/wallet_passbook_report_screen.dart';
import '../screens/retailer/dashboard/services/aeps/aeps_gateway_screen.dart';
import '../screens/retailer/dashboard/services/aeps/aeps_mini_statement.dart';
import '../screens/retailer/dashboard/services/aeps/aeps_transaction_screen.dart';
import '../screens/retailer/dashboard/services/bbps/bbps_category_screen.dart';
import '../screens/retailer/dashboard/services/bbps/bbps_fetch_bill_screen.dart';
import '../screens/retailer/dashboard/services/bbps/bbps_status_screen.dart';
import '../screens/retailer/dashboard/services/bbps/bbps_sub_category_screen.dart';
import '../screens/retailer/dashboard/services/bbps_o/bbps_o_category_screen.dart';
import '../screens/retailer/dashboard/services/bbps_o/bbps_o_fetch_bill_screen.dart';
import '../screens/retailer/dashboard/services/bbps_o/bbps_o_status_screen.dart';
import '../screens/retailer/dashboard/services/bbps_o/bbps_o_sub_category_screen.dart';
import '../screens/retailer/dashboard/services/bus/boarding_dropping_screen.dart';
import '../screens/retailer/dashboard/services/bus/booking_success_screen.dart';
import '../screens/retailer/dashboard/services/bus/bus_booking_history_detail_screen.dart';
import '../screens/retailer/dashboard/services/bus/bus_booking_report_screen.dart';
import '../screens/retailer/dashboard/services/bus/bus_details_screen.dart';
import '../screens/retailer/dashboard/services/bus/bus_filter_sorting_screen.dart';
import '../screens/retailer/dashboard/services/bus/bus_home_screen.dart';
import '../screens/retailer/dashboard/services/bus/bus_process_status_screen.dart';
import '../screens/retailer/dashboard/services/bus/bus_search_splash_screen.dart';
import '../screens/retailer/dashboard/services/bus/bus_splash_screen.dart';
import '../screens/retailer/dashboard/services/bus/passenger_info_screen.dart';
import '../screens/retailer/dashboard/services/bus/search_buses_screen.dart';
import '../screens/retailer/dashboard/services/bus/select_seat_screen.dart';
import '../screens/retailer/dashboard/services/chargeback/chargeback_documents_screen.dart';
import '../screens/retailer/dashboard/services/chargeback/chargeback_raised_screen.dart';
import '../screens/retailer/dashboard/services/cms/cms_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_i/credit_card_i_payment_status_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_i/credit_card_i_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_i/credit_card_i_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_m/credit_card_m_payment_status_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_m/credit_card_m_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_m/credit_card_m_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_o/credit_card_o_payment_status_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_o/credit_card_o_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_o/credit_card_o_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_p/credit_card_p_payment_status_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_p/credit_card_p_screen.dart';
import '../screens/retailer/dashboard/services/credit_card/credit_card_p/credit_card_p_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt/dmt_add_recipient_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt/dmt_recipient_list_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt/dmt_remitter_registation_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt/dmt_transaction_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt/dmt_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt/dmt_transaction_status_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt/dmt_validate_remitter_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_b/dmt_b_add_recipient_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_b/dmt_b_recipient_list_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_b/dmt_b_remitter_registation_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_b/dmt_b_transaction_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_b/dmt_b_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_b/dmt_b_transaction_status_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_b/dmt_b_validate_remitter_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_e/dmt_e_add_recipient_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_e/dmt_e_recipient_list_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_e/dmt_e_remitter_registation_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_e/dmt_e_transaction_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_e/dmt_e_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_e/dmt_e_transaction_status_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_e/dmt_e_validate_remitter_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_i/dmt_i_add_recipient_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_i/dmt_i_recipient_list_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_i/dmt_i_remitter_registation_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_i/dmt_i_transaction_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_i/dmt_i_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_i/dmt_i_transaction_status_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_i/dmt_i_validate_remitter_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_n/dmt_n_add_recipient_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_n/dmt_n_recipient_list_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_n/dmt_n_remitter_registation_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_n/dmt_n_transaction_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_n/dmt_n_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_n/dmt_n_transaction_status_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_n/dmt_n_validate_remitter_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_o/dmt_o_add_recipient_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_o/dmt_o_recipient_list_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_o/dmt_o_remitter_registation_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_o/dmt_o_transaction_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_o/dmt_o_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_o/dmt_o_transaction_status_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_o/dmt_o_validate_remitter_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_p/dmt_p_add_recipient_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_p/dmt_p_recipient_list_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_p/dmt_p_remitter_registation_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_p/dmt_p_transaction_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_p/dmt_p_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_p/dmt_p_transaction_status_screen.dart';
import '../screens/retailer/dashboard/services/dmt/dmt_p/dmt_p_validate_remitter_screen.dart';
import '../screens/retailer/dashboard/services/flight/calender_fare_screen.dart';
import '../screens/retailer/dashboard/services/flight/flight_add_passengers_screen.dart';
import '../screens/retailer/dashboard/services/flight/flight_boarding_pass_screen.dart';
import '../screens/retailer/dashboard/services/flight/flight_booking_history_details.dart';
import '../screens/retailer/dashboard/services/flight/flight_details_screen.dart';
import '../screens/retailer/dashboard/services/flight/flight_extra_services_screen.dart';
import '../screens/retailer/dashboard/services/flight/flight_filter_screen.dart';
import '../screens/retailer/dashboard/services/flight/flight_history_screen.dart';
import '../screens/retailer/dashboard/services/flight/flight_home_screen.dart';
import '../screens/retailer/dashboard/services/flight/flight_process_status_screen.dart';
import '../screens/retailer/dashboard/services/flight/flight_splash_screen.dart';
import '../screens/retailer/dashboard/services/flight/review_trip_details.dart';
import '../screens/retailer/dashboard/services/flight/searched_flight_list_screen.dart';
import '../screens/retailer/dashboard/services/gift_card/bank_sathi/eligible_product_details_screen.dart';
import '../screens/retailer/dashboard/services/gift_card/bank_sathi/eligible_product_list_screen.dart';
import '../screens/retailer/dashboard/services/gift_card/bank_sathi/gift_card_b_onboarding_screen.dart';
import '../screens/retailer/dashboard/services/gift_card/bank_sathi/gift_card_b_status_screen.dart';
import '../screens/retailer/dashboard/services/gift_card/bank_sathi/giftcard_b_verify_screen.dart';
import '../screens/retailer/dashboard/services/gift_card/say_f/gift_card_buy_status_screen.dart';
import '../screens/retailer/dashboard/services/gift_card/say_f/gift_card_detail_screen.dart';
import '../screens/retailer/dashboard/services/gift_card/say_f/gift_card_onboarding_screen.dart';
import '../screens/retailer/dashboard/services/gift_card/say_f/gift_cards_list_screen.dart';
import '../screens/retailer/dashboard/services/matm/credopay/credo_pay_onboarding_screen.dart';
import '../screens/retailer/dashboard/services/matm/credopay/credo_pay_transaction_screen.dart';
import '../screens/retailer/dashboard/services/matm/fingpay_transaction_screen.dart';
import '../screens/retailer/dashboard/services/matm/matm_gateway_screen.dart';
import '../screens/retailer/dashboard/services/offline_pos/offline_pos_report_screen.dart';
import '../screens/retailer/dashboard/services/offline_pos/offline_pos_screen.dart';
import '../screens/retailer/dashboard/services/offline_token/digital_signature_token/digital_signature_token_screen.dart';
import '../screens/retailer/dashboard/services/offline_token/pancard_token/pancard_token_screen.dart';
import '../screens/retailer/dashboard/services/onboarding/fingpay_onboarding_screen.dart';
import '../screens/retailer/dashboard/services/onboarding/instantpay_onboarding_screen.dart';
import '../screens/retailer/dashboard/services/onboarding/moneyart_onboarding_screen.dart';
import '../screens/retailer/dashboard/services/onboarding/paysprint_onboarding_screen.dart';
import '../screens/retailer/dashboard/services/pancard/pancard_screen.dart';
import '../screens/retailer/dashboard/services/payment_link/create_payment_link_screen.dart';
import '../screens/retailer/dashboard/services/payment_link/payment_link_details_screen.dart';
import '../screens/retailer/dashboard/services/payment_link/payment_link_reminder_settings_screen.dart';
import '../screens/retailer/dashboard/services/payment_link/payment_link_screen.dart';
import '../screens/retailer/dashboard/services/payment_page/payment_page_screen.dart';
import '../screens/retailer/dashboard/services/product/all_category_screen.dart';
import '../screens/retailer/dashboard/services/product/all_product_screen.dart';
import '../screens/retailer/dashboard/services/product/order_place_screen.dart';
import '../screens/retailer/dashboard/services/product/order_status_screen.dart';
import '../screens/retailer/dashboard/services/product/product_detail_screen.dart';
import '../screens/retailer/dashboard/services/product/product_screen.dart';
import '../screens/retailer/dashboard/services/recharge_and_bill/dth_recharge_screen.dart';
import '../screens/retailer/dashboard/services/recharge_and_bill/m_plan_screen.dart';
import '../screens/retailer/dashboard/services/recharge_and_bill/mobile_recharge.dart';
import '../screens/retailer/dashboard/services/recharge_and_bill/postpaid_recharge_screen.dart';
import '../screens/retailer/dashboard/services/recharge_and_bill/r_plan_screen.dart';
import '../screens/retailer/dashboard/services/recharge_and_bill/recharge_status_screen.dart';
import '../screens/retailer/dashboard/services/scan_and_pay/pay_screen.dart';
import '../screens/retailer/dashboard/services/scan_and_pay/pay_status_screen.dart';
import '../screens/retailer/dashboard/services/scan_and_pay/scan_and_pay_screen.dart';
import '../screens/retailer/dashboard/services/sip/axis_sip_screen.dart';
import '../screens/retailer/dashboard/services/upi_payment/upi_payment_add_recipient_screen.dart';
import '../screens/retailer/dashboard/services/upi_payment/upi_payment_recipient_list_screen.dart';
import '../screens/retailer/dashboard/services/upi_payment/upi_payment_remitter_registation_page.dart';
import '../screens/retailer/dashboard/services/upi_payment/upi_payment_transaction_screen.dart';
import '../screens/retailer/dashboard/services/upi_payment/upi_payment_transaction_slab_screen.dart';
import '../screens/retailer/dashboard/services/upi_payment/upi_payment_transaction_status_screen.dart';
import '../screens/retailer/dashboard/services/upi_payment/upi_payment_validate_remitter_screen.dart';
import '../screens/retailer/dashboard/setting/change_password_screen.dart';
import '../screens/retailer/dashboard/setting/change_tpin_screen.dart';
import '../screens/retailer/dashboard/setting/raise_complaint_screen.dart';
import '../screens/retailer/dashboard/setting/website_content_screen.dart';
import '../screens/retailer/retailer_dashboard_screen.dart';
import '../screens/settlement/aeps_add_bank_screen.dart';
import '../screens/settlement/aeps_bank_list_screen.dart';
import '../screens/settlement/aeps_history_screen.dart';
import '../screens/settlement/aeps_settlement_home_screen.dart';
import '../screens/settlement/aeps_to_bank_screen.dart';
import '../screens/settlement/aeps_to_direct_bank_screen.dart';
import '../screens/settlement/aeps_to_main_wallet_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/topup/topup_history_screen.dart';
import '../screens/topup/topup_request_screen.dart';
import '../widgets/image_capture_screen.dart';
import '../widgets/no_internet_connection_screen.dart';
import '../widgets/no_location_permission_screen.dart';
import '../widgets/searchable_list_view_pagination_screen.dart';
import '../widgets/searchable_list_view_screen.dart';
import '../widgets/searchable_list_view_with_image_screen.dart';
import '../widgets/video_recording_screen.dart';
import 'routes.dart';

const Transition transition = Transition.fadeIn;

class AppPages {
  static const INITIAL_ROUTE = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: Routes.SPLASH_SCREEN,
      page: () => const SplashPage(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AUTH_SCREEN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.SIGN_UP_SCREEN,
      page: () => const SignUpScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.SET_PASSWORD_SCREEN,
      page: () => const SetPasswordScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.SET_FORGOT_PASSWORD_SCREEN,
      page: () => const SetForgotPasswordScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.WEBSITE_CONTENT_SCREEN,
      page: () => const WebsiteContentScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.IMAGE_CAPTURE_SCREEN,
      page: () => const ImageCaptureScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.VIDEO_RECORDING_SCREEN,
      page: () => const VideoRecordingScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.NO_INTERNET_CONNECTION_SCREEN,
      page: () => NoInternetConnectionScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.NO_LOCATION_PERMISSION_SCREEN,
      page: () => const NoLocationPermissionScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.SEARCHABLE_LIST_VIEW_SCREEN,
      page: () => const SearchabelListViewScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.SEARCHABLE_LIST_VIEW_PAGINATION_SCREEN,
      page: () => const SearchabelListViewPaginationScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
      page: () => const SearchAbelListViewWithImageScreen(),
      transition: transition,
    ),

    /// Kyc ///
    GetPage(
      name: Routes.KYC_SCREEN,
      page: () => const KycPage(),
      binding: KycBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.PERSONAL_INFO_SCREEN,
      page: () => const PersonalInfoScreen(),
      binding: PersonalInfoBinding(),
      transition: transition,
    ),

    /// Settlement ///
    GetPage(
      name: Routes.AEPS_SETTLEMENT_HOME_SCREEN,
      page: () => const AepsSettlementHomeScreen(),
      binding: AepsSettlementBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AEPS_TO_BANK_SCREEN,
      page: () => const AepsToBankScreen(),
      binding: AepsSettlementBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AEPS_TO_DIRECT_BANK_SCREEN,
      page: () => const AepsToDirectBankScreen(),
      binding: AepsSettlementBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AEPS_TO_MAIN_WALLET_SCREEN,
      page: () => const AepsToMainWalletScreen(),
      binding: AepsSettlementBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AEPS_SETTLEMENT_HISTORY_SCREEN,
      page: () => const AepsSettlementHistoryScreen(),
      binding: AepsSettlementBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AEPS_ADD_BANK_SCREEN,
      page: () => const AepsAddBankScreen(),
      binding: AepsSettlementBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AEPS_BANK_LIST_SCREEN,
      page: () => const AepsBankListScreen(),
      binding: AepsSettlementBinding(),
      transition: transition,
    ),

    /// Add Money ///
    GetPage(
      name: Routes.ADD_MONEY_SCREEN,
      page: () => const AddMoneyScreen(),
      binding: AddMoneyBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.ADD_MONEY_STATUS_SCREEN,
      page: () => const AddMoneyStatusScreen(),
      binding: AddMoneyBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.WEB_VIEW_SCREEN,
      page: () => const WebViewScreen(),
      transition: transition,
    ),

    /// Payment Page ///
    GetPage(
      name: Routes.PAYMENT_PAGE_SCREEN,
      page: () => PaymentPageScreen(),
      binding: PaymentPageBinding(),
      transition: transition,
    ),

    /// Payment Link ///
    GetPage(
      name: Routes.PAYMENT_LINK_SCREEN,
      page: () => const PaymentLinkScreen(),
      binding: PaymentLinkBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.PAYMENT_LINK_DETAILS_SCREEN,
      page: () => PaymentLinkDetailsScreen(),
      binding: PaymentLinkBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREATE_PAYMENT_LINK_SCREEN,
      page: () => const CreatePaymentLinkScreen(),
      binding: PaymentLinkBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.PAYMENT_LINK_REMINDER_SETTINGS_SCREEN,
      page: () => const PaymentLinkReminderSettingsScreen(),
      binding: PaymentLinkBinding(),
      transition: transition,
    ),

    /// Internal Transafer ///
    GetPage(
      name: Routes.INTERNAL_TRANSFER_SCREEN,
      page: () => const InternalTransferScreen(),
      binding: InternalTransferBinding(),
      transition: transition,
    ),

    /// Topup ///
    GetPage(
      name: Routes.TOPUP_REQUEST_SCREEN,
      page: () => const TopupRequestScreen(),
      binding: TopupBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.TOPUP_HISTORY_SCREEN,
      page: () => const TopupHistoryScreen(),
      binding: TopupBinding(),
      transition: transition,
    ),

    /// News ///
    GetPage(
      name: Routes.ALL_NEWS_SCREEN,
      page: () => const AllNewsScreen(),
      binding: NewsBinding(),
      transition: transition,
    ),

    /// Receipt ///
    GetPage(
      name: Routes.RECEIPT_SCREEN,
      page: () => const ReceiptScreen(),
      binding: ReceiptBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.BALANCE_ENQUIRY_RECEIPT_SCREEN,
      page: () => const BalanceEnquiryReceiptScreen(),
      binding: ReceiptBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.MINI_STATEMENT_RECEIPT_SCREEN,
      page: () => const MiniStatementReceiptScreen(),
      binding: ReceiptBinding(),
      transition: transition,
    ),

    /// Raise Complaint ///
    GetPage(
      name: Routes.RAISE_COMPLAINT_SCREEN,
      page: () => const RaiseComplaintScreen(),
      binding: SettingBinding(),
      transition: transition,
    ),

    /// Setting ///
    GetPage(
      name: Routes.ID_CARD_SCREEN,
      page: () => const IdCardScreen(),
      binding: SettingBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD_SCREEN,
      page: () => const ChangePasswordScreen(),
      binding: SettingBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CHANGE_TPIN_SCREEN,
      page: () => const ChangeTpinScreen(),
      binding: SettingBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CONTACT_US_SCREEN,
      page: () => const ContactUsScreen(),
      binding: SettingBinding(),
      transition: transition,
    ),

    /// Reports ///
    GetPage(
      name: Routes.LOGIN_REPORT_SCREEN,
      page: () => const LoginReportScreen(),
      binding: SettingBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.WALLET_PASSBOOK_REPORT_SCREEN,
      page: () => const WalletPassbookReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.PAYMENT_LOAD_REPORT_SCREEN,
      page: () => const PaymentLoadReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.TRANSACTION_REPORT_SCREEN,
      page: () => const TransactionReportScreen(),
      binding: TransactionReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.TRANSACTION_REPORT_DETAILS_SCREEN,
      page: () => TransactionReportDetailsScreen(),
      binding: TransactionReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.TRANSACTION_SINGLE_REPORT_SCREEN,
      page: () => TransactionSingleReportScreen(),
      binding: TransactionReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.TRANSACTION_BULK_REPORT_SCREEN,
      page: () => const TransactionBulkReportScreen(),
      binding: TransactionReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.RAISED_COMPLAINTS_REPORT_SCREEN,
      page: () => const RaisedComplaintsReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AEPS_WALLET_PASSBOOK_REPORT_SCREEN,
      page: () => const AepsWalletPassbookReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.BANK_WITHDRAWAL_REPORT_SCREEN,
      page: () => const BankWithdrawalReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.BUSINESS_PERFORMANCE_REPORT_SCREEN,
      page: () => const BusinessPerformanceReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AGENT_PERFORMANCE_REPORT_SCREEN,
      page: () => const AgentPerformanceReportScreen(),
      binding: ViewUserBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.ORDER_REPORT_SCREEN,
      page: () => const OrderReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.OFFLINE_TOKEN_REPORT_SCREEN,
      page: () => const OfflineTokenReportScreen(),
      binding: OfflineTokenBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.BANK_SATHI_LEAD_REPORT_SCREEN,
      page: () => const BankSathiLeadReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.NOTIFICATION_REPORT_SCREEN,
      page: () => const NotificationReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AXIS_SIP_REPORT_SCREEN,
      page: () => const AxisSipReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.SEARCH_TRANSACTION_REPORT_SCREEN,
      page: () => const SearchTransactionReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),

    ////////////////
    /// Retailer ///
    ////////////////
    GetPage(
      name: Routes.RETAILER_DASHBOARD_SCREEN,
      page: () => const RetailerDashBoardScreen(),
      binding: RetailerDashboardBinding(),
      transition: transition,
    ),

    /// AEPS ///
    GetPage(
      name: Routes.AEPS_GATEWAY_SCREEN,
      page: () => const AepsGatewayScreen(),
      binding: AepsBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AEPS_TRANSACTION_SCREEN,
      page: () => const AepsTransactionScreen(),
      binding: AepsBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.AEPS_MINI_STATEMENT_SCREEN,
      page: () => const AepsMiniStatementScreen(),
      binding: AepsBinding(),
      transition: transition,
    ),

    /// Onboarding ///
    GetPage(
      name: Routes.MONEYART_ONBOARDING_SCREEN,
      page: () => const MoneyartOnboardingScreen(),
      binding: AepsBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FINGPAY_ONBOARDING_SCREEN,
      page: () => const FingpayOnboardingScreen(),
      binding: AepsBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.INSTANTPAY_ONBOARDING_SCREEN,
      page: () => const InstantpayOnboardingScreen(),
      binding: AepsBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.PAYSPRINT_ONBOARDING_SCREEN,
      page: () => const PaysprintOnboardingScreen(),
      binding: AepsBinding(),
      transition: transition,
    ),

    /// MATM ///
    GetPage(
      name: Routes.MATM_GATEWAY_SCREEN,
      page: () => const MatmGateWayScreen(),
      binding: MatmBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDO_PAY_ONBOARDING_SCREEN,
      page: () => const CredoPayOnboardingScreen(),
      binding: CredoPayBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDO_PAY_TRANSACTION_SCREEN,
      page: () => const CredoPayTransactionScreen(),
      binding: CredoPayBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FINGPAY_TRANSACTION_SCREEN,
      page: () => const FingpayTransactionScreen(),
      binding: MatmBinding(),
      transition: transition,
    ),

    /// DMT Moneyart ///
    GetPage(
      name: Routes.DMT_BENEFICIARY_LIST_SCREEN,
      page: () => const DmtRecipientListScreen(),
      binding: DmtBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_TRANSACTION_SCREEN,
      page: () => const DmtTransactionScreen(),
      binding: DmtBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_ADD_RECIPIENT_SCREEN,
      page: () => const DmtAddRecipientScreen(),
      binding: DmtBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_REMITTER_REGISTRATION_SCREEN,
      page: () => const DmtRemitterRegistrationScreen(),
      binding: DmtBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_VALIDATE_REMITTER_SCREEN,
      page: () => const DmtValidateRemitterScreen(),
      binding: DmtBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_TRANSACTION_SLAB_SCREEN,
      page: () => const DmtTransactionSlabScreen(),
      binding: DmtBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_TRANSACTION_STATUS_SCREEN,
      page: () => const DmtTransactionStatusScreen(),
      binding: DmtBinding(),
      transition: transition,
    ),

    /// DMT Bankit ///
    GetPage(
      name: Routes.DMT_B_BENEFICIARY_LIST_SCREEN,
      page: () => const DmtBRecipientListScreen(),
      binding: DmtBBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_B_TRANSACTION_SCREEN,
      page: () => const DmtBTransactionScreen(),
      binding: DmtBBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_B_ADD_RECIPIENT_SCREEN,
      page: () => const DmtBAddRecipientScreen(),
      binding: DmtBBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_B_REMITTER_REGISTRATION_SCREEN,
      page: () => const DmtBRemitterRegistrationScreen(),
      binding: DmtBBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_B_VALIDATE_REMITTER_SCREEN,
      page: () => const DmtBValidateRemitterScreen(),
      binding: DmtBBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_B_TRANSACTION_SLAB_SCREEN,
      page: () => const DmtBTransactionSlabScreen(),
      binding: DmtBBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_B_TRANSACTION_STATUS_SCREEN,
      page: () => const DmtBTransactionStatusScreen(),
      binding: DmtBBinding(),
      transition: transition,
    ),

    /// DMT Ezypay ///
    GetPage(
      name: Routes.DMT_E_BENEFICIARY_LIST_SCREEN,
      page: () => const DmtERecipientListScreen(),
      binding: DmtEBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_E_TRANSACTION_SCREEN,
      page: () => const DmtETransactionScreen(),
      binding: DmtEBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_E_ADD_RECIPIENT_SCREEN,
      page: () => const DmtEAddRecipientScreen(),
      binding: DmtEBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_E_REMITTER_REGISTRATION_SCREEN,
      page: () => const DmtERemitterRegistrationScreen(),
      binding: DmtEBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_E_VALIDATE_REMITTER_SCREEN,
      page: () => const DmtEValidateRemitterScreen(),
      binding: DmtEBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_E_TRANSACTION_SLAB_SCREEN,
      page: () => const DmtETransactionSlabScreen(),
      binding: DmtEBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_E_TRANSACTION_STATUS_SCREEN,
      page: () => const DmtETransactionStatusScreen(),
      binding: DmtEBinding(),
      transition: transition,
    ),

    /// DMT Instantpay ///
    GetPage(
      name: Routes.DMT_I_BENEFICIARY_LIST_SCREEN,
      page: () => const DmtIRecipientListScreen(),
      binding: DmtIBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_I_TRANSACTION_SCREEN,
      page: () => const DmtITransactionScreen(),
      binding: DmtIBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_I_ADD_RECIPIENT_SCREEN,
      page: () => const DmtIAddRecipientScreen(),
      binding: DmtIBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_I_REMITTER_REGISTRATION_SCREEN,
      page: () => const DmtIRemitterRegistrationScreen(),
      binding: DmtIBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_I_VALIDATE_REMITTER_SCREEN,
      page: () => const DmtIValidateRemitterScreen(),
      binding: DmtIBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_I_TRANSACTION_SLAB_SCREEN,
      page: () => const DmtITransactionSlabScreen(),
      binding: DmtIBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_I_TRANSACTION_STATUS_SCREEN,
      page: () => const DmtITransactionStatusScreen(),
      binding: DmtIBinding(),
      transition: transition,
    ),

    /// DMT NSDL Bank ///
    GetPage(
      name: Routes.DMT_N_BENEFICIARY_LIST_SCREEN,
      page: () => const DmtNRecipientListScreen(),
      binding: DmtNBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_N_TRANSACTION_SCREEN,
      page: () => const DmtNTransactionScreen(),
      binding: DmtNBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_N_ADD_RECIPIENT_SCREEN,
      page: () => const DmtNAddRecipientScreen(),
      binding: DmtNBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_N_REMITTER_REGISTRATION_SCREEN,
      page: () => const DmtNRemitterRegistrationScreen(),
      binding: DmtNBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_N_VALIDATE_REMITTER_SCREEN,
      page: () => const DmtNValidateRemitterScreen(),
      binding: DmtNBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_N_TRANSACTION_SLAB_SCREEN,
      page: () => const DmtNTransactionSlabScreen(),
      binding: DmtNBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_N_TRANSACTION_STATUS_SCREEN,
      page: () => const DmtNTransactionStatusScreen(),
      binding: DmtNBinding(),
      transition: transition,
    ),

    /// DMT Offline ///
    GetPage(
      name: Routes.DMT_O_BENEFICIARY_LIST_SCREEN,
      page: () => const DmtORecipientListScreen(),
      binding: DmtOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_O_TRANSACTION_SCREEN,
      page: () => const DmtOTransactionScreen(),
      binding: DmtOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_O_ADD_RECIPIENT_SCREEN,
      page: () => const DmtOAddRecipientScreen(),
      binding: DmtOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_O_REMITTER_REGISTRATION_SCREEN,
      page: () => const DmtORemitterRegistrationScreen(),
      binding: DmtOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_O_VALIDATE_REMITTER_SCREEN,
      page: () => const DmtOValidateRemitterScreen(),
      binding: DmtOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_O_TRANSACTION_SLAB_SCREEN,
      page: () => const DmtOTransactionSlabScreen(),
      binding: DmtOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_O_TRANSACTION_STATUS_SCREEN,
      page: () => const DmtOTransactionStatusScreen(),
      binding: DmtOBinding(),
      transition: transition,
    ),

    /// DMT Paysprint ///
    GetPage(
      name: Routes.DMT_P_BENEFICIARY_LIST_SCREEN,
      page: () => const DmtPBeneficiaryListScreen(),
      binding: DmtPBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_P_TRANSACTION_SCREEN,
      page: () => const DmtPTransactionScreen(),
      binding: DmtPBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_P_ADD_RECIPIENT_SCREEN,
      page: () => const DmtPAddRecipientScreen(),
      binding: DmtPBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_P_REMITTER_REGISTRATION_SCREEN,
      page: () => const DmtPRemitterRegistrationScreen(),
      binding: DmtPBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_P_VALIDATE_REMITTER_SCREEN,
      page: () => const DmtPValidateRemitterScreen(),
      binding: DmtPBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_P_TRANSACTION_SLAB_SCREEN,
      page: () => const DmtPTransactionSlabScreen(),
      binding: DmtPBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DMT_P_TRANSACTION_STATUS_SCREEN,
      page: () => const DmtPTransactionStatusScreen(),
      binding: DmtPBinding(),
      transition: transition,
    ),

    /// UPI Payment ///
    GetPage(
      name: Routes.UPI_PAYMENT_BENEFICIARY_LIST_SCREEN,
      page: () => const UpiPaymentBeneficiaryListScreen(),
      binding: UpiPaymentBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.UPI_PAYMENT_TRANSACTION_SCREEN,
      page: () => const UpiPaymentTransactionScreen(),
      binding: UpiPaymentBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.UPI_PAYMENT_ADD_RECIPIENT_SCREEN,
      page: () => const UpiPaymentAddRecipientScreen(),
      binding: UpiPaymentBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.UPI_PAYMENT_REMITTER_REGISTRATION_SCREEN,
      page: () => const UpiPaymentRemitterRegistrationScreen(),
      binding: UpiPaymentBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.UPI_PAYMENT_VALIDATE_REMITTER_SCREEN,
      page: () => const UpiPaymentValidateRemitterScreen(),
      binding: UpiPaymentBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.UPI_PAYMENT_TRANSACTION_SLAB_SCREEN,
      page: () => const UpiPaymentTransactionSlabScreen(),
      binding: UpiPaymentBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.UPI_PAYMENT_TRANSACTION_STATUS_SCREEN,
      page: () => const UpiPaymentTransactionStatusScreen(),
      binding: UpiPaymentBinding(),
      transition: transition,
    ),

    /// CMS ///
    GetPage(
      name: Routes.CMS_SCREEN,
      page: () => const CmsScreen(),
      binding: CmsBinding(),
      transition: transition,
    ),

    /// Recharge ///
    GetPage(
      name: Routes.MOBILE_RECHARGE_SCREEN,
      page: () => const MobileRechargePage(),
      binding: RechargeBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.M_PLAN_SCREEN,
      page: () => const MPlanScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.R_PLAN_SCREEN,
      page: () => const RPlanScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.DTH_RECHARGE_SCREEN,
      page: () => const DthRechargeScreen(),
      binding: RechargeBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.POSTPAID_RECHARGE_SCREEN,
      page: () => const PostpaidRechargeScreen(),
      binding: RechargeBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.RECHARGE_STATUS_SCREEN,
      page: () => const RechargeStatusScreen(),
      binding: RechargeBinding(),
      transition: transition,
    ),

    /// BBPS ///
    GetPage(
      name: Routes.BBPS_CATEGORY_SCREEN,
      page: () => const BbpsCategoryScreen(),
      binding: BbpsBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.BBPS_SUB_CATEGORY_SCREEN,
      page: () => const BbpsSubCategoryScreen(),
      binding: BbpsBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.BBPS_FETCH_BILL_SCREEN,
      page: () => const BBPSFetchBillPage(),
      binding: BbpsBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.BBPS_STATUS_SCREEN,
      page: () => const BbpsStatusScreen(),
      binding: BbpsBinding(),
      transition: transition,
    ),

    /// BBPS Offline ///
    GetPage(
      name: Routes.BBPS_O_CATEGORY_SCREEN,
      page: () => const BbpsOCategoryScreen(),
      binding: BbpsOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.BBPS_O_SUB_CATEGORY_SCREEN,
      page: () => const BbpsOSubCategoryScreen(),
      binding: BbpsOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.BBPS_O_FETCH_BILL_SCREEN,
      page: () => const BbpsOFetchBillPage(),
      binding: BbpsOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.BBPS_O_STATUS_SCREEN,
      page: () => const BbpsOStatusScreen(),
      binding: BbpsOBinding(),
      transition: transition,
    ),

    /// Credit Card Paysprint ///
    GetPage(
      name: Routes.CREDIT_CARD_P_SCREEN,
      page: () => const CreditCardPScreen(),
      binding: CreditCardPBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDIT_CARD_P_TRANSACTION_SLAB_SCREEN,
      page: () => const CreditCardPTransactionSlabScreen(),
      binding: CreditCardPBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDIT_CARD_P_PAYMENT_STATUS_SCREEN,
      page: () => const CreditCardPPaymentStatusScreen(),
      binding: CreditCardPBinding(),
      transition: transition,
    ),

    /// Credit Card Mobikwik ///
    GetPage(
      name: Routes.CREDIT_CARD_M_SCREEN,
      page: () => const CreditCardMScreen(),
      binding: CreditCardMBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDIT_CARD_M_TRANSACTION_SLAB_SCREEN,
      page: () => const CreditCardMTransactionSlabScreen(),
      binding: CreditCardMBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDIT_CARD_M_PAYMENT_STATUS_SCREEN,
      page: () => const CreditCardMPaymentStatusScreen(),
      binding: CreditCardMBinding(),
      transition: transition,
    ),

    /// Credit Card Instantpay ///
    GetPage(
      name: Routes.CREDIT_CARD_I_SCREEN,
      page: () => const CreditCardIScreen(),
      binding: CreditCardIBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDIT_CARD_I_TRANSACTION_SLAB_SCREEN,
      page: () => const CreditCardITransactionSlabScreen(),
      binding: CreditCardIBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDIT_CARD_I_PAYMENT_STATUS_SCREEN,
      page: () => const CreditCardIPaymentStatusScreen(),
      binding: CreditCardIBinding(),
      transition: transition,
    ),

    /// Credit Card Offline ///
    GetPage(
      name: Routes.CREDIT_CARD_O_SCREEN,
      page: () => const CreditCardOScreen(),
      binding: CreditCardOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDIT_CARD_O_TRANSACTION_SLAB_SCREEN,
      page: () => const CreditCardOTransactionSlabScreen(),
      binding: CreditCardOBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDIT_CARD_O_PAYMENT_STATUS_SCREEN,
      page: () => const CreditCardOPaymentStatusScreen(),
      binding: CreditCardOBinding(),
      transition: transition,
    ),

    /// Product ///
    GetPage(
      name: Routes.PRODUCT_SCREEN,
      page: () => const ProductScreen(),
      binding: ProductBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.ALL_PRODUCT_SCREEN,
      page: () => const AllProductScreen(),
      binding: ProductBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.ALL_CATEGORY_SCREEN,
      page: () => const AllCategoryScreen(),
      binding: ProductBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.PRODUCT_DETAIL_SCREEN,
      page: () => const ProductDetailScreen(),
      binding: ProductBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.ADDRESS_SCREEN,
      page: () => const OrderPlaceScreen(),
      binding: ProductBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.ORDER_STATUS_SCREEN,
      page: () => const OrderStatusScreen(),
      binding: ProductBinding(),
      transition: transition,
    ),

    /// Pancard ///
    GetPage(
      name: Routes.PANCARD_SCREEN,
      page: () => const PancardScreen(),
      binding: PancardBinding(),
      transition: transition,
    ),

    /// Giftcard Banksathi ///
    GetPage(
      name: Routes.GIFTCARD_B_VERIFY_SCREEN,
      page: () => const GiftCardBVerifyScreen(),
      binding: GiftCardBBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.GIFTCARD_B_ONBORDING_SCREEN,
      page: () => const GiftCardBOnboardingScreen(),
      binding: GiftCardBBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.ELIGIBLE_PRODUCT_lIST_SCREEN,
      page: () => const EligibleProductListScreen(),
      binding: GiftCardBBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.ELIGIBLE_PRODUCT_DETAILS_SCREEN,
      page: () => const EligibleProductDetailsScreen(),
      binding: GiftCardBBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.GIFTCARD_B_BUY_STATUS_SCREEN,
      page: () => const GiftCardBStatusScreen(),
      binding: GiftCardBBinding(),
      transition: transition,
    ),

    /// Giftcard SayF ///
    GetPage(
      name: Routes.GIFTCARD_ONBORDING_SCREEN,
      page: () => const GiftCardOnboardingScreen(),
      binding: GiftCardBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.GIFTCARD_SCREEN,
      page: () => const GiftCardScreen(),
      binding: GiftCardBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.GIFTCARD_DETAIL_SCREEN,
      page: () => const GiftCardDetailScreen(),
      binding: GiftCardBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.GIFTCARD_BUY_STATUS_SCREEN,
      page: () => const GiftCardBuyStatusScreen(),
      binding: GiftCardBinding(),
      transition: transition,
    ),

    /// Ecollection ///
    // GetPage(
    //   name: Routes.ECOLLECTION_SCREEN,
    //   page: () => const EcollectionScreen(),
    //   binding: EcollectionBinding(),
    //   transition: transition,
    // ),

    /// Paytm Wallet ///
    // GetPage(
    //   name: Routes.PAYTM_WALLET_SCREEN,
    //   page: () => const PaytmWalletScreen(),
    //   binding: PaytmWalletBinding(),
    //   transition: transition,
    // ),

    /// Scan And Pay ///
    GetPage(
      name: Routes.SCAN_AND_PAY_SCREEN,
      page: () => const ScanAndPayScreen(),
      binding: ScanAndPayBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.PAY_SCREEN,
      page: () => const PayScreen(),
      binding: ScanAndPayBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.PAY_STATUS_SCREEN,
      page: () => const PayStatusScreen(),
      binding: ScanAndPayBinding(),
    ),

    /// Offline POS ///
    GetPage(
      name: Routes.OFFLINE_POS_SCREEN,
      page: () => OfflinePosScreen(),
      binding: OfflinePosBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.OFFLINE_POS_REPORT_SCREEN,
      page: () => const OfflinePosReportScreen(),
      binding: OfflinePosBinding(),
      transition: transition,
    ),

    /// Pancard Token ///
    GetPage(
      name: Routes.PANCARD_TOKEN_SCREEN,
      page: () => const PancardTokenScreen(),
      binding: OfflineTokenBinding(),
      transition: transition,
    ),

    /// Digital Signature Token ///
    GetPage(
      name: Routes.DIGITAL_SIGNATURE_TOKEN_SCREEN,
      page: () => const DigitalSignatureTokenScreen(),
      binding: OfflineTokenBinding(),
      transition: transition,
    ),

    /// Flight ///
    GetPage(
      name: Routes.FLIGHT_SPLASH_SCREEN,
      page: () => const FlightSplashScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FLIGHT_HOME_SCREEN,
      page: () => const FlightHomeScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FARE_CALENDER_SCREEN,
      page: () => const FareCalendarScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.SEARCHED_FLIGHT_LIST_SCREEN,
      page: () => const SearchedFlightListScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FLIGHT_DETAILS_SCREEN,
      page: () => const FlightDetailsScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FLIGHT_FILTER_SCREEN,
      page: () => const FlightFilterScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FLIGHT_EXTRA_SERVICES_SCREEN,
      page: () => const FlightExtraServicesScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FLIGHT_ADD_PASSENGERS_SCREEN,
      page: () => const FlightAddPassengersScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.REVIEW_TRIP_DETAILS_SCREEN,
      page: () => const ReviewTripDetailsScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FLIGHT_HISTORY_SCREEN,
      page: () => const FlightHistoryScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FLIGHT_PROCESSING_SCREEN,
      page: () => const FlightProcessStatusScreen(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FLIGHT_BOARDING_PASS_SCREEN,
      page: () => FlightBoardingPassScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.FLIGHT_BOOKING_HISTORY_DETAILS_SCREEN,
      page: () => const FlightBookingDetailsScreen(),
      binding: FlightBinding(),
      transition: transition,
    ),

    /// Bus ///
    GetPage(
      name: Routes.BUS_SPLASH_SCREEN,
      page: () => const BusSplashScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.BUS_HOME_SCREEN,
      page: () => const BusHomeScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.SEARCH_BUSES_SCREEN,
      page: () => const SearchBusesScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.BUS_BOOKING_REPORT_SCREEN,
      page: () => const BusBookingReportScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.SELECT_SEAT_SCREEN,
      page: () => const SelectSeatScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.BUS_PASSENGER_INFO_SCREEN,
      page: () => const BusPassengerInfoScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.BUS_SEARCH_SPLASH_SCREEN,
      page: () => const BusSearchSplashScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.BUS_DETAILS_SCREEN,
      page: () => const BusDetailsScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.BOARDING_DROPPING_POINT_SCREEN,
      page: () => const BoardingDroppingScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.BUS_FILTER_SORTING_SCREEN,
      page: () => const BusFilterSortingScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.BUS_BOOKING_SUCCESS_SCREEN,
      page: () => BookingSuccessScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.BUS_BOOKING_PROCESS_SCREEN,
      page: () => const BusProcessStatusScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),
    GetPage(
      name: Routes.BUS_BOOKING_HISTORY_DETAIL_SCREEN,
      page: () => const BusBookingHistoryDetailScreen(),
      transition: transition,
      binding: BusBookingBinding(),
    ),

    /// SIP ///
    GetPage(
      name: Routes.AXIS_SIP_SCREEN,
      page: () => const AxisSipScreen(),
      transition: transition,
      binding: SipBinding(),
    ),

    ///////////////////
    /// Distributor ///
    ///////////////////
    GetPage(
      name: Routes.DISTRIBUTOR_DASHBOARD_SCREEN,
      page: () => const DistributorDashBoardScreen(),
      binding: DistributorDashboardBinding(),
      transition: transition,
    ),

    /// Add/View User ///
    GetPage(
      name: Routes.ADD_USER_SCREEN,
      page: () => const AddUserScreen(),
      binding: AddUserBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.VIEW_USER_SCREEN,
      page: () => const ViewUserScreen(),
      binding: ViewUserBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.VIEW_CHILD_USER_SCREEN,
      page: () => const ViewChildUserScreen(),
      binding: ViewUserBinding(),
      transition: transition,
    ),

    /// Profile ///
    GetPage(
      name: Routes.GET_PROFILES_SCREEN,
      page: () => const GetProfilesScreen(),
      binding: ProfileBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREATE_PROFILE_SCREEN,
      page: () => const CreateProfileScreen(),
      binding: ProfileBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.UPDATE_PROFILE_SCREEN,
      page: () => const UpdateProfileScreen(),
      binding: ProfileBinding(),
      transition: transition,
    ),

    /// Credit/Debit ///
    GetPage(
      name: Routes.CREDIT_DEBIT_SCREEN,
      page: () => const CreditDebitScreen(),
      binding: CreditDebitBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CREDIT_DEBIT_HISTORY_SCREEN,
      page: () => const CreditDebitHistoryScreen(),
      binding: CreditDebitBinding(),
      transition: transition,
    ),

    /// Outstanding Collection ///
    GetPage(
      name: Routes.OUTSTANDING_COLLECTION_SCREEN,
      page: () => const OutstandingCollectionScreen(),
      binding: CreditDebitBinding(),
      transition: transition,
    ),

    /// Commission ///
    GetPage(
      name: Routes.COMMISSION_SCREEN,
      page: () => const CommissionScreen(),
      binding: CommissionBinding(),
      transition: transition,
    ),

    GetPage(
      name: Routes.COMMISSION_REPORT_SCREEN,
      page: () => const CommissionReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.COMMISSION_DETAILS_REPORT_SCREEN,
      page: () => const CommissionDetailsReportScreen(),
      binding: ReportBinding(),
      transition: transition,
    ),

    /// Payment ///
    GetPage(
      name: Routes.PAYMENT_REQUEST_SCREEN,
      page: () => const PaymentRequestScreen(),
      binding: PaymentBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.PAYMENT_HISTORY_SCREEN,
      page: () => const PaymentHistoryScreen(),
      binding: PaymentBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.ADD_PAYMENT_BANK_SCREEN,
      page: () => const AddPaymentBankScreen(),
      binding: PaymentBankBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.PAYMENT_BANK_LIST_SCREEN,
      page: () => const PaymentBankListScreen(),
      binding: PaymentBankBinding(),
      transition: transition,
    ),
    /// Chargeback Raised
    GetPage(
      name: Routes.CHARGEBACK_RAISED_SCREEN,
      page: () => const ChargebackRaisedScreen(),
      binding: ChargebackBinding(),
      transition: transition,
    ),
    GetPage(
      name: Routes.CHARGEBACK_DOCUMENTS_SCREEN,
      page: () => const ChargebackDocumentsScreen(),
      binding: ChargebackBinding(),
      transition: transition,
    ),
  ];
}
