import Alamofire
import Foundation



struct GetScheduleNoticeDataService
{
    static let scheduleData = GetScheduleNoticeDataService()
    let userToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    
    func getRecommendInfo(completion : @escaping (NetworkResult<Any>) -> Void)
    {
        // completion 클로저를 @escaping closure로 정의합니다.
        let URL = Constants.calendarAcceptURL
        let header : HTTPHeaders = ["Authorization": "Bearer " + userToken]
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                print("ㅁㄴㅇㄹ", statusCode)
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)

            case .failure: completion(.pathErr)
                print("실패 사유")

                
            }
        }
    }
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200: return isValidData(data: data)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    private func isValidData(data : Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .secondsSince1970
        guard let decodedData = try? decoder.decode(ScheduleNoticeModel.self, from: data)
        else {return .pathErr}
    
        return .success(decodedData)

    }
    
}
