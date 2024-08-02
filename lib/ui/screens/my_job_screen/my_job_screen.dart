import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_search/infrastructure/provider/provider_registration.dart';
import 'package:job_search/ui/screens/job_detail_page/job_detail_screen.dart';

class MyJobScreen extends ConsumerStatefulWidget {
  const MyJobScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MyJobScreenState();
}

class _MyJobScreenState extends ConsumerState<MyJobScreen> {
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
    final jobProviderRead = ref.read(jobProvider);
    final jobProviderWatch = ref.watch(jobProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Jobs'),
        centerTitle: true,

      ),
      body: Column(
        children: [
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
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) =>
                            JobDetailScreen(jobModel: jobProviderWatch
                                .myJobList?[index]),));
                      },
                      title:
                      Text(jobProviderWatch.myJobList?[index].jobTitle ??
                          ''),
                      subtitle: Text(
                          jobProviderWatch.myJobList?[index].address
                              .toString() ??
                              ''),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                const SizedBox(
                  height: 10,
                ),
                itemCount: jobProviderWatch.myJobList?.length ?? 0),
          ),
        ],
      ),
    );
  }
}
