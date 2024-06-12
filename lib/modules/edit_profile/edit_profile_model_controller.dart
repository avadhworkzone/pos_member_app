import 'package:flutter/material.dart';
import 'package:member_app/common/alert/alert_action.dart';
import 'package:member_app/common/alert/app_alert.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/message_constants.dart';
import 'package:member_app/common/utils/network_utils.dart';
import 'package:member_app/common/widget/gender_popup.dart';
import 'package:member_app/common/widget/race_popup.dart';
import 'package:member_app/common/widget/titles_popup.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/bloc/get_genders_bloc.dart';
import 'package:member_app/data/all_bloc/get_genders_bloc/bloc/get_genders_state.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/bloc/get_races_bloc.dart';
import 'package:member_app/data/all_bloc/get_races_bloc/bloc/get_races_state.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/bloc/get_titles_bloc.dart';
import 'package:member_app/data/all_bloc/get_titles_bloc/bloc/get_titles_state.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_bloc.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_event.dart';
import 'package:member_app/data/all_bloc/profile_delete_bloc/bloc/profile_delete_state.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_bloc.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/bloc/profile_update_event.dart';
import 'package:member_app/data/all_bloc/profile_update_bloc/repo/profile_update_request.dart';
import 'package:member_app/data/local/shared_prefs/shared_prefs.dart';
import 'package:member_app/modules/home/my_profile/view/my_profile_model.dart';
import 'package:member_app/routes/route_constants.dart';

class EditProfileModelController {
  final BuildContext context;
  final MyProfileModel mMyProfileModel;

  EditProfileModelController(this.context, this.mMyProfileModel);

  final TextEditingController firstNameController = TextEditingController();

  // final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController racesController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressOneController = TextEditingController();
  final TextEditingController addressTwoController = TextEditingController();
  final TextEditingController titlesController = TextEditingController();

  GlobalKey keyRaces = GlobalKey();
  GlobalKey keyGender = GlobalKey();
  GlobalKey keyTitles = GlobalKey();

  /// setValue
  setValue() {
    firstNameController.text = mMyProfileModel.sFirstName;
    dobController.text = mMyProfileModel.sDob;
    emailController.text = mMyProfileModel.sEmail;
    phoneNumberController.text = mMyProfileModel.sPhone;
    racesController.text = mMyProfileModel.sRacesName;
    genderController.text = mMyProfileModel.sGenderName;
    cityController.text = mMyProfileModel.sCity;
    postalCodeController.text = mMyProfileModel.sAreaCode;
    addressOneController.text = mMyProfileModel.sAddress1;
    addressTwoController.text = mMyProfileModel.sAddress2;
    titlesController.text = mMyProfileModel.sTitlesName;
  }

  ///checkValue
  checkValue() {
    String sMessage = "";
    if (firstNameController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseEnterTheFirstName;
    } else if (emailController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseEnterTheEmailId;
    } else if (racesController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseSelectRaces;
    } else if (genderController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseSelectGender;
    } else if (dobController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseSelectDob;
    } else if (cityController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseEnterTheCity;
    } else if (postalCodeController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseEnterThePostalCode;
    } else if (addressOneController.text.isEmpty) {
      sMessage = AppConstants.mWordConstants.sPleaseEnterTheAddress;
    }
    if (sMessage.isNotEmpty) {
      AppAlert.showSnackBar(context, sMessage);
      return false;
    } else {
      return true;
    }
  }

  ///delete profile
  late ProfileDeleteBloc _mProfileDeleteBloc;

  setProfileDeleteBloc() {
    _mProfileDeleteBloc = ProfileDeleteBloc();
  }

  getProfileDeleteBloc() {
    return _mProfileDeleteBloc;
  }

  deleteProfile() {
    AppAlert.showCustomDialogNoYes(
      context,
      MessageConstants.wProfileDelete,
      MessageConstants.wProfileDeleteMessage,
      buttonOneText: MessageConstants.wCancel,
      buttonTwoText: MessageConstants.wConfirm,
    ).then((value) async {
      if (value == AlertAction.yes) {
        initProfileDelete();
      }
    });
  }

  Future<void> initProfileDelete() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mProfileDeleteBloc
            .add(const ProfileDeleteClickEvent(mProfileDeleteListRequest: ""));
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  blocProfileDeleteListener(
      BuildContext context, ProfileDeleteState state) async {
    switch (state.status) {
      case ProfileDeleteStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case ProfileDeleteStatus.failed:
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
      case ProfileDeleteStatus.success:
        AppAlert.closeDialog(context);
        AppAlert.showSnackBar(
          context,
          state.mProfileDeleteResponse!.message ?? "",
        );

        if (state.mProfileDeleteResponse!.status ?? false) {
          await SharedPrefs().setUserToken("");
          await SharedPrefs().clearSharedPreferences();
          Navigator.pushNamedAndRemoveUntil(
              context, RouteConstants.rWelcomeScreenWidget, (route) => false);
        }
        break;
    }
  }

  ///GetGenders
  late GetGendersBloc _mGetGendersBloc;

  setGendersBloc() {
    _mGetGendersBloc = GetGendersBloc();
  }

  getGendersBloc() {
    return _mGetGendersBloc;
  }

  blocGendersListener(BuildContext context, GetGendersState state) async {
    switch (state.status) {
      case GetGendersStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetGendersStatus.failed:
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
      case GetGendersStatus.success:
        AppAlert.closeDialog(context);
        mGetGendersResponse = state.mGetGendersResponse!;
        if (mGetGendersResponse.genders!.isNotEmpty) {
          mMyProfileModel.sGenderId =
              await showPopupGendersItem(genderController, keyGender, context);
        }
        break;
    }
  }

  ///GetGenders
  late GetRacesBloc _mGetRacesBloc;

  setRacesBloc() {
    _mGetRacesBloc = GetRacesBloc();
  }

  getRacesBloc() {
    return _mGetRacesBloc;
  }

  blocGetRacesListener(BuildContext context, GetRacesState state) async {
    switch (state.status) {
      case GetRacesStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetRacesStatus.failed:
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
      case GetRacesStatus.success:
        AppAlert.closeDialog(context);
        mGetRacesResponse = state.mGetRacesResponse!;
        if (mGetRacesResponse.races!.isNotEmpty) {
          mMyProfileModel.sRacesId =
              await showPopupRacesItem(racesController, keyRaces, context);
        }
        break;
    }
  }

  ///GetGenders
  late GetTitlesBloc _mGetTitlesBloc;

  setTitlesBloc() {
    _mGetTitlesBloc = GetTitlesBloc();
  }

  getTitlesBloc() {
    return _mGetTitlesBloc;
  }

  blocGetTitlesListener(BuildContext context, GetTitlesState state) async {
    switch (state.status) {
      case GetTitlesStatus.loading:
        AppAlert.showProgressDialog(context);
        break;
      case GetTitlesStatus.failed:
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
      case GetTitlesStatus.success:
        AppAlert.closeDialog(context);
        mGetTitlesResponse = state.mGetTitlesResponse!;
        if (mGetTitlesResponse.titles!.isNotEmpty) {
          mMyProfileModel.sTitlesId =
              await showPopupTitlesItem(titlesController, keyTitles, context);
        }
        break;
    }
  }

  ///ProfileUpdateBloc
  late ProfileUpdateBloc _mProfileUpdateBloc;

  setProfileUpdateBloc() {
    _mProfileUpdateBloc = ProfileUpdateBloc();
  }

  getProfileUpdateBloc() {
    return _mProfileUpdateBloc;
  }

  Future<void> saveProfile() async {
    await NetworkUtils()
        .checkInternetConnection()
        .then((isInternetAvailable) async {
      if (isInternetAvailable) {
        if (checkValue()) {
          ProfileUpdateRequest mProfileUpdateRequest = ProfileUpdateRequest(
            firstName: firstNameController.text,
            lastName: "",
            email: emailController.text,
            raceId: mMyProfileModel.sRacesId,
            genderId: mMyProfileModel.sGenderId,
            titleId: mMyProfileModel.sTitlesId,
            dateOfBirth: dobController.text,
            city: cityController.text,
            areaCode: postalCodeController.text,
            addressLine1: addressOneController.text,
            addressLine2: addressTwoController.text,
          );

          _initProfileUpdate(mProfileUpdateRequest);
        }
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }

  Future<void> _initProfileUpdate(
      ProfileUpdateRequest mProfileUpdateRequest) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _mProfileUpdateBloc.add(ProfileUpdateClickEvent(
            mProfileUpdateListRequest: mProfileUpdateRequest));
      } else {
        AppAlert.showSnackBar(context, MessageConstants.noInternetConnection);
      }
    });
  }
}