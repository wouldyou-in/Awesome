import Foundation
import Alamofire

struct PostDevieceTokenDataService {
    static let shared = PostDevieceTokenDataService()
    let userToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    
    private func makeParameter(push_token : String) -> Parameters
    {
        return ["push_token": push_token]
    }
    
    func AutoLoginService(push_token : String,
              completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let header : HTTPHeaders = ["Authorization": "Bearer " + userToken]
        let dataRequest = AF.request(Constants.deviceTokenURL,
                                     method: .post,
                                     parameters: makeParameter(push_token: push_token),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            
            switch dataResponse.result {
            case .success:
                
                print("-----디바이스 토큰 업데이트 데이터 요청 성공")
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
        
        
        guard let decodedData = try? decoder.decode(PostTokenDataModel.self, from: data)
        else {
            print("패쓰에러")
            return .pathErr
            
        }
        
        switch statusCode {
        
        case 200:
            print("--- 디바이스 토큰 데이터 받기 성공")
            return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
    
}
