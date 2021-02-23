//
//  UIImage+Extensions.swift
//  iBeer
//
//  Created by Felipe Andrade on 23/02/21.
//

import UIKit

extension UIImage {
    static func downloadFromRemoteURL(_ url: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image, nil)
            }
        }.resume()
    }
}
