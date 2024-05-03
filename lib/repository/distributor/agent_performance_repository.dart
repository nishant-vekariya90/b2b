import '../../api/api_manager.dart';
import '../../model/report/agent_performance_model.dart';
import '../../utils/string_constants.dart';

class AgentPerformanceRepository {
  final APIManager apiManager;
  AgentPerformanceRepository(this.apiManager);

  Future<AgentPerformanceModel> agentPerformanceApiCall({required String searchUserID, required String fromDate, required String toDate, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/distributorreportings/distributor-agent-performance?SearchUserID=$searchUserID&FromDate=$fromDate&ToDate=$toDate',
      isLoaderShow: isLoaderShow,
    );
    var response = AgentPerformanceModel.fromJson(jsonData);
    return response;
  }
}
