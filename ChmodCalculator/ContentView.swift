//
//  ContentView.swift
//
//
//  Created by paulober on 01.05.24.
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

import SwiftUI

let symbolicMap: [Character: Int] = [
    "r": 4,
    "w": 2,
    "x": 1,
    "-": 0
]

extension String.SubSequence {
    public func chmodCount() -> Int {
        var total = 0
        for char in self {
            total += symbolicMap[char] ?? 0
        }
        return total
    }
}

struct ContentView: View {
    // Data repr
    @StateObject private var permissions = Permissions()
    
    @State private var programmaticSymbolicUpdate = false // Flag to track programmatic updates
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    // lock to synchronize access to data repr
    let inputLock = NSLock()
    @State private var ignore: UInt8 = 0
    
    var body: some View {
        VStack {
            HStack {
                TextField("Octal", text: $permissions.numericInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    .scrollDismissesKeyboard(.immediately)
                    #endif
                    .padding()
                Spacer()
                TextField("Symbolic", text: $permissions.symbolicInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
            
            if verticalSizeClass == .regular && horizontalSizeClass == .compact {
                ScrollView {
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Owner").font(.title)
                            Toggle("Read", isOn: $permissions.ownerRead)
                            Toggle("Write", isOn: $permissions.ownerWrite)
                            Toggle("Execute", isOn: $permissions.ownerExecute)
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Group").font(.title)
                            Toggle("Read", isOn: $permissions.groupRead)
                            Toggle("Write", isOn: $permissions.groupWrite)
                            Toggle("Execute", isOn: $permissions.groupExecute)
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Public").font(.title)
                            Toggle("Read", isOn: $permissions.publicRead)
                            Toggle("Write", isOn: $permissions.publicWrite)
                            Toggle("Execute", isOn: $permissions.publicExecute)
                        }
                        .padding()
                    }
                }
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Owner")
                        Toggle("Read", isOn: $permissions.ownerRead)
                        Toggle("Write", isOn: $permissions.ownerWrite)
                        Toggle("Execute", isOn: $permissions.ownerExecute)
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Group")
                        Toggle("Read", isOn: $permissions.groupRead)
                        Toggle("Write", isOn: $permissions.groupWrite)
                        Toggle("Execute", isOn: $permissions.groupExecute)
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Public")
                        Toggle("Read", isOn: $permissions.publicRead)
                        Toggle("Write", isOn: $permissions.publicWrite)
                        Toggle("Execute", isOn: $permissions.publicExecute)
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
