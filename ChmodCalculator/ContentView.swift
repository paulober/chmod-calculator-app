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

struct ContentView: View {
    @State private var numericInput = ""
    @State private var symbolicInput = ""
    @State private var ownerRead = false
    @State private var ownerWrite = false
    @State private var ownerExecute = false
    @State private var groupRead = false
    @State private var groupWrite = false
    @State private var groupExecute = false
    @State private var publicRead = false
    @State private var publicWrite = false
    @State private var publicExecute = false
    
    @State private var programmaticSymbolicUpdate = false // Flag to track programmatic updates
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        VStack {
            HStack {
                TextField("Octal", text: $numericInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .scrollDismissesKeyboard(.immediately)
                    .padding()
                Spacer()
                TextField("Symbolic", text: Binding<String>(
                    get: { symbolicInput },
                    set: { newValue in
                        // Set symbolicInput programmatically without triggering onChange
                        if !programmaticSymbolicUpdate {
                            symbolicInput = newValue
                        }
                    })
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
            
            if verticalSizeClass == .regular && horizontalSizeClass == .compact {
                ScrollView {
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Owner").font(.title)
                            Toggle("Read", isOn: $ownerRead)
                            Toggle("Write", isOn: $ownerWrite)
                            Toggle("Execute", isOn: $ownerExecute)
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Group").font(.title)
                            Toggle("Read", isOn: $groupRead)
                            Toggle("Write", isOn: $groupWrite)
                            Toggle("Execute", isOn: $groupExecute)
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Public").font(.title)
                            Toggle("Read", isOn: $publicRead)
                            Toggle("Write", isOn: $publicWrite)
                            Toggle("Execute", isOn: $publicExecute)
                        }
                        .padding()
                    }
                }
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Owner")
                        Toggle("Read", isOn: $ownerRead)
                        Toggle("Write", isOn: $ownerWrite)
                        Toggle("Execute", isOn: $ownerExecute)
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Group")
                        Toggle("Read", isOn: $groupRead)
                        Toggle("Write", isOn: $groupWrite)
                        Toggle("Execute", isOn: $groupExecute)
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Public")
                        Toggle("Read", isOn: $publicRead)
                        Toggle("Write", isOn: $publicWrite)
                        Toggle("Execute", isOn: $publicExecute)
                    }
                    .padding()
                }
            }
        }
        .padding()
        .onChange(of: numericInput) { newValue in
            convertNumericInput()
        }
        /*.onChange(of: symbolicInput) { newValue in
            if !programmaticSymbolicUpdate {
                guard let permissionNumber = symbolicToNumeric(newValue) else {
                    return
                }
                
                let ownerBase = permissionNumber / 100
                let groupBase = (permissionNumber / 10) % 10
                let publicBase = permissionNumber % 10

                // Owner permissions
                ownerRead = (ownerBase & 4) != 0
                ownerWrite = (ownerBase & 2) != 0
                ownerExecute = (ownerBase & 1) != 0

                // Group permissions
                groupRead = (groupBase & 4) != 0
                groupWrite = (groupBase & 2) != 0
                groupExecute = (groupBase & 1) != 0

                // Public permissions
                publicRead = (publicBase & 4) != 0
                publicWrite = (publicBase & 2) != 0
                publicExecute = (publicBase & 1) != 0
            }
        }*/
    }
    
    private func convertNumericInput() {
        guard numericInput.count == 3 || numericInput.count == 4, let permissionNumber = Int(numericInput) else {
            // Clear all permissions if numericInput is not a valid integer
            programmaticSymbolicUpdate = true // Set flag to true to avoid triggering symbolicInput onChange
            symbolicInput = "" // Clear symbolicInput
            programmaticSymbolicUpdate = false // Reset flag
            clearPermissions()
            return
        }
        
        let ownerBase = permissionNumber / 100
        let groupBase = (permissionNumber / 10) % 10
        let publicBase = permissionNumber % 10

        // Owner permissions
        ownerRead = (ownerBase & 4) != 0
        ownerWrite = (ownerBase & 2) != 0
        ownerExecute = (ownerBase & 1) != 0

        // Group permissions
        groupRead = (groupBase & 4) != 0
        groupWrite = (groupBase & 2) != 0
        groupExecute = (groupBase & 1) != 0

        // Public permissions
        publicRead = (publicBase & 4) != 0
        publicWrite = (publicBase & 2) != 0
        publicExecute = (publicBase & 1) != 0
        
        // Generate symbolic representation
        let symbolicString = "\(ownerRead ? "r" : "-")\(ownerWrite ? "w" : "-")\(ownerExecute ? "x" : "-")"
            + "\(groupRead ? "r" : "-")\(groupWrite ? "w" : "-")\(groupExecute ? "x" : "-")"
            + "\(publicRead ? "r" : "-")\(publicWrite ? "w" : "-")\(publicExecute ? "x" : "-")"
        
        programmaticSymbolicUpdate = true // Set flag to true to avoid triggering symbolicInput onChange
        symbolicInput = symbolicString // Update symbolicInput
        programmaticSymbolicUpdate = false // Reset flag
    }
    
    private func symbolicToNumeric(_ symbolicPermissions: String) -> Int? {
        guard symbolicPermissions.count == 9 else {
            print("Invalid symbolic permissions string. It should be exactly 9 characters long.")
            return nil
        }

        var numericPermissions = 0

        let symbolicMap: [Character: Int] = [
            "r": 4,
            "w": 2,
            "x": 1,
            "-": 0
        ]

        for (index, char) in symbolicPermissions.enumerated() {
            if let value = symbolicMap[char] {
                let shift = (2 - (index % 3)) * 3
                numericPermissions += value << shift
            } else {
                print("Invalid character found in symbolic permissions: \(char)")
                return nil
            }
        }

        return numericPermissions
    }
    
    private func clearPermissions() {
        ownerRead = false
        ownerWrite = false
        ownerExecute = false
        groupRead = false
        groupWrite = false
        groupExecute = false
        publicRead = false
        publicWrite = false
        publicExecute = false
    }
}

#Preview {
    ContentView()
}
