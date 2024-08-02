import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_search/infrastructure/models/job_model.dart';
import 'package:job_search/infrastructure/provider/provider_registration.dart';
import 'package:job_search/ui/widgets/common_auth_buttons.dart';
import 'package:job_search/ui/widgets/common_text_field.dart';

class AddJobScreen extends ConsumerStatefulWidget {
  const AddJobScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends ConsumerState<AddJobScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController responsibilitiesController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final jobProviderRead = ref.read(jobProvider);
    final jobProviderWatch = ref.watch(jobProvider);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Add a Job'),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFieldInput(
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Please enter Job title';
                        }
                      },
                      textEditingController: titleController,
                      hintText: 'Job Title',
                      textInputType: TextInputType.text),
                  TextFieldInput(
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Please enter Job address';
                        }
                      },
                      textEditingController: addressController,
                      hintText: 'Address',
                      textInputType: TextInputType.text),
                  TextFieldInput(
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Please enter Job Role';
                        }
                      },
                      textEditingController: roleController,
                      hintText: 'Role',
                      textInputType: TextInputType.text),
                  TextFieldInput(
                      textEditingController: responsibilitiesController,
                      hintText: 'Responsibilities',
                      textInputType: TextInputType.text),
                  TextFieldInput(
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Please enter Salary';
                        }
                      },
                      textEditingController: salaryController,
                      hintText: 'Salary',
                      textInputType: TextInputType.number),
                  const SizedBox(
                    height: 15.0,
                  ),
                  CommonAuthButton(
                      onTap: () async {
                        if (formKey.currentState?.validate() ?? true) {
                          JobModel job = JobModel(
                              jobTitle: titleController.text,
                              address: addressController.text,
                              role: roleController.text,
                              responsibilities: responsibilitiesController.text,
                              salary: int.parse(salaryController.text));
                          await jobProviderRead.addJobPost(job).then((value) {
                            if (value == 'success') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Center(
                                    child: Text('Job added Successfully!')),
                              ));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Center(child: Text(value)),
                              ));
                            }
                            clearController();
                            Navigator.pop(context);
                          });
                        }
                      },
                      text: 'Post Job')
                ],
              ),
            ),
          ),
        ));
  }

  clearController() {
    titleController.clear();
    addressController.clear();
    roleController.clear();
    responsibilitiesController.clear();
    salaryController.clear();
  }
}
