// ignore_for_file: constant_identifier_names

class Routes {
  static const SPLASH_SCREEN = '/splash_screen';
  static const ON_BOARDING_SCREEN = '/on_boarding_screen';
  static const AUTH_SCREEN = '/auth_screen';
  static const SIGN_UP_SCREEN = '/sign_up_screen';
  static const SET_PASSWORD_SCREEN = '/set_password_screen';
  static const SET_FORGOT_PASSWORD_SCREEN = '/set_forgot_password_screen';
  static const WEBSITE_CONTENT_SCREEN = '/website_content_screen';
  static const IMAGE_CAPTURE_SCREEN = '/image_capture_screen';
  static const VIDEO_RECORDING_SCREEN = '/video_recording_screen';
  static const NO_INTERNET_CONNECTION_SCREEN = '/no_internet_connection_screen';
  static const NO_LOCATION_PERMISSION_SCREEN = '/no_location_permission_screen';
  static const SEARCHABLE_LIST_VIEW_SCREEN = '/searchable_list_view_screen';
  static const SEARCHABLE_LIST_VIEW_PAGINATION_SCREEN = '/searchable_list_view_pagination_screen';
  static const SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN = '/searchable_list_view_with_image_screen';
  static const FLIGHT_PROCESSING_SCREEN = '/flight_processing_screen';
  // Kyc
  static const KYC_SCREEN = '/kyc_screen';
  static const PERSONAL_INFO_SCREEN = '/personal_info_screen';
  // Settlement
  static const AEPS_SETTLEMENT_HOME_SCREEN = '/aeps_settlement_home_screen';
  static const AEPS_TO_BANK_SCREEN = '/aeps_to_bank_screen';
  static const AEPS_TO_DIRECT_BANK_SCREEN = '/aeps_to_direct_bank_screen';
  static const AEPS_TO_MAIN_WALLET_SCREEN = '/aeps_to_main_wallet_screen';
  static const AEPS_SETTLEMENT_HISTORY_SCREEN = '/aeps_settlement_history_screen';
  static const AEPS_ADD_BANK_SCREEN = '/aeps_add_bank_screen';
  static const AEPS_BANK_LIST_SCREEN = '/aeps_bank_list_screen';
  // Add Money
  static const ADD_MONEY_SCREEN = '/add_money_screen';
  static const ADD_MONEY_STATUS_SCREEN = '/add_money_status_screen';
  static const WEB_VIEW_SCREEN = '/web_view_screen';
  // Payment Page
  static const PAYMENT_PAGE_SCREEN = '/payment_page_screen';
  // Payment Link
  static const PAYMENT_LINK_SCREEN = '/payment_link_screen';
  static const PAYMENT_LINK_DETAILS_SCREEN = '/payment_link_details_screen';
  static const CREATE_PAYMENT_LINK_SCREEN = '/create_payment_link_screen';
  static const PAYMENT_LINK_REMINDER_SETTINGS_SCREEN = '/payment_link_reminder_settings_screen';
  // Internal Transafer
  static const INTERNAL_TRANSFER_SCREEN = '/internal_transfer_screen';
  // Topup
  static const TOPUP_REQUEST_SCREEN = '/topup_request_screen';
  static const TOPUP_HISTORY_SCREEN = '/topup_history_screen';
  // News
  static const ALL_NEWS_SCREEN = '/all_news_screen';
  // Receipt
  static const RECEIPT_SCREEN = '/receipt_screen';
  static const BALANCE_ENQUIRY_RECEIPT_SCREEN = '/balance_enquiry_receipt_screen';
  static const MINI_STATEMENT_RECEIPT_SCREEN = '/mini_statement_receipt_screen';
  // Raise Complaint
  static const RAISE_COMPLAINT_SCREEN = '/raise_complaint_screen';
  // Setting
  static const ID_CARD_SCREEN = '/id_card_screen';
  static const CHANGE_PASSWORD_SCREEN = '/change_password_screen';
  static const CHANGE_TPIN_SCREEN = '/change_tpin_screen';
  static const CONTACT_US_SCREEN = '/contact_us_screen';
  // Reports
  static const LOGIN_REPORT_SCREEN = '/login_report_screen';
  static const WALLET_PASSBOOK_REPORT_SCREEN = '/wallet_passbook_report_screen';
  static const PAYMENT_LOAD_REPORT_SCREEN = '/payment_load_report_screen';
  static const TRANSACTION_REPORT_SCREEN = '/transaction_report_screen';
  static const TRANSACTION_REPORT_DETAILS_SCREEN = '/transaction_report_details_screen';
  static const TRANSACTION_SINGLE_REPORT_SCREEN = '/transaction_single_report_screen';
  static const TRANSACTION_BULK_REPORT_SCREEN = '/transaction_bulk_report_screen';
  static const RAISED_COMPLAINTS_REPORT_SCREEN = '/raised_complaints_report_screen';
  static const AEPS_WALLET_PASSBOOK_REPORT_SCREEN = '/aeps_wallet_passbook_report_screen';
  static const BANK_WITHDRAWAL_REPORT_SCREEN = '/bank_withdrawal_report_screen';
  static const BUSINESS_PERFORMANCE_REPORT_SCREEN = '/business_performance_report_screen';
  static const AGENT_PERFORMANCE_REPORT_SCREEN = '/agent_performance_report_screen';
  static const ORDER_REPORT_SCREEN = '/order_report_screen';
  static const OFFLINE_TOKEN_REPORT_SCREEN = '/offline_token_report_screen';
  static const BANK_SATHI_LEAD_REPORT_SCREEN = '/bank_sathi_lead_report_screen';
  static const NOTIFICATION_REPORT_SCREEN = '/notification_report_screen';
  static const AXIS_SIP_REPORT_SCREEN = '/axis_sip_report_screen';
  static const SEARCH_TRANSACTION_REPORT_SCREEN = '/search_transaction_report_screen';

  ////////////////
  /// Retailer ///
  ////////////////
  static const RETAILER_DASHBOARD_SCREEN = '/retailer_dashboard_screen';
  // AEPS
  static const AEPS_GATEWAY_SCREEN = '/aeps_gateway_screen';
  static const AEPS_TRANSACTION_SCREEN = '/aeps_transaction_screen';
  static const AEPS_MINI_STATEMENT_SCREEN = '/aeps_mini_statement_screen';
  // Onboarding
  static const MONEYART_ONBOARDING_SCREEN = '/moneyart_onboarding_screen';
  static const FINGPAY_ONBOARDING_SCREEN = '/fingpay_onboarding_screen';
  static const INSTANTPAY_ONBOARDING_SCREEN = '/instantpay_onboarding_screen';
  static const PAYSPRINT_ONBOARDING_SCREEN = '/paysprint_onboarding_screen';
  // MATM
  static const MATM_GATEWAY_SCREEN = '/matm_gateway_screen';
  static const CREDO_PAY_ONBOARDING_SCREEN = '/credo_pay_onboarding_screen';
  static const CREDO_PAY_TRANSACTION_SCREEN = '/credo_pay_transaction_screen';
  static const FINGPAY_TRANSACTION_SCREEN = '/fingpay_transaction_screen';
  // DMT Moneyart
  static const DMT_BENEFICIARY_LIST_SCREEN = '/dmt_beneficiary_list_screen';
  static const DMT_TRANSACTION_SCREEN = '/dmt_transaction_screen';
  static const DMT_ADD_RECIPIENT_SCREEN = '/dmt_add_recipient_screen';
  static const DMT_REMITTER_REGISTRATION_SCREEN = '/dmt_remitter_registration_screen';
  static const DMT_VALIDATE_REMITTER_SCREEN = '/dmt_validate_remitter_screen';
  static const DMT_TRANSACTION_SLAB_SCREEN = '/dmt_transaction_slab_screen';
  static const DMT_TRANSACTION_STATUS_SCREEN = '/dmt_transaction_status_screen';
  // DMT Bankit
  static const DMT_B_BENEFICIARY_LIST_SCREEN = '/dmt_b_beneficiary_list_screen';
  static const DMT_B_TRANSACTION_SCREEN = '/dmt_b_transaction_screen';
  static const DMT_B_ADD_RECIPIENT_SCREEN = '/dmt_b_add_recipient_screen';
  static const DMT_B_REMITTER_REGISTRATION_SCREEN = '/dmt_b_remitter_registration_screen';
  static const DMT_B_VALIDATE_REMITTER_SCREEN = '/dmt_b_validate_remitter_screen';
  static const DMT_B_TRANSACTION_SLAB_SCREEN = '/dmt_b_transaction_slab_screen';
  static const DMT_B_TRANSACTION_STATUS_SCREEN = '/dmt_b_transaction_status_screen';
  // DMT Ezypay
  static const DMT_E_BENEFICIARY_LIST_SCREEN = '/dmt_e_beneficiary_list_screen';
  static const DMT_E_TRANSACTION_SCREEN = '/dmt_e_transaction_screen';
  static const DMT_E_ADD_RECIPIENT_SCREEN = '/dmt_e_add_recipient_screen';
  static const DMT_E_REMITTER_REGISTRATION_SCREEN = '/dmt_e_remitter_registration_screen';
  static const DMT_E_VALIDATE_REMITTER_SCREEN = '/dmt_e_validate_remitter_screen';
  static const DMT_E_TRANSACTION_SLAB_SCREEN = '/dmt_e_transaction_slab_screen';
  static const DMT_E_TRANSACTION_STATUS_SCREEN = '/dmt_e_transaction_status_screen';
  // DMT Instantpay
  static const DMT_I_BENEFICIARY_LIST_SCREEN = '/dmt_i_beneficiary_list_screen';
  static const DMT_I_TRANSACTION_SCREEN = '/dmt_i_transaction_screen';
  static const DMT_I_ADD_RECIPIENT_SCREEN = '/dmt_i_add_recipient_screen';
  static const DMT_I_REMITTER_REGISTRATION_SCREEN = '/dmt_i_remitter_registration_screen';
  static const DMT_I_VALIDATE_REMITTER_SCREEN = '/dmt_i_validate_remitter_screen';
  static const DMT_I_TRANSACTION_SLAB_SCREEN = '/dmt_i_transaction_slab_screen';
  static const DMT_I_TRANSACTION_STATUS_SCREEN = '/dmt_i_transaction_status_screen';
  // DMT NSDL Bank
  static const DMT_N_BENEFICIARY_LIST_SCREEN = '/dmt_n_beneficiary_list_screen';
  static const DMT_N_TRANSACTION_SCREEN = '/dmt_n_transaction_screen';
  static const DMT_N_ADD_RECIPIENT_SCREEN = '/dmt_n_add_recipient_screen';
  static const DMT_N_REMITTER_REGISTRATION_SCREEN = '/dmt_n_remitter_registration_screen';
  static const DMT_N_VALIDATE_REMITTER_SCREEN = '/dmt_n_validate_remitter_screen';
  static const DMT_N_TRANSACTION_SLAB_SCREEN = '/dmt_n_transaction_slab_screen';
  static const DMT_N_TRANSACTION_STATUS_SCREEN = '/dmt_n_transaction_status_screen';
  // DMT Offline
  static const DMT_O_BENEFICIARY_LIST_SCREEN = '/dmt_o_beneficiary_list_screen';
  static const DMT_O_TRANSACTION_SCREEN = '/dmt_o_transaction_screen';
  static const DMT_O_ADD_RECIPIENT_SCREEN = '/dmt_o_add_recipient_screen';
  static const DMT_O_REMITTER_REGISTRATION_SCREEN = '/dmt_o_remitter_registration_screen';
  static const DMT_O_VALIDATE_REMITTER_SCREEN = '/dmt_o_validate_remitter_screen';
  static const DMT_O_TRANSACTION_SLAB_SCREEN = '/dmt_o_transaction_slab_screen';
  static const DMT_O_TRANSACTION_STATUS_SCREEN = '/dmt_o_transaction_status_screen';
  // DMT Paysprint
  static const DMT_P_BENEFICIARY_LIST_SCREEN = '/dmt_p_beneficiary_list_screen';
  static const DMT_P_TRANSACTION_SCREEN = '/dmt_p_transaction_screen';
  static const DMT_P_ADD_RECIPIENT_SCREEN = '/dmt_p_add_recipient_screen';
  static const DMT_P_REMITTER_REGISTRATION_SCREEN = '/dmt_p_remitter_registration_screen';
  static const DMT_P_VALIDATE_REMITTER_SCREEN = '/dmt_p_validate_remitter_screen';
  static const DMT_P_TRANSACTION_SLAB_SCREEN = '/dmt_p_transaction_slab_screen';
  static const DMT_P_TRANSACTION_STATUS_SCREEN = '/dmt_p_transaction_status_screen';
  // UPI Payment
  static const UPI_PAYMENT_BENEFICIARY_LIST_SCREEN = '/upi_payment_beneficiary_list_screen';
  static const UPI_PAYMENT_TRANSACTION_SCREEN = '/upi_payment_transaction_screen';
  static const UPI_PAYMENT_ADD_RECIPIENT_SCREEN = '/upi_payment_add_recipient_screen';
  static const UPI_PAYMENT_REMITTER_REGISTRATION_SCREEN = '/upi_payment_remitter_registration_screen';
  static const UPI_PAYMENT_VALIDATE_REMITTER_SCREEN = '/upi_payment_validate_remitter_screen';
  static const UPI_PAYMENT_TRANSACTION_SLAB_SCREEN = '/upi_payment_transaction_slab_screen';
  static const UPI_PAYMENT_TRANSACTION_STATUS_SCREEN = '/upi_payment_transaction_status_screen';
  // CMS
  static const CMS_SCREEN = '/cms_screen';
  // Recharge
  static const MOBILE_RECHARGE_SCREEN = '/mobile_recharge_screen';
  static const M_PLAN_SCREEN = '/m_plan_screen';
  static const R_PLAN_SCREEN = '/r_plan_screen';
  static const DTH_RECHARGE_SCREEN = '/dth_recharge_screen';
  static const POSTPAID_RECHARGE_SCREEN = '/postpaid_recharge_screen';
  static const RECHARGE_STATUS_SCREEN = '/recharge_status_screen';
  // BBPS
  static const BBPS_CATEGORY_SCREEN = '/bbps_category_screen';
  static const BBPS_SUB_CATEGORY_SCREEN = '/bbps_sub_category_screen';
  static const BBPS_FETCH_BILL_SCREEN = '/bbps_fetch_bill_screen';
  static const BBPS_STATUS_SCREEN = '/bbps_status_screen';
  // BBPS Offline
  static const BBPS_O_CATEGORY_SCREEN = '/bbps_o_category_screen';
  static const BBPS_O_SUB_CATEGORY_SCREEN = '/bbps_o_sub_category_screen';
  static const BBPS_O_FETCH_BILL_SCREEN = '/bbps_o_fetch_bill_screen';
  static const BBPS_O_STATUS_SCREEN = '/bbps_o_status_screen';
  // Credit Card Paysprint
  static const CREDIT_CARD_P_SCREEN = '/credit_card_p_screen';
  static const CREDIT_CARD_P_TRANSACTION_SLAB_SCREEN = '/credit_card_p_transaction_slab_screen';
  static const CREDIT_CARD_P_PAYMENT_STATUS_SCREEN = '/credit_card_p_payment_status_screen';
  // Credit Card Mobikwik
  static const CREDIT_CARD_M_SCREEN = '/credit_card_m_screen';
  static const CREDIT_CARD_M_TRANSACTION_SLAB_SCREEN = '/credit_card_m_transaction_slab_screen';
  static const CREDIT_CARD_M_PAYMENT_STATUS_SCREEN = '/credit_card_m_payment_status_screen';
  // Credit Card Instantpay
  static const CREDIT_CARD_I_SCREEN = '/credit_card_i_screen';
  static const CREDIT_CARD_I_TRANSACTION_SLAB_SCREEN = '/credit_card_i_transaction_slab_screen';
  static const CREDIT_CARD_I_PAYMENT_STATUS_SCREEN = '/credit_card_i_payment_status_screen';
  // Credit Card Offline
  static const CREDIT_CARD_O_SCREEN = '/credit_card_o_screen';
  static const CREDIT_CARD_O_TRANSACTION_SLAB_SCREEN = '/credit_card_o_transaction_slab_screen';
  static const CREDIT_CARD_O_PAYMENT_STATUS_SCREEN = '/credit_card_o_payment_status_screen';
  // Product
  static const PRODUCT_SCREEN = '/product_screen';
  static const ALL_PRODUCT_SCREEN = '/all_product_screen';
  static const ALL_CATEGORY_SCREEN = '/all_category_screen';
  static const PRODUCT_DETAIL_SCREEN = '/product_detail_screen';
  static const ADDRESS_SCREEN = '/address_screen';
  static const ORDER_STATUS_SCREEN = '/order_status_screen';
  // Pancard
  static const PANCARD_SCREEN = '/pancard_screen';
  // Giftcard SayF
  static const GIFTCARD_SCREEN = '/giftcard_screen';
  static const GIFTCARD_DETAIL_SCREEN = '/giftcard_detail_screen';
  static const GIFTCARD_ONBORDING_SCREEN = '/giftcard_onbording_screen';
  static const GIFTCARD_BUY_STATUS_SCREEN = '/giftcard_buy_status_screen';
  // Giftcard BankSathi
  static const GIFTCARD_B_VERIFY_SCREEN = '/giftcard_b_verify_screen';
  static const GIFTCARD_B_ONBORDING_SCREEN = '/giftcard_b_onbording_screen';
  static const ELIGIBLE_PRODUCT_lIST_SCREEN = '/eligible_product_list_screen';
  static const ELIGIBLE_PRODUCT_DETAILS_SCREEN = '/eligible_product_details_screen';
  static const GIFTCARD_B_BUY_STATUS_SCREEN = '/giftcard_b_buy_status_screen';
  // Ecollection
  static const ECOLLECTION_SCREEN = '/ecollection_screen';
  // Paytm Wallet
  static const PAYTM_WALLET_SCREEN = '/paytm_wallet_screen';
  // Scan and pay
  static const SCAN_AND_PAY_SCREEN = '/scan_and_pay_screen';
  static const PAY_SCREEN = '/pay_screen';
  static const PAY_STATUS_SCREEN = '/pay_status_screen';
  // Offline POS
  static const OFFLINE_POS_SCREEN = '/offline_pos_screen';
  static const OFFLINE_POS_REPORT_SCREEN = '/offline_pos_report_screen';
  // Pancard Token
  static const PANCARD_TOKEN_SCREEN = '/pancard_token_screen';
  // Digital Signature Token
  static const DIGITAL_SIGNATURE_TOKEN_SCREEN = '/digital_signature_token_screen';
  // Flight Booking
  static const FLIGHT_SPLASH_SCREEN = '/flight_splash_screen';
  static const FLIGHT_HOME_SCREEN = '/flight_home_screen';
  static const FARE_CALENDER_SCREEN = '/fare_calender_screen';
  static const SEARCHED_FLIGHT_LIST_SCREEN = '/one_way_flight_list_screen';
  static const FLIGHT_DETAILS_SCREEN = '/flight_details_screen';
  static const FLIGHT_FILTER_SCREEN = '/flight_filter_screen';
  static const FLIGHT_EXTRA_SERVICES_SCREEN = '/flight_extra_services_screen';
  static const FLIGHT_ADD_PASSENGERS_SCREEN = '/flight_add_passengers_screen';
  static const REVIEW_TRIP_DETAILS_SCREEN = '/review_trip_details_screen';
  static const FLIGHT_HISTORY_SCREEN = '/flight_history_screen';
  static const FLIGHT_BOARDING_PASS_SCREEN = '/flight_boarding_pass_screen';
  static const FLIGHT_BOOKING_HISTORY_DETAILS_SCREEN = '/flight_booking_history_details_screen';
  // Bus Booking
  static const BUS_SPLASH_SCREEN = '/bus_splash_screen';
  static const BUS_HOME_SCREEN = '/bus_booking_home_screen';
  static const BUS_SEARCH_SPLASH_SCREEN = '/bus_search_splash_screen';
  static const SEARCH_BUSES_SCREEN = '/search_buses_screen';
  static const BUS_FILTER_SORTING_SCREEN = '/bus_filter_sorting_screen';
  static const SELECT_SEAT_SCREEN = '/select_seat_screen';
  static const BOARDING_DROPPING_POINT_SCREEN = '/boarding_dropping_point_screen';
  static const BUS_PASSENGER_INFO_SCREEN = '/bus_passenger_info_screen';
  static const BUS_BOOKING_REPORT_SCREEN = '/bus_booking_report_screen';
  static const BUS_DETAILS_SCREEN = '/bus_details_screen';
  static const MY_BOOKINGS_SCREEN = '/my_bookings_screen';
  static const BUS_BOOKING_SUCCESS_SCREEN = '/booking_success_screen';
  static const BUS_BOOKING_PROCESS_SCREEN = '/bus_process_status_screen';
  static const BUS_BOOKING_HISTORY_DETAIL_SCREEN = '/bus_booking_history_detail_screen';
  //SIP
  static const AXIS_SIP_SCREEN = '/axis_sip_screen';

  ///////////////////
  /// Distributor ///
  ///////////////////
  static const DISTRIBUTOR_DASHBOARD_SCREEN = '/distributor_dashboard_screen';
  // Add/View User
  static const ADD_USER_SCREEN = '/add_user_screen';
  static const VIEW_USER_SCREEN = '/view_user_screen';
  static const VIEW_CHILD_USER_SCREEN = '/view_child_user_screen';
  // Profile
  static const GET_PROFILES_SCREEN = '/get_profiles_screen';
  static const CREATE_PROFILE_SCREEN = '/create_profile_screen';
  static const UPDATE_PROFILE_SCREEN = '/update_profile_screen';
  // Credit/Debit
  static const CREDIT_DEBIT_SCREEN = '/credit_screen';
  static const CREDIT_DEBIT_HISTORY_SCREEN = '/credit_debit_history_screen';
  // Outstanding Collection
  static const OUTSTANDING_COLLECTION_SCREEN = '/outstanding_collection_screen';
  // Commission
  static const COMMISSION_SCREEN = '/commission_screen';
  static const COMMISSION_REPORT_SCREEN = '/commission_report_screen';
  static const COMMISSION_DETAILS_REPORT_SCREEN = '/commission_details_report_screen';
  // Payment
  static const PAYMENT_REQUEST_SCREEN = '/payment_request_screen';
  static const PAYMENT_HISTORY_SCREEN = '/payment_history_screen';
  static const ADD_PAYMENT_BANK_SCREEN = '/add_payment_bank_screen';
  static const PAYMENT_BANK_LIST_SCREEN = '/payment_bank_list_screen';
  //Chargeback Raised
  static const CHARGEBACK_RAISED_SCREEN = '/chargeback_raised_screen';
  static const CHARGEBACK_DOCUMENTS_SCREEN = '/chargeback_documents_screen';
}
