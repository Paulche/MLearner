//
//  GoogleCustomSearchService.swift
//  MLearner
//
//  Created by Pavel Chechetin on 8/7/18.
//  Copyright © 2018 Pavel Chechetin. All rights reserved.
//

import Foundation
import UIKit
import os.log

class SafeURL: Decodable, CustomDebugStringConvertible {
    var debugDescription: String {
        let urlString = url?.debugDescription ?? "nil"
        
        return "SafeURL(url: \(urlString)"
    }
    
    let url: URL?
    
    required init(from decoder: Decoder) throws {
        let container           = try decoder.singleValueContainer()
        let linkValue: String   = try container.decode(String.self)
        
        url = URL(string: linkValue)
    }
}

struct SearchResponse: Decodable {
    let kind: String
    let items: [SearchItem]
    
    struct SearchItem: Decodable {
        let title: String
        let link: SafeURL
        let mime: String
        let image: Image
        
        struct Image: Decodable {
            let height: UInt
            let width: UInt
            let byteSize: UInt
            
            let thumbnailLink: SafeURL
            let thumbnailHeight: UInt
            let thumbnailWidth: UInt
        }
    }
}

class GoogleCustomSearchService {
    let searchEngineId  = "004975107456371996321:myk_c3-3aac"
    let googleApiId     = "AIzaSyAqjfkoG5abeePeCCYiaxIuC2KIHHp9MsQ"
    let scheme          = "https"
    let host            = "www.googleapis.com"
    let path            = "/customsearch/v1"
    let jsonDecoder     = JSONDecoder()
    let urlSession      = URLSession.shared
    
    public var response: SearchResponse?
    
    private func makeURL(_ term: String) -> URL {
        let query           = "key=\(googleApiId)&cx=\(searchEngineId)&searchType=image&q=\(term)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString       = "\(scheme)://\(host)\(path)?\(query)"
        
        let url = URL(string: urlString)

        return url!
    }
    
    public func search(term: String, completionHander: @escaping (Error?) -> Void) -> Void {
        // TODO: Search the term using Google Custom Search
        
        let url       = makeURL(term)
        let dataTask  = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHander(error)
            } else {
                do {
                    self.response = try self.jsonDecoder.decode(SearchResponse.self, from: data!)
                    
                    os_log("SearchResponse: %@", self.response.debugDescription)
                    
                    completionHander(nil)
                } catch DecodingError.dataCorrupted(let context) {
                    os_log("JSON decoding error, context: %@", context.debugDescription)
                } catch  {
                    os_log("Unexpected error: %@", error.localizedDescription)
                }
            }
        }

        dataTask.resume()
    }
}
