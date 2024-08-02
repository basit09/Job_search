import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_search/infrastructure/models/job_model.dart';
import 'package:job_search/infrastructure/provider/provider_registration.dart';
import 'package:job_search/ui/widgets/common_auth_buttons.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final JobModel? jobModel;

  const JobDetailScreen({
    Key? key,
    required this.jobModel,
  }) : super(key: key);

  @override
  ConsumerState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        ref.read(jobProvider).getMyJobs();
      },
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobModel?.jobTitle ?? ''),
        centerTitle: true,
        leading:  InkWell(
            onTap: () {
              ref.read(jobProvider).setIsSelectedForAnimation(true);
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_rounded)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: "Job Title: ",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: widget.jobModel?.jobTitle.toString() ?? '',
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            // Image.network(widget.jobModel?.category?.image ?? ''),
            const SizedBox(
              height: 15.0,
            ),
            Text.rich(
              TextSpan(
                text: "Salary: ",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: widget.jobModel?.salary.toString() ?? '',
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w400),
                  ),
                  const TextSpan(
                    text: 'INR',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text.rich(
              TextSpan(
                text: "Role: ",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: widget.jobModel?.role ?? '',
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text.rich(
              TextSpan(
                text: "Responsibilities: ",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: widget.jobModel?.responsibilities ?? '',
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),

            CommonAuthButton(
              isApplied: appliedOrNot(),
              onTap: () {
                ref.read(jobProvider).applyForJob(widget.jobModel?.jobId ?? '');
                Navigator.pop(context);
              },
              text: appliedOrNot() ? 'Applied': 'Apply',
            ),
          ],
        ),
      ),
    );
  }
  bool appliedOrNot(){
    return ref.watch(jobProvider).myJobList?.any((element) => element.jobId == widget.jobModel?.jobId) ?? false;
  }
}
