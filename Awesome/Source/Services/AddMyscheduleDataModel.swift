import Foundation
import Alamofire

struct PostScheduleDataService {
    static let shared = PostScheduleDataService()
    let userToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    
    private func makeParameter(comment : String, start_date: String, end_date: String, receiver_id: Int) -> Parameters
    {
        return ["comment": comment, "start_date": start_date, "end_date": end_date, "receiver_id": receiver_id]
    }
    
    func postScheduleService(comment : String, start_date: String, end_date: String, receiver_id: Int,
              completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let header : HTTPHeaders = ["Authorization": "Bearer " + userToken]
        let dataRequest = AF.request(Constants.postCalendearURL,
                                     method: .post,
                                     parameters: makeParameter(comment: comment, start_date: start_date, end_date: end_date, receiver_id: receiver_id),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        
        dataRequest.responseData { dataResponse in
            
            switch dataResponse.result {
            case .success:
                
                print("-----내 일정 데이터 요청 성공")
                guard let statusCode = dataResponse.response?.statusCode else {return}
                print(dataRequest.response?.statusCode)
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure: completion(.pathErr)
                
            }
        }
        
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601
        guard let decodedData = try? decoder.decode(PostCalendarDataModel.self, from: data)
        else {
            print("패쓰에러")
            return .pathErr
        }
        UserDefaults.standard.setValue(decodedData.data.id, forKeyPath: "postID")
        switch statusCode {
        case 200:
            print("--- 내 일정 올리는 데이터 받기 성공")
            return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    
}
