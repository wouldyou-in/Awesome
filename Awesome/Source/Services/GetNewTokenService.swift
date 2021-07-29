import Foundation
import Alamofire

struct GetAutoLoginService {
    static let shared = GetAutoLoginService()
    
    private func makeParameter(refresh_token : String) -> Parameters
    {
        return ["refresh_token": refresh_token]
    }
    
    func AutoLoginService(refresh_token : String,
              completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        let dataRequest = AF.request(Constants.updateLoginToken,
                                     method: .post,
                                     parameters: makeParameter(refresh_token: refresh_token),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        
        dataRequest.responseData { dataResponse in
            
            switch dataResponse.result {
            case .success:
                
                print("----- 토큰 업데이트 데이터 요청 성공")
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
        
        
        guard let decodedData = try? decoder.decode(AutoLoginDataModel.self, from: data)
        else {
            print("패쓰에러")
            return .pathErr
            
        }
        
        switch statusCode {
        
        case 200:
            print("--- 데이터 받기 성공")
            let usertoken = UserDefaults.standard.set(decodedData.accesstoken, forKey: "accessToken")
            print("dd", UserDefaults.standard.string(forKey: "accessToken"))
            return .success(decodedData.accesstoken)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    
}
