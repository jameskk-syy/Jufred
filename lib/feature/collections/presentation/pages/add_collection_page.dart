import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairy_app/core/utils/utils.dart';
import 'package:dairy_app/feature/collections/presentation/blocs/cubit/location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/add_collection_dto.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/domain/models/can_response_model.dart';
import '../../../farmers/domain/model/farmer_details_model.dart';
import '../blocs/add_collection_cubit.dart';
import '../blocs/cubit/can_cubit.dart';
import '../blocs/cubit/farmer_details_cubit.dart';

class AddCollectionPage extends StatelessWidget {
  // final FarmerDetailsModel farmerDetailsModel;

  AddCollectionPage({
    super.key,
    /*required this.farmerDetailsModel*/
  });

  TextEditingController quantityTextFieldController = TextEditingController();
  TextEditingController quantityTextFieldCan = TextEditingController();
  final FocusNode focusNodeQuantity = FocusNode();
  final FocusNode focusNodeCan = FocusNode();
  List<CanResponseEntityModel> cans = [];
  String? selectedCan;
  String? selectedCanId;
  final session = getSession();
  final sessionTextFieldController = TextEditingController(text: getSession());
  final farmerNumberTextFieldController = TextEditingController();
  double? latitude;
  double? longitude;
  final formKey = GlobalKey<FormState>();
  final farmerDetailFormKey = GlobalKey<FormState>();
  int? selectedRouteId;
  int? farmerId;
  bool boolIsFarmerNumberContainerVisible = true;
  late FarmerDetailsEntityModel farmerDetails;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CanCubit>()..getCanLists(),
        ),
        BlocProvider(
          create: (context) => sl<LocationCubit>()..getCurrentLocation(),
        ),
        BlocProvider(
          create: (context) => sl<AddCollectionCubit>(),
        ),
        BlocProvider<FarmerDetailsCubit>(
          create: (_) => sl<FarmerDetailsCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Record New Collection'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: boolIsFarmerNumberContainerVisible
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: MediaQuery.of(context).size.height,
                  child: Form(
                    key: farmerDetailFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: farmerNumberTextFieldController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Enter Farmer Number to Continue',
                            hintText: 'Farmer Number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter farmer number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocConsumer<FarmerDetailsCubit,
                            FarmerDetailsCubitState>(
                          listener: (context, state) {
                            if (state.uiState == UIState.error) {
                              Navigator.pop(context);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.scale,
                                title: 'Not Found',
                                desc:
                                    'The farmer number you entered does not exist',
                                btnOkOnPress: () {
                                  Navigator.pop(context);
                                },
                              ).show();
                            } else if (state.uiState == UIState.loading) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                            } else if (state.uiState == UIState.success) {
                              Navigator.pop(context);
                              farmerDetails = state.farmerDetailsModel!;
                              boolIsFarmerNumberContainerVisible =
                                  !boolIsFarmerNumberContainerVisible;
                            }
                          },
                          builder: (context, state) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.lightColorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightColorScheme.primary
                                        .withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (farmerDetailFormKey.currentState!
                                      .validate()) {
                                    dispatchGetFarmerDetails(context);
                                  }
                                },
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                      color:
                                          AppColors.lightColorScheme.onPrimary),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 220,
                        child: Stack(
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightColorScheme.primary
                                        .withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/farmer.png',
                                      width: 150,
                                      height: 95,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Farmer Name:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          farmerDetails.username ?? '',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Farmer No:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          farmerDetails.farmerNo.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Route:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          farmerDetails.route ?? '',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildContainer(context),
                      buildSubmitButton(context),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    return BlocConsumer<AddCollectionCubit, AddCollectionState>(
      listener: (context, state) {
        if (state.uiState == UIState.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        } else if (state.uiState == UIState.error) {
          //Show error message
          final log = Logger();

          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: 'Error',
            desc: state.exception ?? 'An error occurred. Please try again',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (state.uiState == UIState.success) {
          //Show success message
          Navigator.pop(context);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Success',
            desc: 'Collection recorded successfully',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
        }
      },
      builder: (context, state) {
        return BlocConsumer<LocationCubit, LocationState>(
          listener: (context, state) {
            //Check if location state is success
            if (state.position != null) {
              //Show success message
              latitude = state.position!.latitude;
              longitude = state.position!.longitude;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Your Location has been saved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state.errorMessage != null) {
              //Show error message
              final log = Logger();
              log.e(state.errorMessage);

              Fluttertoast.showToast(
                  msg: 'Device offline! Cannot get location',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          builder: (context, state) {
            return MaterialButton(
              minWidth: double.infinity,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.scale,
                    title: 'Confirmation',
                    body: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Are you sure you want to submit this collection?',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Farmer: ${farmerDetails.username}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Farmer No: ${farmerDetails.farmerNo}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Quantity: ${quantityTextFieldController.text}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Session: ${sessionTextFieldController.text}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    btnOk: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        DateTime now = DateTime.now();
                        String formattedDateTime =
                             DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'")
                                .format(now.toLocal());
                            // DateFormat("yyyy-MM-ddHH:mm:ss.SSS'EAT'")
                            //     .format(now.toLocal());
                        /*// Create a formatter for EAT timezone
                        DateFormat eatFormat = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_EAT');
                        // Format the date in the specified timezone and locale
                        String formattedDateTime = eatFormat.format(now);*/

                        final collection = AddCollectionDto(
                            farmerNumber: farmerDetails.farmerNo!,
                            //canNumber: selectedCanId!,
                            status: 'N',
                            updatedStatus: 'N',
                            paymentStatus: 'N',
                            collectorId: collectorId!,
                            quantity:
                                double.parse(quantityTextFieldController.text),
                            latitude: latitude.toString(),
                            longitude: longitude.toString(),
                            routeId: farmerDetails.routeId!,
                            session: sessionTextFieldController.text,
                            event: "Collection",
                            collectionDate: formattedDateTime);
                        BlocProvider.of<AddCollectionCubit>(context)
                            .addCollection(collection);
                      },
                      color: AppColors.lightColorScheme.primary,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: AppColors.lightColorScheme.onPrimary),
                      ),
                    ),
                    btnCancel: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: AppColors.lightColorScheme.error,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: AppColors.lightColorScheme.onError),
                      ),
                    ),
                  ).show();
                }
              },
              color: AppColors.lightColorScheme.primary,
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildContainer(BuildContext context) {
    return BlocConsumer<CanCubit, CanState>(
      listener: (context, state) {
        if (state.uiState == UIState.success) {
          final cansList = state.cansModel!.entity!;
          cans = cansList;
        } else if (state.uiState == UIState.error) {
          cans = [];
        }
      },
      builder: (context, state) {
        return Container(
          height: 280,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightColorScheme.primary.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            'Quantity(Ltrs)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            focusNode: focusNodeQuantity,
                            controller: quantityTextFieldController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14.0),
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                            textInputAction: TextInputAction.go,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter quantity';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            'Can No.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              onChanged: (can) {
                                selectedCan = can!;
                                  selectedCanId = selectedCan!.split(',').first;
                                  final log = Logger();
                                  log.i(selectedCanId);
                              },
                              items: cans
                                  .map((e) => DropdownMenuItem<String>(
                                        value: '${e.canNo}, ${e.canName!}',
                                        child:
                                            Text('${e.canNo}, ${e.canName!}'),
                                      ))
                                  .toList(),
                              value: selectedCan,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select can';
                                }
                                return null;
                              },
                            ),
                        ),
                      ],
                    ),
                  ),*/
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            'Session.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: sessionTextFieldController,
                            keyboardType: TextInputType.text,
                            enabled: false,
                            style: const TextStyle(fontSize: 14.0),
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintStyle: TextStyle(fontSize: 14.0),
                            ),
                            textInputAction: TextInputAction.go,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter session';
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
            ),
          ),
        );
      },
    );
  }

  void dispatchGetFarmerDetails(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    final farmerNumberString = farmerNumberTextFieldController.text.trim();
    final farmerNumber = int.parse(farmerNumberString);
    BlocProvider.of<FarmerDetailsCubit>(context)
        .getFarmerDetails(farmerNumber /*, farmerNumber*/);
  }
}
