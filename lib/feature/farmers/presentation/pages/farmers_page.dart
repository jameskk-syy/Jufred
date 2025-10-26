import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../blocs/farmers_cubit.dart';
import 'add_farmer_form.dart';

class FarmersPage extends StatelessWidget {
  const FarmersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmers"),
        /*actions: [
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'sort',
                child: Container(
                    width: 100,
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: const [
                        Icon(Icons.sort),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Sort')
                      ],
                    )),
                onTap: () {},
              ),
              PopupMenuItem(
                value: 'search',
                child: Container(
                    width: 100,
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: const [
                        Icon(Icons.search),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Search')
                      ],
                    )),
                onTap: () {},
              ),
            ];
          })
        ],*/
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddFarmerForm()));
          },
          child: const Icon(Icons.add)),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: _buildBody(context),
    );
  }

  BlocProvider<FarmersCubit> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FarmersCubit>(),
      child: BlocConsumer<FarmersCubit, FarmersState>(
        listener: (context, state) {
          if (state.uiState == UIState.error) {
            /*ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.exception!),
              ),
            );*/
            Fluttertoast.showToast(
                msg: 'An error occured',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        builder: (context, state) {
          if (state.uiState == UIState.initial) {
            final prefs = sl<SharedPreferences>();
            final userData = prefs.getString("userData");
            final user = LoginResponseDto.fromJson(jsonDecode(userData!));
            final collectorId = user.id;
            BlocProvider.of<FarmersCubit>(context).getFarmers(collectorId!);
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.uiState == UIState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.uiState == UIState.success) {
            if (state.farmersResponseModel!.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  final prefs = sl<SharedPreferences>();
                  final userData = prefs.getString("userData");
                  final user = LoginResponseDto.fromJson(jsonDecode(userData!));
                  final collectorId = user.id;
                  BlocProvider.of<FarmersCubit>(context)
                      .getFarmers(collectorId!);
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('You have no farmers in your routes'),
                      IconButton(
                          onPressed: () {
                            final prefs = sl<SharedPreferences>();
                            final userData = prefs.getString("userData");
                            final user = LoginResponseDto.fromJson(
                                jsonDecode(userData!));
                            final collectorId = user.id;
                            BlocProvider.of<FarmersCubit>(context)
                                .getFarmers(collectorId!);
                          },
                          icon: const Icon(Icons.refresh))
                    ],
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  final prefs = sl<SharedPreferences>();
                  final userData = prefs.getString("userData");
                  final user = LoginResponseDto.fromJson(jsonDecode(userData!));
                  final collectorId = user.id;
                  BlocProvider.of<FarmersCubit>(context)
                      .getFarmers(collectorId!);
                },
                child: ListView.builder(
                  itemCount: state.farmersResponseModel!.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightColorScheme.primary
                                  .withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/farmer.png",
                                  height: 100,
                                  width: 50,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_2_outlined,
                                        size: 15,
                                        color:
                                            AppColors.lightColorScheme.primary,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        state.farmersResponseModel![index]
                                            .username ?? '',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.numbers,
                                        size: 15,
                                        color: AppColors.lightColorScheme.primary,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'F/No. ${state.farmersResponseModel![index].farmerNo ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 15,
                                        color:
                                            AppColors.lightColorScheme.primary,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Phone. ${state.farmersResponseModel![index].mobileNo ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.insert_drive_file_outlined,
                                        size: 15,
                                        color:
                                            AppColors.lightColorScheme.primary,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'ID No. ${state.farmersResponseModel![index].idNumber ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ));
                  },
                ),
              );
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("An error occurred"),
                  IconButton(
                      onPressed: () {
                        final prefs = sl<SharedPreferences>();
                        final userData = prefs.getString("userData");
                        final user =
                            LoginResponseDto.fromJson(jsonDecode(userData!));
                        final collectorId = user.id;
                        BlocProvider.of<FarmersCubit>(context)
                            .getFarmers(collectorId!);
                      },
                      icon: const Icon(Icons.refresh))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
