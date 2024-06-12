import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/appbars_constants.dart';
import 'package:member_app/common/button_constants.dart';
import 'package:member_app/common/call_back.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/common/widget/edit_text_field.dart';
import 'package:member_app/common/widget/gender_popup.dart';
import 'package:member_app/common/widget/race_popup.dart';
import 'package:member_app/common/widget/titles_popup.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/bloc/get_genders_bloc.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/bloc/get_genders_state.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_bloc.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_event.dart';
import 'package:member_app/data/all_bloc/get_members_details_bloc/bloc/get_members_details_state.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/bloc/get_races_bloc.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/bloc/get_races_state.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/bloc/get_titles_bloc.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/bloc/get_titles_state.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_bloc.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_state.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_bloc.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_state.dart';
import 'package:member_app/modules/edit_profile/edit_profile_model_controller.dart';
import '../../../common/text_styles_constants.dart';

class EditProfileScreenWidget extends StatefulWidget {
  final CallbackModel mCallbackModel;

  const EditProfileScreenWidget({super.key, required this.mCallbackModel});

  @override
  State<EditProfileScreenWidget> createState() =>
      _EditProfileScreenWidgetState();
}

class _EditProfileScreenWidgetState extends State<EditProfileScreenWidget> {
  late GetMemberDetailsBloc _mGetMemberDetailsBloc;

  DateTime selectedDate = DateTime(2014, 12, 30);
  late EditProfileModelController mEditProfileModelController;

  String imageFile = "";

  @override
  void initState() {
    mEditProfileModelController =
        EditProfileModelController(context, widget.mCallbackModel.sValue);
    mEditProfileModelController.setValue();
    mEditProfileModelController.setProfileDeleteBloc();
    mEditProfileModelController.setGendersBloc();
    mEditProfileModelController.setRacesBloc();
    mEditProfileModelController.setTitlesBloc();
    mEditProfileModelController.setProfileUpdateBloc();
    super.initState();
    _mGetMemberDetailsBloc = GetMemberDetailsBloc();
  }

  Future<void> _initGetMemberDetails() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mGetMemberDetailsBloc.add(const GetMemberDetailsClickEvent());
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars.appBar(
                (value) {}, AppConstants.mWordConstants.sEditProfile),
        body: MultiBlocListener(
          child: _buildEditProfileScreenWidgetView(),
          listeners: [
            BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
                bloc: mEditProfileModelController.getProfileUpdateBloc(),
                listener: (context, state) {
                  _fProfileUpdateBlocListener(context, state);
                }),
            BlocListener<GetMemberDetailsBloc, GetMemberDetailsState>(
                bloc: _mGetMemberDetailsBloc,
                listener: (context, state) {
                  _fGetMemberDetailsBlocListener(context, state);
                }),
            BlocListener<GetGendersBloc, GetGendersState>(
                bloc: mEditProfileModelController.getGendersBloc(),
                listener: (context, state) {
                  mEditProfileModelController.blocGendersListener(
                      context, state);
                }),
            BlocListener<GetRacesBloc, GetRacesState>(
                bloc: mEditProfileModelController.getRacesBloc(),
                listener: (context, state) {
                  mEditProfileModelController.blocGetRacesListener(
                      context, state);
                }),
            BlocListener<GetTitlesBloc, GetTitlesState>(
                bloc: mEditProfileModelController.getTitlesBloc(),
                listener: (context, state) {
                  mEditProfileModelController.blocGetTitlesListener(
                      context, state);
                }),
            BlocListener<ProfileDeleteBloc, ProfileDeleteState>(
                bloc: mEditProfileModelController.getProfileDeleteBloc(),
                listener: (context, state) {
                  mEditProfileModelController.blocProfileDeleteListener(
                      context, state);
                }),
          ],
        ));
  }

  _fProfileUpdateBlocListener(BuildContext context, ProfileUpdateState state) {
    switch (state.status) {
      case ProfileUpdateStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case ProfileUpdateStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case ProfileUpdateStatus.success:
        AppAlert.closeDialog(context);
        if (state.mProfileUpdateResponse!.status!) {
          AppAlert.showSuccess(
            context,
            state.mProfileUpdateResponse!.message.toString(),
          ).then((value) async {
            _initGetMemberDetails();
          });
        } else {
          AppAlert.showError(
            context,
            state.mProfileUpdateResponse!.message.toString(),
          );
        }
        break;
    }
  }

  _fGetMemberDetailsBlocListener(
      BuildContext context, GetMemberDetailsState state) {
    switch (state.status) {
      case GetMemberDetailsStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetMemberDetailsStatus.failed:
        AppAlert.closeDialog(context);
        if (state.webResponseFailed != null) {
          AppAlert.showSnackBar(
              context, state.webResponseFailed!.statusMessage ?? "");
        } else {
          AppAlert.showSnackBar(
            context,
            MessageConstants.wSomethingWentWrong,
          );
        }
        break;
      case GetMemberDetailsStatus.success:
        AppAlert.closeDialog(context);
        break;
    }
  }

  _buildEditProfileScreenWidgetView() {
    return FocusDetector(
        onForegroundGained: () {},
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: SizeConstants.s_30,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: SizeConstants.width * 0.26,
                      width: SizeConstants.width * 0.26,
                      padding: EdgeInsets.all(SizeConstants.s_10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: ColorConstants.kPrimaryColor.shade600)),
                      child: ClipOval(
                          child: Image.asset(
                            ImageAssets.imageAppBarLogo,
                          )),
                    )),
              ),
              SizedBox(
                height: SizeConstants.s_30,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset:
                        const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConstants.s1 * 20),
                      topRight: Radius.circular(SizeConstants.s1 * 20),
                    ),
                  ),
                  child: Scrollbar(
                      thumbVisibility: true,
                      thickness: SizeConstants.s2,
                      //width of scrollbar
                      radius: const Radius.circular(20),
                      //corner radius of scrollbar
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(SizeConstants.s_15),
                          child: Column(
                            children: [
                              SizedBox(
                                height: SizeConstants.s_8,
                              ),

                              ///titles
                              editTextFiledGlobalKeyClickView(
                                  mEditProfileModelController.titlesController,
                                  mEditProfileModelController.keyTitles,
                                      (value) async {
                                    await fetchGetTitlesList(
                                        context,
                                        mEditProfileModelController
                                            .getTitlesBloc());
                                  },
                                  labelText: AppConstants.mWordConstants.sTitle,
                                  mandatoryField: true,
                                  hintText:
                                  AppConstants.mWordConstants.sSelectTitles,
                                  mIcons: Icons.arrow_drop_down_sharp,
                                  readOnly: true,
                                  suffixIcon: true),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///First Name

                              editTextFiled(
                                mEditProfileModelController.firstNameController,
                                labelText:
                                AppConstants.mWordConstants.sFullName, mandatoryField: true,
                                hintText: AppConstants
                                    .mWordConstants.sEnterYourFirstName,
                                mIcons: Icons.person_outline,
                              ),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///select Races and select gender
                              Row(
                                children: [
                                  Expanded(
                                    child: editTextFiledGlobalKeyClickView(
                                        mEditProfileModelController
                                            .racesController,
                                        mEditProfileModelController.keyRaces, mandatoryField: true,
                                            (value) async {
                                          await fetchGetRacesList(
                                              context,
                                              mEditProfileModelController
                                                  .getRacesBloc());
                                        },
                                        labelText:
                                        AppConstants.mWordConstants.sRaces,
                                        hintText:
                                        AppConstants.mWordConstants.sRaces,
                                        mIcons: Icons.arrow_drop_down_sharp,
                                        readOnly: true,
                                        suffixIcon: true),
                                  ),
                                  SizedBox(
                                    width: SizeConstants.s_10,
                                  ),
                                  Expanded(
                                    child: editTextFiledGlobalKeyClickView(
                                        mEditProfileModelController
                                            .genderController,
                                        mEditProfileModelController.keyGender,
                                            (value) async {
                                          await fetchGetGendersList(
                                              context,
                                              mEditProfileModelController
                                                  .getGendersBloc());
                                        },
                                        labelText:
                                        AppConstants.mWordConstants.sGender, mandatoryField: true,
                                        hintText:
                                        AppConstants.mWordConstants.sGender,
                                        mIcons: Icons.arrow_drop_down_sharp,
                                        readOnly: true,
                                        suffixIcon: true),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///Email id
                              editTextFiled(
                                mEditProfileModelController.emailController,
                                labelText: AppConstants.mWordConstants.sEmail,
                                hintText:
                                AppConstants.mWordConstants.sEnterYourEmail,
                                mIcons: Icons.email_outlined, mandatoryField: true,
                              ),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///select dob
                              IgnorePointer(
                                ignoring: true,
                                child: editTextFiledClickView(
                                    mEditProfileModelController.dobController,
                                        (value) async {
                                      _selectDate(context);
                                    },
                                    labelText:
                                    AppConstants.mWordConstants.sDdMmYYYY, mandatoryField: true,
                                    hintText:
                                    AppConstants.mWordConstants.sDdMmYYYY,
                                    mIcons: Icons.arrow_drop_down_sharp,
                                    readOnly: true,
                                    suffixIcon: true),
                              ),

                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///non edit phoneNumber

                              editTextFiled(
                                  mEditProfileModelController
                                      .phoneNumberController,
                                  labelText:
                                  AppConstants.mWordConstants.sPhoneNumber,
                                  hintText: AppConstants
                                      .mWordConstants.sEnterPhoneNumber, mandatoryField: true,
                                  mIcons: Icons.phone,
                                  readOnly: true),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///city and Postal Code
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: editTextFiled(
                                      mEditProfileModelController
                                          .cityController, mandatoryField: true,
                                      labelText:
                                      AppConstants.mWordConstants.sCity,
                                      hintText:
                                      AppConstants.mWordConstants.sCity,
                                      mIcons: Icons.location_city_outlined,
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConstants.s_10,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: editTextFiled(
                                      mEditProfileModelController
                                          .postalCodeController, mandatoryField: true,
                                      labelText: AppConstants
                                          .mWordConstants.sPostalCode,
                                      hintText: AppConstants
                                          .mWordConstants.sPostalCode,
                                      mIcons: Icons.location_history,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///address1

                              editTextFiled(mEditProfileModelController.addressOneController,
                                  labelText:
                                  AppConstants.mWordConstants.sAddress1,
                                  hintText: AppConstants
                                      .mWordConstants.sEnterYourAddress, mandatoryField: true,
                                  mIcons: Icons.location_on_rounded,
                                  maxLines: 3),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///address2
                              editTextFiled(mEditProfileModelController.addressTwoController,
                                  labelText:
                                  AppConstants.mWordConstants.sAddress2,
                                  hintText: AppConstants
                                      .mWordConstants.sEnterYourAddress,
                                  mIcons: Icons.location_on_rounded,
                                  maxLines: 3),
                              SizedBox(
                                height: SizeConstants.s_30,
                              ),

                              ///SaveProfile button
                              SizedBox(
                                height: SizeConstants.width * 0.12,
                                width: SizeConstants.width / 2.5,
                                child: rectangleRoundedCornerButton(
                                    appbarActionInterface: (value) {
                                      mEditProfileModelController.saveProfile();
                                    },
                                    sButtonTitle:
                                    AppConstants.mWordConstants.sSave,
                                    cButtonBackGroundColor:
                                    ColorConstants.kPrimaryColor,
                                    cButtonTextColor: ColorConstants.cWhite,
                                    dButtonTextSize: SizeConstants.s_16,
                                    dButtonWidth: SizeConstants.width,
                                    cButtonBorderColor:
                                    ColorConstants.kPrimaryColor,
                                    dButtonRadius: SizeConstants.s_15),
                              ),
                              SizedBox(
                                height: SizeConstants.s_16,
                              ),

                              ///delete Profile button
                              GestureDetector(
                                onTap: () {
                                  mEditProfileModelController.deleteProfile();
                                },
                                child: Container(
                                    padding: EdgeInsets.only(
                                      bottom: SizeConstants.s3,
                                    ),
                                    child: Text(
                                        AppConstants
                                            .mWordConstants.sDeleteProfile,
                                        style: getTextRegular(
                                          size: SizeConstants.s1 * 14,
                                          colors: ColorConstants
                                              .kPrimaryColor.shade600,
                                        ))),
                              ),

                              SizedBox(
                                height: SizeConstants.s_16,
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2014, 12, 31),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        String dob =
            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
        mEditProfileModelController.dobController.text = dob;
      });
    }
  }
}