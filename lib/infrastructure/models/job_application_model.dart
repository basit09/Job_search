class JobApplication {
  String? jobId;
  String? jobseekerId;
  String? applicationStatus;

  JobApplication({this.jobId, this.jobseekerId, this.applicationStatus});

  factory JobApplication.fromMap(Map<String, dynamic> map) {
    return JobApplication(
      jobId: map['jobId'],
      jobseekerId: map['jobseekerId'],
      applicationStatus: map['applicationStatus'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'jobseekerId': jobseekerId,
      'applicationStatus': applicationStatus,
    };
  }
}