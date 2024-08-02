import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_search/infrastructure/provider/provider_registration.dart';
import 'package:job_search/ui/screens/add_job_screen/add_job_screen.dart';
import 'package:job_search/ui/screens/profile_screen/profile_screen.dart';

class EmployerHomeScreen extends ConsumerStatefulWidget {
  const EmployerHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<EmployerHomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(jobProvider).getEmployerPostedJob();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final jobProviderRead = ref.read(jobProvider);
    final jobProviderWatch = ref.watch(jobProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employer'),
        centerTitle: true,
        leading: const SizedBox.shrink(),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.account_circle_outlined,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(jobProvider).getEmployerPostedJob();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddJobScreen(),
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(right: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.5),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Text(
                    'Add Job',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Posted Job',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.only(right: 12, top: 12, bottom: 12),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.5),
                            // Semi-transparent black
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          )
                        ]),
                    child: ListTile(
                      trailing: InkWell(
                          onTap: () {
                            jobProviderRead.removeJobPost(jobProviderWatch
                                    .employerJobList?[index].jobId ??
                                '', jobProviderWatch
                                .employerJobList![index]).then((value) {
                                  if(value == 'success'){
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Center(
                                          child: Text('Job removed Successfully!')),
                                    ));
                                  }
                                },);
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      title: Text(
                          jobProviderWatch.employerJobList?[index].jobTitle ??
                              ''),
                      subtitle: Text(jobProviderWatch
                              .employerJobList?[index].address
                              .toString() ??
                          ''),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: jobProviderWatch.employerJobList?.length ?? 0),
          ),
        ],
      ),
    );
  }
}
