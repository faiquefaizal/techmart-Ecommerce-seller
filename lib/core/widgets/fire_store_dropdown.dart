import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techmart_seller/core/funtion/dropdown/cubit/dropdown_cubit.dart';

class FireStoreDropdown extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final String dataName;
  final String labelField;
  final void Function(String?)? onChanged;
  final String? hintText;

  const FireStoreDropdown({
    super.key,
    required this.stream,
    required this.dataName,
    this.labelField = 'name',
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DropdownCubit(),
      child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text(
              'No $dataName available. Please add $dataName in Admin App.',
              style: const TextStyle(color: Colors.red),
            );
          }

          final data = snapshot.data!.docs;

          return BlocBuilder<DropdownCubit, String?>(
            builder: (context, state) {
              return DropdownButtonFormField<String>(
                value: state,
                decoration: InputDecoration(
                  hintText: hintText ?? 'Select $dataName',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                items:
                    data.map((doc) {
                      final name = doc[labelField] as String;
                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text(name),
                      );
                    }).toList(),
                onChanged: (selected) {
                  context.read<DropdownCubit>().selectItem(selected);
                  if (onChanged != null) {
                    onChanged!(selected);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FireStoreDropdownButton extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final String dataName;
  final String labelField;
  final void Function(String?)? onChanged;
  final String? hintText;
  final Seleeted;

  const FireStoreDropdownButton({
    super.key,
    required this.stream,
    required this.dataName,
    this.labelField = 'name',
    this.onChanged,
    this.hintText,
    required this.Seleeted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DropdownCubit(),
      child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text(
              'No $dataName available. Please add $dataName in Admin App.',
              style: const TextStyle(color: Colors.red),
            );
          }

          final data = snapshot.data!.docs;

          return DropdownButtonFormField<String>(
            value: Seleeted,
            decoration: InputDecoration(
              hintText: hintText ?? 'Select $dataName',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            items:
                data.map((doc) {
                  final name = doc[labelField] as String;
                  return DropdownMenuItem<String>(
                    value: doc.id,
                    child: Text(name),
                  );
                }).toList(),
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}
