//
//  SequenceExtension.swift
//  Gan_Test
//
//  Created by Clive Brown on 11/09/2020.
//  Copyright © 2020 Clive Brown. All rights reserved.
//

import UIKit

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
