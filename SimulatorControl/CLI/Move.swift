//
//  Move.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/02/10.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

extension CLI {
    class Move {
        let target: String
        let source: String
        let force: Bool

        init(target: String, from source: String, force: Bool = false) {
            self.target = target
            self.source = source
            self.force = force
        }

        @discardableResult
        func execute() -> Result<Void, Error> {
            do {
                try Process.run(URL(fileURLWithPath: "/bin/mv"), arguments: [source, target])
                return .success(())
            } catch let error {
                return .failure(error)
            }
        }
    }
}
