import Foundation
import Alamofire

struct AppleLoginService {
    static let shared = AppleLoginService()

    private func makeParameter(code: String, name: String) -> Parameters
    {
        return ["code": code, "name": name]
    }
    
    func postScheduleService(code: String, name: String,
              completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        let dataRequest = AF.request(Constants.appleLogin,
                                     method: .post,
                                     parameters: makeParameter(code: code, name: name),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        
        dataRequest.responseData { dataResponse in
            
            switch dataResponse.result {
            case .success:
                
                print("-----애플 데이터 요청 성공")
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
        
        
        guard let decodedData = try? decoder.decode(KakaoLoginTokenModel.self, from: data)
        else {
            print("패쓰에러")
            return .pathErr
            
        }
        
        switch statusCode {
        
        case 200:
            print("--- 애플 데이터 받기 성공")
            let defaults = UserDefaults.standard
            defaults.set(decodedData.refreshToken, forKey: "refreshToken")
            defaults.set(decodedData.accessToken , forKey: "accessToken")
            defaults.set(decodedData.user.name, forKey: "myName")
            defaults.set(decodedData.user.id, forKey: "myKey")
            defaults.set(true, forKey: "appleLoginSuccess")
            defaults.set(true, forKey: "loginBool")
            return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    
}
