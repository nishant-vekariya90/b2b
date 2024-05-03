import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/flight/country_model.dart';
import '../../../../../model/flight/flight_passenger_details_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field_with_title.dart';
import 'flight_widget.dart';

class FlightAddPassengersScreen extends StatefulWidget {
  const FlightAddPassengersScreen({super.key});

  @override
  State<FlightAddPassengersScreen> createState() => _FlightAddPassengersScreenState();
}

class _FlightAddPassengersScreenState extends State<FlightAddPassengersScreen> {
  FlightController flightController = Get.find();
  GlobalKey<FormState> addContactInfoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> addPassengerFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> addGstFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    createPassengerData();
  }

  Future<void> createPassengerData() async {
    try {
      flightController.mobileTextController.text = getStoredUserBasicDetails().mobile!;
      flightController.emailTextController.text = getStoredUserBasicDetails().email!;
      if (flightController.masterCountryList.isEmpty) {
        await flightController.getCountryList();
      }
      if (flightController.passengerListForExtraServices.isEmpty) {
        for (int i = 0; i < flightController.travellersAdultCount; i++) {
          flightController.passengerListForExtraServices.add(
            PassengerDetailsModel(
              passengerId: generateUniqueNumber(),
              title: 'Mr',
              firstName: '',
              lastName: '',
              dateOfBirth: '',
              gender: 'Male',
              address: '',
              zipcode: '',
              type: 'Adult ${i + 1}',
              isFilled: false,
              passportNumber: '',
              passportExpiryDate: '',
              selectedSeatModel: null,
              selectedMealModel: null,
              selectedBaggageModel: null,
            ),
          );
        }
        for (int i = 0; i < flightController.travellersChildCount; i++) {
          flightController.passengerListForExtraServices.add(
            PassengerDetailsModel(
              passengerId: generateUniqueNumber(),
              title: 'Mr',
              firstName: '',
              lastName: '',
              dateOfBirth: '',
              gender: 'Male',
              address: '',
              zipcode: '',
              type: 'Child ${i + 1}',
              isFilled: false,
              passportNumber: '',
              passportExpiryDate: '',
              selectedSeatModel: null,
              selectedMealModel: null,
              selectedBaggageModel: null,
            ),
          );
        }
        for (int i = 0; i < flightController.travellersInfantCount; i++) {
          flightController.passengerListForExtraServices.add(
            PassengerDetailsModel(
              passengerId: generateUniqueNumber(),
              title: 'Mr',
              firstName: '',
              lastName: '',
              dateOfBirth: '',
              gender: 'Male',
              address: '',
              zipcode: '',
              type: 'Infant ${i + 1}',
              isFilled: false,
              passportNumber: '',
              passportExpiryDate: '',
              selectedSeatModel: null,
              selectedMealModel: null,
              selectedBaggageModel: null,
            ),
          );
        }
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    super.dispose();
    flightController.resetVariablesAddPassengers();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarBgImage: Assets.imagesFlightTopBgImage,
      title: 'Add Passengers',
      appBarTextStyle: TextHelper.size18.copyWith(
        color: ColorsForApp.whiteColor,
        fontFamily: mediumGoogleSansFont,
      ),
      leadingIconColor: ColorsForApp.whiteColor,
      isShowLeadingIcon: true,
      mainBody: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        children: [
          // Primary contact deatils
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorsForApp.grayScale500.withOpacity(0.5),
              ),
            ),
            child: Form(key: addContactInfoFormKey, child: primaryContactWidget()),
          ),
          height(1.h),
          // Passenger details widget
          passengerDetailsWidget(),
          height(1.h),
          // Gst details widget
          Visibility(
            visible: flightController.selectedFlightData.isGSTRequired ?? false,
            child: gstDetailsWidget(),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: ColorsForApp.grayScale200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Checkbox(
                  value: flightController.isSeatMealBaggageCheckbox.value,
                  activeColor: ColorsForApp.primaryColor,
                  onChanged: (value) {
                    flightController.isSeatMealBaggageCheckbox.value = value!;
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                ),
              ),
              Text(
                'Book seats, meal and baggage services',
                style: TextHelper.size14.copyWith(
                  fontFamily: regularNunitoFont,
                ),
              ),
            ],
          ),
          height(1.h),
          FlightContinueButton(
            title: 'Fare Breakup',
            offeredFare: flightController.searchedTripType.value == TripType.RETURN_DOM
                ? flightController.calculateTotalFareBreakup(
                    onwardFare: flightController.onwardFlightFareQuoteData.value.offeredFare ?? '0',
                    onwardDiscount: flightController.onwardFlightFareQuoteData.value.discount ?? '0',
                    returnFare: flightController.returnFlightFareQuoteData.value.offeredFare ?? '0',
                    returnDiscount: flightController.returnFlightFareQuoteData.value.discount ?? '0',
                  )
                : flightController.calculateTotalFareBreakup(
                    onwardFare: flightController.flightFareQuoteData.value.offeredFare ?? '0',
                    onwardDiscount: flightController.flightFareQuoteData.value.discount ?? '0',
                  ),
            leftIconWidget: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ColorsForApp.lightBlackColor,
            ),
            onPriceTap: () {
              // Fare breakup bottomsheet
              if (flightController.searchedTripType.value == TripType.RETURN_DOM) {
                if (flightController.onwardFlightFareQuoteData.value.adtFareSummary != null ||
                    flightController.onwardFlightFareQuoteData.value.chdFareSummary != null ||
                    flightController.onwardFlightFareQuoteData.value.inFareSummary != null ||
                    flightController.returnFlightFareQuoteData.value.adtFareSummary != null ||
                    flightController.returnFlightFareQuoteData.value.chdFareSummary != null ||
                    flightController.returnFlightFareQuoteData.value.inFareSummary != null) {
                  showFareBreakupBottomSheet(
                    onwardFareQuoteData: flightController.onwardFlightFareQuoteData.value,
                    returnFareQuoteData: flightController.returnFlightFareQuoteData.value,
                  );
                }
              } else {
                if (flightController.flightFareQuoteData.value.adtFareSummary != null ||
                    flightController.flightFareQuoteData.value.chdFareSummary != null ||
                    flightController.flightFareQuoteData.value.inFareSummary != null) {
                  showFareBreakupBottomSheet(
                    onwardFareQuoteData: flightController.flightFareQuoteData.value,
                    isShowRefundable: flightController.flightFareQuoteData.value.isRefundable ?? false,
                  );
                }
              }
            },
            continueButton: Obx(
              () => CommonButton(
                width: 50.w,
                label: flightController.isSeatMealBaggageCheckbox.value == true ? 'Proceed to Select Seat' : 'Proceed to Pay',
                bgColor: flightController.areAllPassengersFilled() ? ColorsForApp.primaryColor : ColorsForApp.lightGreyColor,
                style: TextHelper.size14.copyWith(
                  fontFamily: boldNunitoFont,
                  color: flightController.areAllPassengersFilled() ? ColorsForApp.whiteColor : ColorsForApp.grayScale500,
                ),
                onPressed: flightController.areAllPassengersFilled()
                    ? () {
                        // Validate contact details
                        if (addContactInfoFormKey.currentState!.validate()) {
                          // Check if GST checkbox is selected and validate GST form if selected
                          if (flightController.isGstCheckBoxSelected.value == true && !addGstFormKey.currentState!.validate()) {
                            // GST form is not valid
                            return;
                          }
                          // Check if seat/meal/baggage checkbox is selected
                          if (flightController.isSeatMealBaggageCheckbox.value == true) {
                            Get.toNamed(Routes.FLIGHT_EXTRA_SERVICES_SCREEN);
                          } else {
                            Get.toNamed(Routes.REVIEW_TRIP_DETAILS_SCREEN);
                          }
                        }
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Primary contact widget
  Widget primaryContactWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height(1.h),
        Text(
          'Primary Contact Details',
          style: TextHelper.size15.copyWith(
            fontFamily: boldNunitoFont,
          ),
        ),
        Text(
          'Your ticket SMS and Email will be sent here',
          style: TextHelper.size13.copyWith(
            fontFamily: mediumNunitoFont,
            color: ColorsForApp.grayScale500,
          ),
        ),
        height(1.h),
        CustomTextFieldWithTitle(
          controller: flightController.mobileTextController,
          title: 'Mobile',
          hintText: 'Enter mobile',
          isCompulsory: true,
          maxLength: 10,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          textInputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          suffixIcon: Icon(
            Icons.call_rounded,
            size: 18,
            color: ColorsForApp.secondaryColor.withOpacity(0.5),
          ),
          validator: (value) {
            if (flightController.mobileTextController.text.trim().isEmpty) {
              return 'Please enter mobile number';
            } else if (flightController.mobileTextController.text.length < 10) {
              return 'Please enter valid mobile number';
            }
            return null;
          },
        ),
        width(1.w),
        // Email
        CustomTextFieldWithTitle(
          controller: flightController.emailTextController,
          title: 'Email',
          hintText: 'Enter email',
          isCompulsory: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          suffixIcon: Icon(
            Icons.email_rounded,
            size: 18,
            color: ColorsForApp.secondaryColor.withOpacity(0.5),
          ),
          validator: (value) {
            if (flightController.emailTextController.text.trim().isEmpty) {
              return 'Please enter email';
            } else if (!GetUtils.isEmail(flightController.emailTextController.text.trim())) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        // Address
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextFieldWithTitle(
                controller: flightController.passengerAddressController,
                title: 'Address',
                hintText: 'Enter address',
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                suffixIcon: Icon(
                  Icons.home_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                validator: (value) {
                  if (flightController.passengerAddressController.text.trim().isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
            ),
            width(3.w),
            // zipcode
            Expanded(
              child: CustomTextFieldWithTitle(
                controller: flightController.passengerPinCodeController,
                title: 'Zipcode',
                hintText: 'Enter zipcode',
                isCompulsory: true,
                maxLength: 7,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (flightController.passengerPinCodeController.text.trim().isEmpty) {
                    return 'Please enter zipcode';
                  } else if (flightController.passengerPinCodeController.text.trim().length < 3) {
                    return 'Please enter valid zipcode';
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City
            Expanded(
              child: CustomTextFieldWithTitle(
                controller: flightController.cityTextController,
                title: 'City',
                hintText: 'Enter city',
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                suffixIcon: Icon(
                  Icons.location_city_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                validator: (value) {
                  if (flightController.cityTextController.text.trim().isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
            ),
            width(3.w),
            // Country
            Expanded(
              child: CustomTextFieldWithTitle(
                controller: flightController.countryTextController,
                title: 'Country',
                hintText: 'Select country',
                readOnly: true,
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                suffixIcon: Icon(
                  Icons.location_city_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                onTap: () async {
                  CountryModel selectedCountry = await Get.toNamed(
                    Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                    arguments: [
                      flightController.masterCountryList, // modelList
                      'masterCountryList', // modelName
                    ],
                  );
                  if (selectedCountry.name != null && selectedCountry.name!.isNotEmpty) {
                    flightController.countryTextController.text = selectedCountry.name!;
                    flightController.selectedCountryCode.value = selectedCountry.code!;
                    flightController.selectedCellCountryCode.value = selectedCountry.phoneCode!;
                    flightController.selectednationality.value = selectedCountry.nationality!;
                  }
                },
                validator: (value) {
                  if (flightController.countryTextController.text.trim().isEmpty) {
                    return 'Please select country';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Passenger details widget
  Widget passengerDetailsWidget() {
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: flightController.passengerListForExtraServices.length,
        itemBuilder: (context, index) {
          PassengerDetailsModel passengerDetailsModel = flightController.passengerListForExtraServices[index];
          return InkWell(
            onTap: () {
              addUpdatePassengerBottomSheet(index, passengerDetailsModel);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: ColorsForApp.whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColorsForApp.grayScale500.withOpacity(0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Person icon
                  Visibility(
                    visible: passengerDetailsModel.firstName.isNotEmpty && passengerDetailsModel.lastName.isNotEmpty ? true : false,
                    child: Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: Icon(
                        Icons.account_circle_rounded,
                        size: 20,
                        color: ColorsForApp.grayScale500,
                      ),
                    ),
                  ),
                  // Title | DOB
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        passengerDetailsModel.title.isNotEmpty && passengerDetailsModel.firstName.isNotEmpty && passengerDetailsModel.lastName.isNotEmpty
                            ? Text(
                                '${passengerDetailsModel.title} ${passengerDetailsModel.firstName} ${passengerDetailsModel.lastName}',
                                style: TextHelper.size14.copyWith(
                                  fontFamily: boldNunitoFont,
                                ),
                              )
                            : Text(
                                passengerDetailsModel.type,
                                style: TextHelper.size14.copyWith(
                                  fontFamily: boldNunitoFont,
                                ),
                              ),
                        // DOB
                        Visibility(
                          visible: passengerDetailsModel.firstName.isNotEmpty && passengerDetailsModel.lastName.isNotEmpty && passengerDetailsModel.dateOfBirth.isNotEmpty ? true : false,
                          child: Text(
                            'DOB: ${passengerDetailsModel.dateOfBirth}',
                            style: TextHelper.size12.copyWith(
                              fontFamily: mediumNunitoFont,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Down arrow icon
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: ColorsForApp.grayScale500,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return height(1.h);
        },
      ),
    );
  }

  // Gst details widget
  Widget gstDetailsWidget() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ColorsForApp.grayScale500.withOpacity(0.5),
          ),
        ),
        child: Form(
          key: addGstFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              height(1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => Checkbox(
                      value: flightController.isGstCheckBoxSelected.value,
                      activeColor: ColorsForApp.primaryColor,
                      onChanged: (value) {
                        flightController.isGstCheckBoxSelected.value = value!;
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    ),
                  ),
                  width(2.w),
                  Text(
                    'Enter GST details to claim tax benefits',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldNunitoFont,
                    ),
                  ),
                ],
              ),
              height(1.h),
              // GST text fields
              Visibility(
                visible: flightController.isGstCheckBoxSelected.value,
                child: Column(
                  children: [
                    height(1.h),
                    // GST number
                    CustomTextFieldWithTitle(
                      controller: flightController.gstNumberTextController,
                      title: 'GST Number',
                      hintText: 'Enter GST number',
                      isCompulsory: true,
                      maxLength: 15,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                      ],
                      validator: (value) {
                        final RegExp regExp = RegExp(r'\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}Z[A-Z\d]{1}');
                        if (flightController.gstNumberTextController.text.trim().isEmpty) {
                          return 'Please enter GST number';
                        } else if (!regExp.hasMatch(flightController.gstNumberTextController.text)) {
                          return 'Please enter valid GST number';
                        }
                        return null;
                      },
                    ),
                    // Gst email
                    CustomTextFieldWithTitle(
                      controller: flightController.gstEmailTextController,
                      title: 'Company\'s GST Email',
                      hintText: 'Enter email',
                      isCompulsory: true,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (flightController.gstEmailTextController.text.trim().isEmpty) {
                          return 'Please enter email';
                        } else if (!GetUtils.isEmail(flightController.gstEmailTextController.text.trim())) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    // Company name
                    CustomTextFieldWithTitle(
                      controller: flightController.companyNameTextController,
                      title: 'Company Name',
                      hintText: 'Enter company name',
                      isCompulsory: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.words,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      validator: (value) {
                        if (flightController.companyNameTextController.text.trim().isEmpty) {
                          return 'Please enter company name';
                        } else if (!GetUtils.isAlphabetOnly(flightController.companyNameTextController.text.trim())) {
                          return 'Please enter valid company name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add update passenger bottomsheet
  Future addUpdatePassengerBottomSheet(int index, PassengerDetailsModel passenger) {
    flightController.selectedNameTitleRadio.value = passenger.title;
    flightController.passengerFirstNameController.text = passenger.firstName;
    flightController.passengerLastNameController.text = passenger.lastName;
    flightController.passengerDobController.text = passenger.dateOfBirth;
    flightController.selectedGenderRadio.value = passenger.gender;
    flightController.passengerPasswordNoController.text = passenger.passportNumber ?? '';
    flightController.passengerPasswordExpiryDateController.text = passenger.passportExpiryDate ?? '';
    return customBottomSheet(
      enableDrag: false,
      isDismissible: true,
      preventToClose: true,
      isScrollControlled: true,
      children: [
        Text(
          passenger.type,
          style: TextHelper.size20.copyWith(
            fontFamily: extraBoldNunitoFont,
            color: ColorsForApp.blackColor,
          ),
        ),
        height(1.h),
        Form(
          key: addPassengerFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Obx(
                () => // Mr. | Ms. | Mstr. for adult | child | infant
                    Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Mr.for adult/child/infant
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Radio
                        Radio(
                          value: 'Mr',
                          groupValue: flightController.selectedNameTitleRadio.value,
                          onChanged: (value) {
                            flightController.selectedNameTitleRadio.value = value!;
                          },
                          activeColor: ColorsForApp.primaryColor,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        // Mr. text
                        GestureDetector(
                          onTap: () {
                            flightController.selectedNameTitleRadio.value = 'Mr';
                          },
                          child: Text(
                            'Mr.',
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
                              color: flightController.selectedNameTitleRadio.value == 'Mr' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                              fontWeight: flightController.selectedNameTitleRadio.value == 'Mr' ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                        width(4.w),
                      ],
                    ),
                    // Mrs.for adult/child
                    passenger.type.contains('Adult')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Radio
                              Radio(
                                value: 'Mrs',
                                groupValue: flightController.selectedNameTitleRadio.value,
                                onChanged: (value) {
                                  flightController.selectedNameTitleRadio.value = value!;
                                },
                                activeColor: ColorsForApp.primaryColor,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              ),
                              // Mrs. text
                              GestureDetector(
                                onTap: () {
                                  flightController.selectedNameTitleRadio.value = 'Mrs';
                                },
                                child: Text(
                                  'Mrs.',
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: boldNunitoFont,
                                    color: flightController.selectedNameTitleRadio.value == 'Mrs' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                                    fontWeight: flightController.selectedNameTitleRadio.value == 'Mrs' ? FontWeight.w500 : FontWeight.w400,
                                  ),
                                ),
                              ),
                              width(4.w),
                            ],
                          )
                        : const SizedBox.shrink(),
                    // Ms. for adult|child|infant
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Radio
                        Radio(
                          value: 'Ms',
                          groupValue: flightController.selectedNameTitleRadio.value,
                          onChanged: (value) {
                            flightController.selectedNameTitleRadio.value = value!;
                          },
                          activeColor: ColorsForApp.primaryColor,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        // Ms. text
                        GestureDetector(
                          onTap: () {
                            flightController.selectedNameTitleRadio.value = 'Ms';
                          },
                          child: Text(
                            'Ms.',
                            style: TextHelper.size14.copyWith(
                              fontFamily: boldNunitoFont,
                              color: flightController.selectedNameTitleRadio.value == 'Ms' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                              fontWeight: flightController.selectedNameTitleRadio.value == 'Ms' ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                        width(4.w),
                      ],
                    ),
                    // Mstr  for infant
                    passenger.type.contains('Infant')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Radio
                              Radio(
                                value: 'Mstr',
                                groupValue: flightController.selectedNameTitleRadio.value,
                                onChanged: (value) {
                                  flightController.selectedNameTitleRadio.value = value!;
                                },
                                activeColor: ColorsForApp.primaryColor,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              ),
                              // Mr. text
                              GestureDetector(
                                onTap: () {
                                  flightController.selectedNameTitleRadio.value = 'Mstr';
                                },
                                child: Text(
                                  'Mstr.',
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: boldNunitoFont,
                                    color: flightController.selectedNameTitleRadio.value == 'Mstr' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                                    fontWeight: flightController.selectedNameTitleRadio.value == 'Mstr' ? FontWeight.w500 : FontWeight.w400,
                                  ),
                                ),
                              ),
                              width(4.w),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              height(1.h),
              // First Name
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextFieldWithTitle(
                      controller: flightController.passengerFirstNameController,
                      title: 'First Name',
                      hintText: 'Enter first name',
                      isCompulsory: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      suffixIcon: Icon(
                        Icons.account_circle_rounded,
                        size: 18,
                        color: ColorsForApp.secondaryColor.withOpacity(0.5),
                      ),
                      validator: (value) {
                        if (flightController.passengerFirstNameController.text.trim().isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  width(3.w),
                  // Last Name
                  Expanded(
                    child: CustomTextFieldWithTitle(
                      controller: flightController.passengerLastNameController,
                      title: 'Last Name',
                      hintText: 'Enter last name',
                      isCompulsory: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.words,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      validator: (value) {
                        if (flightController.passengerLastNameController.text.trim().isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                      suffixIcon: Icon(
                        Icons.account_circle_rounded,
                        size: 18,
                        color: ColorsForApp.secondaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
              // DOB
              CustomTextFieldWithTitle(
                controller: flightController.passengerDobController,
                title: 'Date Of Birth',
                hintText: 'Select date of birth',
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                readOnly: true,
                onTap: () async {
                  DateTime departureDate = DateTime.now();
                  DateTime initialDate = DateTime.now();
                  DateTime firstDate = DateTime.now();
                  DateTime lastDate = DateTime.now();
                  if (passenger.type.contains('Infant')) {
                    departureDate = DateFormat(flightDateFormat).parse(flightController.departureDate.value);
                    initialDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
                    firstDate = DateTime(departureDate.year - 2, departureDate.month, departureDate.day);
                    lastDate = DateTime(departureDate.year, departureDate.month, departureDate.day - 1);
                  } else if (passenger.type.contains('Child')) {
                    departureDate = DateFormat(flightDateFormat).parse(flightController.departureDate.value);
                    initialDate = DateTime(DateTime.now().year - 2, DateTime.now().month, DateTime.now().day - 1);
                    firstDate = DateTime(departureDate.year - 12, departureDate.month, departureDate.day);
                    lastDate = DateTime(departureDate.year - 2, departureDate.month, departureDate.day - 1);
                  } else if (passenger.type.contains('Adult')) {
                    departureDate = DateFormat(flightDateFormat).parse(flightController.departureDate.value);
                    initialDate = DateTime(DateTime.now().year - 12, DateTime.now().month, DateTime.now().day - 1);
                    firstDate = DateTime(departureDate.year - 150, departureDate.month, departureDate.day);
                    lastDate = DateTime(departureDate.year - 12, departureDate.month, departureDate.day - 1);
                  }
                  await customDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    controller: flightController.passengerDobController,
                    dateFormat: flightDateFormat,
                  );
                },
                suffixIcon: Icon(
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                validator: (value) {
                  if (flightController.passengerDobController.text.trim().isEmpty) {
                    return 'Please select date of birth';
                  }
                  return null;
                },
              ),
              // Gender
              Text(
                'Gender',
                style: TextHelper.size14.copyWith(
                  fontFamily: regularNunitoFont,
                ),
              ),
              // Gender
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value: 'Male',
                      groupValue: flightController.selectedGenderRadio.value,
                      onChanged: (value) {
                        flightController.selectedGenderRadio.value = value!;
                      },
                      activeColor: ColorsForApp.primaryColor,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    ),
                    width(5),
                    Text(
                      'Male',
                      style: TextHelper.size14.copyWith(
                        fontFamily: regularNunitoFont,
                        color: flightController.selectedGenderRadio.value == 'Male' ? ColorsForApp.primaryColor : ColorsForApp.grayScale500,
                        fontWeight: flightController.selectedGenderRadio.value == 'Male' ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    width(15),
                    Radio(
                      value: 'Female',
                      groupValue: flightController.selectedGenderRadio.value,
                      onChanged: (value) {
                        flightController.selectedGenderRadio.value = value!;
                      },
                      activeColor: ColorsForApp.primaryColor,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    ),
                    width(5),
                    Text(
                      'Female',
                      style: TextHelper.size14.copyWith(
                        fontFamily: regularNunitoFont,
                        color: flightController.selectedGenderRadio.value == 'Female' ? ColorsForApp.primaryColor : ColorsForApp.grayScale500,
                        fontWeight: flightController.selectedGenderRadio.value == 'Female' ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    width(5),
                    Radio(
                      value: 'Other',
                      groupValue: flightController.selectedGenderRadio.value,
                      onChanged: (value) {
                        flightController.selectedGenderRadio.value = value!;
                      },
                      activeColor: ColorsForApp.primaryColor,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    ),
                    width(5),
                    Text(
                      'Other',
                      style: TextHelper.size14.copyWith(
                        fontFamily: regularNunitoFont,
                        color: flightController.selectedGenderRadio.value == 'Other' ? ColorsForApp.primaryColor : ColorsForApp.grayScale500,
                        fontWeight: flightController.selectedGenderRadio.value == 'Other' ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              height(1.h),
              // Passport NO ,expiry date
              Visibility(
                visible: (flightController.flightFareQuoteData.value.isPassportRequiredAtBook != null && flightController.flightFareQuoteData.value.isPassportRequiredAtTicket != null) &&
                            flightController.flightFareQuoteData.value.isPassportRequiredAtBook == true ||
                        flightController.flightFareQuoteData.value.isPassportRequiredAtTicket == true
                    ? true
                    : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Passport No
                    Expanded(
                      child: CustomTextFieldWithTitle(
                        controller: flightController.passengerPasswordNoController,
                        title: 'Passport Number',
                        hintText: 'Enter passport number',
                        isCompulsory: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                        ],
                        validator: (value) {
                          final RegExp regExp = RegExp(r'^[A-Z0-9]{6,9}$');
                          if (flightController.passengerPasswordNoController.text.trim().isEmpty) {
                            return 'Please enter passport number';
                          } else if (!regExp.hasMatch(flightController.passengerPasswordNoController.text)) {
                            return 'Please enter valid passport number';
                          }
                          return null;
                        },
                        suffixIcon: Icon(
                          Icons.account_circle_rounded,
                          size: 18,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                    width(3.w),
                    //Passport Expiry
                    Expanded(
                      child: CustomTextFieldWithTitle(
                        controller: flightController.passengerPasswordExpiryDateController,
                        title: 'Passport Expiry Date',
                        hintText: 'Select passport expiry date',
                        isCompulsory: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        readOnly: true,
                        onTap: () async {
                          DateTime departureDate = DateTime.now();
                          if (flightController.searchedTripType.value == TripType.ONEWAY_DOM || flightController.searchedTripType.value == TripType.ONEWAY_INT) {
                            departureDate = DateFormat(flightDateFormat).parse(flightController.departureDate.value);
                          } else if (flightController.searchedTripType.value == TripType.RETURN_DOM || flightController.searchedTripType.value == TripType.RETURN_INT) {
                            departureDate = DateFormat(flightDateFormat).parse(flightController.returnDate.value);
                          } else if (flightController.searchedTripType.value == TripType.MULTICITY_DOM || flightController.searchedTripType.value == TripType.MULTICITY_INT) {
                            departureDate = DateFormat(flightDateFormat).parse(flightController.multiStopLocationList.last.date!.value);
                          }
                          DateTime initialDate = DateTime(departureDate.year, departureDate.month, departureDate.day + 1);
                          DateTime firstDate = DateTime(departureDate.year, departureDate.month, departureDate.day + 1);
                          DateTime lastDate = DateTime(departureDate.year + 20, departureDate.month, departureDate.day);
                          await customDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: firstDate,
                            lastDate: lastDate,
                            controller: flightController.passengerPasswordExpiryDateController,
                            dateFormat: flightDateFormat,
                          );
                        },
                        suffixIcon: Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                        validator: (value) {
                          if (flightController.passengerPasswordExpiryDateController.text.trim().isEmpty) {
                            return 'Please Select passport expiry date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
      // Add | Update button
      customButtons: CommonButton(
        onPressed: () async {
          if (Get.isSnackbarOpen) {
            Get.back();
          }
          if (addPassengerFormKey.currentState!.validate()) {
            // Check if firstName already exists in passengerListForExtraServices then update same as it is
            if (passenger.firstName.toLowerCase() == flightController.passengerFirstNameController.text.trim().toLowerCase()) {
              passenger.title = flightController.selectedNameTitleRadio.value;
              passenger.firstName = flightController.passengerFirstNameController.text.trim();
              passenger.lastName = flightController.passengerLastNameController.text.trim();
              passenger.dateOfBirth = flightController.passengerDobController.text.trim();
              passenger.passportNumber = flightController.passengerPasswordNoController.text.trim();
              passenger.passportExpiryDate = flightController.passengerPasswordExpiryDateController.text.trim();
              passenger.gender = flightController.selectedGenderRadio.value;
              passenger.type = passenger.type;
              passenger.isFilled = true;
              Get.back();
              flightController.passengerListForExtraServices.refresh();
            } else {
              // If first name is diifenrent then check duplicate case
              bool isDuplicate = false;
              if (flightController.passengerListForExtraServices.isNotEmpty) {
                isDuplicate = flightController.passengerListForExtraServices.any((passenger) =>
                    passenger.firstName.toLowerCase() == flightController.passengerFirstNameController.text.trim().toLowerCase() &&
                    (passenger.lastName.toLowerCase() == flightController.passengerLastNameController.text.trim().toLowerCase() ||
                        passenger.dateOfBirth.toLowerCase() == flightController.passengerDobController.text.trim().toLowerCase()));
              }
              if (isDuplicate) {
                // Show error message
                pendingSnackBar(title: 'Info', message: 'Uh oh! Airline prohibits travelers with the same name in a single booking. Please enter different names.');
              } else {
                // First Name must be unique
                passenger.title = flightController.selectedNameTitleRadio.value;
                passenger.firstName = flightController.passengerFirstNameController.text.trim();
                passenger.lastName = flightController.passengerLastNameController.text.trim();
                passenger.dateOfBirth = flightController.passengerDobController.text.trim();
                passenger.passportNumber = flightController.passengerPasswordNoController.text.trim();
                passenger.passportExpiryDate = flightController.passengerPasswordExpiryDateController.text.trim();
                passenger.gender = flightController.selectedGenderRadio.value;
                passenger.type = passenger.type;
                passenger.isFilled = true;
                Get.back();
                flightController.passengerListForExtraServices.refresh();
              }
            }
          }
        },
        label: passenger.firstName.isEmpty && passenger.lastName.isEmpty && passenger.dateOfBirth.isEmpty ? 'Add' : 'Update',
      ),
    );
  }
}
