import 'package:dairy_app/core/utils/utils.dart';
import 'package:dairy_app/feature/home/presentation/cubit/home_cubit.dart';
import 'package:dairy_app/feature/home/presentation/widgets/dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/theme/colors.dart';

class SubCollectorTotals extends StatelessWidget {
  const SubCollectorTotals({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          Fluttertoast.showToast(msg: "An error occured");
        } else if (state.uiState == UIState.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: spinkit(),
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: AppColors.lightColorScheme.primary.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1))
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Sub Collections",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Text(
                    state.totalSubColl.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                children: [
                  const Text("Sub Total Ltrs",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Text(
                    state.totalSubLitres.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
