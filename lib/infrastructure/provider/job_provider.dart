import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:job_search/infrastructure/models/job_application_model.dart';
import 'package:job_search/infrastructure/models/job_model.dart';

class JobProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<JobModel>? _jobList;

  List<JobModel>? get jobList => _jobList;

  List<JobModel>? _employerJobList;

  List<JobModel>? get employerJobList => _employerJobList;

  List<JobModel>? _searchResults;

  List<JobModel>? get searchResults => _searchResults;

  List<JobModel>? _myJobList;

  List<JobModel>? get myJobList => _myJobList;

  bool _isSelected = false;

  bool get isSelected => _isSelected;

  setIsSelectedForAnimation(bool value){
    _isSelected = value;
    notifyListeners();
  }

  Future<String> addJobPost(JobModel job) async {
    String resp = 'Some Error occurred';
    job.employerId = _auth.currentUser?.uid;
    // Add the job to the list with a unique ID
    await _firestore.collection('jobs').add(job.toMap()).then((docRef) {
      _employerJobList?.add(job);
      String jobId = docRef.id; // Get the ID of the newly created document
      job.jobId = jobId; // Update the Job object with the new ID
      _firestore.collection('jobs').doc(jobId).update({'jobId': jobId});
      resp = 'success';
      return resp;
    }).catchError((e) {
      print('Error adding job to list: $e');
      resp = e.toString();
      return resp;
    });
    notifyListeners();
    return resp;

  }

  Future<String> removeJobPost(String jobId, JobModel job) async {
    String resp = 'Some Error occurred';
    try {
      await _firestore.collection('jobs').doc(jobId).delete();

      resp = 'success';
    } catch (e) {
      print('Error removing job from list: $e');
      resp = e.toString();
    }
    _employerJobList?.remove(job);
    notifyListeners();
    return resp;
  }
  Future<void> getJobs() async {
    QuerySnapshot snapshot = await _firestore.collection('jobs').get();

    _jobList = snapshot.docs
        .map((doc) => JobModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    _searchResults = _jobList;
    notifyListeners();
  }
// get Jobs For employer
  Future<void> getEmployerPostedJob() async {
    if (_auth.currentUser == null) {
      print('User is not logged in');
      return;
    }

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('jobs')
          .where('employerID', isEqualTo: _auth.currentUser?.uid)
          .get();

      if (snapshot.docs.isEmpty) {
        print('No jobs found for employer');
      } else {
        _employerJobList = snapshot.docs
            .map((doc) => JobModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        print('Employer List: $_employerJobList');
      }
    } catch (e) {
      print('Error getting employer jobs: $e');
    } finally {
      notifyListeners();
    }
  }

  void searchJobs(String query) {
    _searchResults = _jobList?.where((job) {
      return (job.jobTitle?.toLowerCase().contains(query.toLowerCase()) ??
              false) ||
          (job.address?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
    notifyListeners();
  }

  // Function to apply for a job
  Future<void> applyForJob(String jobId) async {
    final JobApplication application = JobApplication(
      jobId: jobId,
      jobseekerId: _auth.currentUser?.uid,
      applicationStatus: 'pending',
    );
    await FirebaseFirestore.instance
        .collection('jobApplications')
        .add(application.toMap());
  }
/// applied jobs
  Future<void> getMyJobs() async {
    if (_auth.currentUser == null) {
      print('User is not logged in');
      return;
    }
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('jobApplications')
          .where('jobseekerId', isEqualTo: _auth.currentUser?.uid)
          .get();

      if (snapshot.docs.isEmpty) {
        print('No jobs found for jobseeker');
      } else {
_myJobList = [];
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String jobId = data['jobId'];
          for (var job in _jobList ?? []) {
            if (job.jobId == jobId) {
              myJobList?.add(job);
              break;
            }
          }
        }
        print('MY Jobs List: $_employerJobList');
      }
    } catch (e) {
      print('Error getting employer jobs: $e');
    } finally {
      notifyListeners();
    }
  }
}
