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
#if os(iOS)
import UniformTypeIdentifiers
#endif

struct ContentView: View {
    // Data repr
    @StateObject private var permissions = Permissions()
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    // Focus state for text fields
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case numericInput
        case symbolicInput
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Octal", text: $permissions.numericInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    .scrollDismissesKeyboard(.immediately)
                    .textContentType(.none)
                    .replaceDisabled()
                    #endif
                    .padding(.vertical)
                    // Set focus state
                    .focused($focusedField, equals: .numericInput)
                    .autocorrectionDisabled()
                
                Button(action: {
                    copyToPasteboard(permissions.numericInput)
                }) {
                    Image(systemName: "doc.on.doc")
                }
                .padding(.trailing)
                
                Spacer()
                
                TextField("Symbolic", text: $permissions.symbolicInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical)
                    // Set focus state
                    .focused($focusedField, equals: .symbolicInput)
                    .autocorrectionDisabled()
                
                Button(action: {
                    copyToPasteboard(permissions.symbolicInput)
                }) {
                    Image(systemName: "doc.on.doc")
                }
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
        .onTapGesture {
            // Dismiss the keyboard if any area outside the text fields is tapped
            focusedField = nil
        }
    }
    
    private func copyToPasteboard(_ value: String) {
        #if os(iOS)
        UIPasteboard.general.string = value
        #else
        NSPasteboard.general.clearContents()
        NSPasteboard.general.writeObjects([value as NSString])
        #endif
    }
}

#Preview {
    ContentView()
}
