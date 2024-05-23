//
//  StringSubSequence+chmodCount.swift
//
//
//  Created by paulober on 23.05.24.
//
//  The contents of this file are subject to the Mozilla Public
//  License Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of
//  the License at http://mozilla.org/MPL/2.0/.
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an "AS
//  IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
//  express or implied. See the License for the specific language
//  governing permissions and limitations under the License.
//

let symbolicMap: [Character: Int] = [
    "r": 4,
    "w": 2,
    "x": 1,
    "-": 0
]

internal extension String.SubSequence {
    func chmodCount() -> Int {
        var total = 0
        for char in self {
            total += symbolicMap[char] ?? 0
        }
        return total
    }
}
