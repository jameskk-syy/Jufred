import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../blocs/filter_collections_cubit.dart';

class FilteredCollectionsPage extends StatelessWidget {
  const FilteredCollectionsPage(
      {super.key,
      required this.farmerNo,
      required this.startDate,
      required this.collectorId,
      required this.session,
      required this.endDate});
  final int collectorId;
  final String farmerNo;
  final String startDate;
  final String endDate;
  final String session;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FilterCollectionsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Collections"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<FilterCollectionsCubit, FilterCollectionsState>(
        listener: (context, state) {
      if (state.uiState == UIState.error) {
        /*ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.exception!),
                  backgroundColor: Colors.red,
                )
            );*/
        Fluttertoast.showToast(
            msg: 'An error occurred',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }, builder: (context, state) {
      if (state.uiState == UIState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.uiState == UIState.initial) {
        dispatchGetFilteredCollections(context);
        return const Center(child: CircularProgressIndicator());
      } else if (state.uiState == UIState.success) {
        if (state.collectionHistoryModel!.entity!.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              dispatchGetFilteredCollections(context);
            },
            child: const Center(
              child: Text('You have no collection history'),
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              dispatchGetFilteredCollections(context);
            },
            child: ListView.builder(
              itemCount: state.collectionHistoryModel!.entity!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            AppColors.lightColorScheme.primary.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/milk_placeholder.png",
                              height: 90,
                              width: 50,
                            ),
                            Text(
                              "${state.collectionHistoryModel!.entity![index].quantity} Ltrs",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, size: 15,color: AppColors.lightColorScheme.primary,),
                                const SizedBox(width: 5,),
                                Expanded(
                                        child: Text(
                                          " ${state.collectionHistoryModel!.entity![index].farmer!}",
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 10),
                                        ),
                                      ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.numbers,
                                                  color: AppColors.lightColorScheme.primary,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "Farmer/No. ${state.collectionHistoryModel!.entity![index].farmerNo.toString()}",
                                                    style: const TextStyle(
                                                        overflow: TextOverflow.ellipsis,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month,
                                                  color: AppColors.lightColorScheme.primary,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "Date. ${state.collectionHistoryModel!.entity![index].collectionDate!.split('T').first}",
                                                    style: const TextStyle(
                                                        overflow: TextOverflow.ellipsis,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.route,
                                                  color: AppColors.lightColorScheme.primary,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${state.collectionHistoryModel!.entity![index].route!} route",
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // const SizedBox(
                                            //   height: 5,
                                            // ),
                                            // Row(
                                            //   children: [
                                            //     Icon(
                                            //       Icons.attach_money_rounded,
                                            //       color: AppColors.lightColorScheme.primary,
                                            //       size: 15,
                                            //     ),
                                            //     const SizedBox(
                                            //       width: 5,
                                            //     ),
                                            //     Expanded(
                                            //       child: Text(
                                            //         '${state.collectionHistoryModel!.entity![index].amount!}Ksh',
                                            //         style: const TextStyle(
                                            //           fontSize: 10,
                                            //           fontWeight: FontWeight.bold,
                                            //           overflow: TextOverflow.ellipsis,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  color: AppColors.lightColorScheme.primary,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    (state.collectionHistoryModel!.entity![index]
                                                        .session!) == "Session 1" ? "Morning" : (state.collectionHistoryModel!.entity![index].session! == "Session 2" ? "Afternoon" : "Evening"),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],

                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  void dispatchGetFilteredCollections(BuildContext context) {
    final log = Logger();
    log.i('dispatching GetFilteredCollections');
    final cubit = context.read<FilterCollectionsCubit>();
    cubit.getFilteredCollections(
        collectorId: collectorId,
        farmerNo: farmerNo,
        startDate: startDate,
        endDate: endDate,
        session: session);
  }
}
