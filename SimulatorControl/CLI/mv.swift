//
//  mv.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/02/10.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

@discardableResult
func mv(target: String, from source: String, force: Bool = false) -> Result<Void, Error> {
    do {
        try Process.run(URL(fileURLWithPath: "/bin/mv"), arguments: [source, target])
        return .success(())
    } catch let error {
        return .failure(error)
    }
}
