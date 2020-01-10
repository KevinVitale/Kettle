import Foundation
import AnyCodable

#if !canImport(Darwin)
import FoundationNetworking
#endif

public protocol JSONRPCAPI: Codable {
    static var prefix :String { get }
}

extension JSONRPCAPI {
    static var version :String { "2.0" }
}

extension JSONRPCAPI {
    public typealias Request<R: Decodable>      = Web3Kit.Request<Self,R>
    public typealias AnyRequest                 = Request<AnyDecodable>
    public typealias BatchRequest<R: Decodable> = [Request<R>]
    public typealias AnyBatchRequest            = [AnyRequest]
}

public struct Client<API: JSONRPCAPI> {
    private let configuration :ClientConfiguration
    private let session       :URLSession
    private let encoder       :JSONEncoder
    private let decoder       = JSONDecoder()
    
    public typealias Result<R: Decodable> = Swift.Result<Response<R>,Swift.Error> where R: Equatable
    public typealias BatchResult<R: Decodable> = Swift.Result<[Response<R>],Swift.Error> where R: Equatable
    
    private let queue = DispatchQueue(label: "com.web3kit.client.queue", qos: .unspecified, attributes: .concurrent)
    
    fileprivate func encoded<T: Encodable>(request: T) -> URLRequest {
        var urlRequest = URLRequest(url: configuration.url)
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.httpMethod  = "POST"
        urlRequest.httpBody = try? encoder.encode(request)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    
    fileprivate func decoded<T: Decodable>(data: Data?) -> Swift.Result<Response<T>,Swift.Error> {
        Swift.Result<Response<T>,Swift.Error> {
            guard let data = data else {
                // FIXME with a .failure(/* error */)
                fatalError("\(#file): \(#function); \(#line)")
            }
            return try decoder.decode(Response<T>.self, from: data)
        }
    }
    
    fileprivate func decoded<T: Decodable>(data: Data?) -> Swift.Result<[Response<T>],Swift.Error> {
        Swift.Result<[Response<T>],Swift.Error> {
            guard let data = data else {
                // FIXME with a .failure(/* error */)
                fatalError("\(#file): \(#function); \(#line)")
            }
            return try decoder.decode([Response<T>].self, from: data)
        }
    }
}

extension Client {
    fileprivate func request<R: Decodable>(_ request: API.Request<R>, callback: @escaping (Result<R>) -> ()) {
        let task = session.dataTask(with: encoded(request: request)) { data, response, error in
            guard error == nil else {
                callback(.failure(error!))
                return
            }
            callback(self.decoded(data: data))
        }
        task.resume()
    }
    
    fileprivate func request(_ request: API.AnyRequest..., callback: @escaping (BatchResult<AnyDecodable>) -> ()) {
        self.request(request, callback: callback)
    }

    fileprivate func request<R: Decodable>(_ request: API.BatchRequest<R>, callback: @escaping (BatchResult<R>) -> ()) {
        let task = session.dataTask(with: encoded(request: request)) { data, response, error in
            guard error == nil else {
                callback(.failure(error!))
                return
            }
            callback(self.decoded(data: data))
        }
        task.resume()
    }

    fileprivate func request(_ method: String, parameters: [Any] = [], id: Int = 1, callback: @escaping (Result<AnyDecodable>) -> ()) {
        self.request(API.AnyRequest(method, parameters: parameters, id: id), callback: callback)
    }
}

extension Client {
    public func callAsFunction<R: Decodable>(request: API.Request<R>) -> Result<R> {
        Web3Kit.waitFor { self.request(request, callback: $0) }
    }

    public func callAsFunction(request: API.Request<AnyDecodable>...) -> BatchResult<AnyDecodable> {
        Web3Kit.waitFor { self.request(request, callback: $0) }
    }

    public func callAsFunction<R: Decodable>(request: API.BatchRequest<R>) -> BatchResult<R> {
        Web3Kit.waitFor { self.request(request, callback: $0) }
    }

    public func callAsFunction(request method: String, parameters: [Any] = [], id: Int = 1) -> Result<AnyDecodable> {
        Web3Kit.waitFor { self.request(method, parameters: parameters, id: id, callback: $0) }
    }
}

extension Client where API == Web3 {
    func derivedClient<API: JSONRPCAPI>() -> Client<API> {
        .init(configuration: self.configuration,
                    session: self.session,
                    encoder: self.encoder)
    }
    
    public init(_ configuration: ClientConfiguration, session: URLSession = URLSession(configuration: .default)) {
        self.configuration = configuration
        self.session = session
        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = .prettyPrinted
    }
}

