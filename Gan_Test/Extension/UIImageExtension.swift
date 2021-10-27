//
//  UiImageExtension.swift
//  Gan_Test
//
//  Created by Clive Brown on 10/09/2020.
//  Copyright © 2020 Clive Brown. All rights reserved.
//

import UIKit

extension UIImage {

    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
   
}
