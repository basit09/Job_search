import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_search/infrastructure/provider/provider_registration.dart';
import 'package:job_search/ui/screens/job_detail_page/job_detail_screen.dart';
import 'package:job_search/ui/screens/my_job_screen/my_job_screen.dart';
import 'package:job_search/ui/screens/profile_screen/profile_screen.dart';
import 'package:job_search/ui/widgets/common_text_field.dart';

class JobseekerHomeScreen extends ConsumerStatefulWidget {
  const JobseekerHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _JobseekerHomeScreenState();
}

class _JobseekerHomeScreenState extends ConsumerState<JobseekerHomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(jobProvider).getJobs();
      },
    );
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final jobProviderRead = ref.read(jobProvider);
    final jobProviderWatch = ref.watch(jobProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        centerTitle: true,
        leading: InkWell(
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
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyJobScreen(),
                  ));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.bookmark_add_rounded,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TextFieldInput(
            textEditingController: searchController,
            hintText: 'Search Job',
            textInputType: TextInputType.text,
            onChanged: (value) {
              jobProviderRead.searchJobs(value);
            },
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    alignment: jobProviderWatch.isSelected
                        ? Alignment.topCenter
                        : Alignment.centerRight,
                    height: jobProviderWatch.isSelected ? 100 : 80,
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
                        ref.read(jobProvider).setIsSelectedForAnimation(false);
                        searchController.clear();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailScreen(
                                  jobModel:
                                      jobProviderWatch.searchResults?[index]),
                            ));
                      },
                      title: Text(
                          jobProviderWatch.searchResults?[index].jobTitle ??
                              ''),
                      subtitle: Text(jobProviderWatch
                              .searchResults?[index].address
                              .toString() ??
                          ''),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: jobProviderWatch.searchResults?.length ?? 0),
          ),
        ],
      ),
    );
  }
}
