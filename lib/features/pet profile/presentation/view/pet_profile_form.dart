import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/features/pet%20profile/presentation/bloc/pet_profile_cubit.dart';
import 'package:pet_alert_app/features/pet%20profile/presentation/bloc/pet_profile_state.dart';

class PetProfileForm extends StatefulWidget {
  const PetProfileForm({super.key});

  @override
  State<PetProfileForm> createState() => _PetProfileFormState();
}

class _PetProfileFormState extends State<PetProfileForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetProfileCubit, PetProfileState>(
      builder: (context, state) {
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Pet Profile",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Name Field
                  TextFormField(
                    initialValue: state.name,
                    decoration:
                        const InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      context.read<PetProfileCubit>().updateName(value);
                    },
                  ),

                  /// Species Dropdown
                  DropdownButtonFormField<String>(
                    value: state.species,
                    decoration:
                        const InputDecoration(labelText: 'Species'),
                    items: ['Dog', 'Cat', 'Other']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      context.read<PetProfileCubit>().updateSpecies(value);
                    },
                  ),

                  /// Sex Dropdown
                  DropdownButtonFormField<String>(
                    value: state.sex,
                    decoration:
                        const InputDecoration(labelText: 'Sex'),
                    items: ['Male', 'Female']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      context.read<PetProfileCubit>().updateSex(value);
                    },
                  ),

                  /// Birthday Picker
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Birthday',
                      hintText: 'Select date',
                    ),
                    controller: TextEditingController(
                      text: state.birthday == null
                          ? ''
                          : '${state.birthday!.month}/${state.birthday!.day}/${state.birthday!.year}',
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            state.birthday ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        context
                            .read<PetProfileCubit>()
                            .updateBirthday(date);
                      }
                    },
                  ),

                  /// Weight Dropdown
                  DropdownButtonFormField<String>(
                    value: state.weight,
                    decoration:
                        const InputDecoration(labelText: 'Weight'),
                    items: [
                      '<10 lbs',
                      '10-25 lbs',
                      '25-50 lbs',
                      '50+ lbs'
                    ]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      context.read<PetProfileCubit>().updateWeight(value);
                    },
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // For now, just show data in console
                        final petData =
                            context.read<PetProfileCubit>().state;
                        debugPrint("Saved Pet Profile:");
                        debugPrint("Name: ${petData.name}");
                        debugPrint("Species: ${petData.species}");
                        debugPrint("Sex: ${petData.sex}");
                        debugPrint(
                            "Birthday: ${petData.birthday?.toIso8601String()}");
                        debugPrint("Weight: ${petData.weight}");
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
