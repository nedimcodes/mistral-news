//
//	NewsAPIHandler
//  News
//	Created by: @nedimf on 29/04/2022


import Foundation


class NewsAPIHandler: NSObject{

    let apiKey = "c4fa1af1b54a4eee82d8a8bbc453ee98"
    
    ///Sends API request to newsapi.org
    ///- Parameter model:Model.Type
    ///- Parameter endpoint: Endpoint
    ///- Parameter completion: @escaping(Result<Model, Error>) -> Void
    ///- Warning: decoding data to model is performed here
    public func fetchNewsAPI<Model>(_ model: Model.Type, endpoint: Endpoint, completion: @escaping(Result<Model, Error>) -> Void) where Model: Decodable{
        let url = endpoint.URL
        if let url = url {
            let request = URLRequest(url: url)
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.httpAdditionalHeaders = ["X-Api-Key": apiKey]
            
            let task = URLSession.init(configuration: sessionConfig).dataTask(with: request) { data, response, err in
                if let err = err {
                    completion(.failure(err))
                }
                else if let data = data {
                    if let response = response {
                        guard let status = response as? HTTPURLResponse else {
                            return
                        }
                        if (status.statusCode == 200){
                            let result = Result { try JSONDecoder().decode(Model.self, from: data)}
                            completion(result)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    
}
