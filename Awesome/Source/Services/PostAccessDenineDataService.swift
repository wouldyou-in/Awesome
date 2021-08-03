import Foundation
import Alamofire

struct PostAccessDenineDataService {
    static let shared = PostAccessDenineDataService()
    let userToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    
    private func makeParameter(calendar_id : Int, is_accept: Bool) -> Parameters
    {
        return ["calendar_id": calendar_id, "is_accept": is_accept]
    }
    
    func AutoLoginService(calendar_id : Int, is_accept: Bool,
              completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let header : HTTPHeaders = ["Authorization": "Bearer " + userToken]
        let dataRequest = AF.request(Constants.calendarAcceptURL,
                                     method: .post,
                                     parameters: makeParameter(calendar_id: calendar_id, is_accept: is_accept),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            
            switch dataResponse.result {
            case .success:
                
                print("-----수락 거부 업데이트 데이터 요청 성공")
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
        
        
        guard let decodedData = try? decoder.decode(AccessDenineDataModel.self, from: data)
        else {
            print("패쓰에러")
            return .pathErr
            
        }
        
        switch statusCode {
        
        case 200:
            print("--- 수락거부 데이터 받기 성공")
            return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    
}
