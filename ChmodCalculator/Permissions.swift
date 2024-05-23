//
//  Permissions.swift
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

import Combine

@MainActor
internal class Permissions: ObservableObject {
    @Published var numericInput: String = "" {
        didSet {
            if numericInput != oldValue {
                updatePermissionsFromNumericInput()
            }
        }
    }
    
    @Published var symbolicInput: String = "" {
        didSet {
            if symbolicInput != oldValue {
                updatePermissionsFromSymbolicInput()
            }
        }
    }
    
    @Published var ownerRead: Bool = false {
        didSet { updateInputsFromPermissions() }
    }
    @Published var ownerWrite: Bool = false {
        didSet { updateInputsFromPermissions() }
    }
    @Published var ownerExecute: Bool = false {
        didSet { updateInputsFromPermissions() }
    }
    
    @Published var groupRead: Bool = false {
        didSet { updateInputsFromPermissions() }
    }
    @Published var groupWrite: Bool = false {
        didSet { updateInputsFromPermissions() }
    }
    @Published var groupExecute: Bool = false {
        didSet { updateInputsFromPermissions() }
    }
    
    @Published var publicRead: Bool = false {
        didSet { updateInputsFromPermissions() }
    }
    @Published var publicWrite: Bool = false {
        didSet { updateInputsFromPermissions() }
    }
    @Published var publicExecute: Bool = false {
        didSet { updateInputsFromPermissions() }
    }
    
    private func updatePermissionsFromNumericInput() {
        // Assuming numericInput is in the form of a three-digit octal number (e.g., "755")
        guard numericInput.count == 3 || numericInput.count == 4, let numericValue = Int(numericInput) else {
            // Clear all permissions if numericInput is not a valid integer
            symbolicInput = "" // Clear symbolicInput
            clearPermissions()
            return
        }
        
        //let ownerPermissions = (numericValue / 100) % 10
        let ownerPermissions = numericValue / 100
        let groupPermissions = (numericValue / 10) % 10
        let publicPermissions = numericValue % 10
        
        ownerRead = (ownerPermissions & 4) != 0
        ownerWrite = (ownerPermissions & 2) != 0
        ownerExecute = (ownerPermissions & 1) != 0
        
        groupRead = (groupPermissions & 4) != 0
        groupWrite = (groupPermissions & 2) != 0
        groupExecute = (groupPermissions & 1) != 0
        
        publicRead = (publicPermissions & 4) != 0
        publicWrite = (publicPermissions & 2) != 0
        publicExecute = (publicPermissions & 1) != 0
    }
    
    private func updatePermissionsFromSymbolicInput() {
        // Assuming symbolicInput is in the form of "rwxr-xr-x"
        guard symbolicInput.count == 9 else { return }
        
        let ownerPermissions = symbolicInput.prefix(3)
        let groupPermissions = symbolicInput.dropFirst(3).prefix(3)
        let publicPermissions = symbolicInput.dropFirst(6).prefix(3)
        
        ownerRead = ownerPermissions.contains("r")
        ownerWrite = ownerPermissions.contains("w")
        ownerExecute = ownerPermissions.contains("x")
        
        groupRead = groupPermissions.contains("r")
        groupWrite = groupPermissions.contains("w")
        groupExecute = groupPermissions.contains("x")
        
        publicRead = publicPermissions.contains("r")
        publicWrite = publicPermissions.contains("w")
        publicExecute = publicPermissions.contains("x")
    }
    
    private func symbolicToNumeric(_ symbolicPermissions: String) -> Int? {
        guard symbolicPermissions.count == 9 || symbolicPermissions.count == 10 else {
            print("Invalid symbolic permissions string. It should be exactly 9 characters long.")
            return nil
        }
        
        if symbolicPermissions.count == 10 {
            let firstPart = symbolicPermissions.dropFirst(1).prefix(3).chmodCount()
            let second = symbolicPermissions.dropFirst(1+3).prefix(3).chmodCount()
            let last = symbolicPermissions.suffix(3).chmodCount()
            return Int("\(firstPart)\(second)\(last)")
        } else {
            let firstPart = symbolicPermissions.prefix(3).chmodCount()
            let second = symbolicPermissions.dropFirst(3).prefix(3).chmodCount()
            let last = symbolicPermissions.suffix(3).chmodCount()
            return Int("\(firstPart)\(second)\(last)")
        }
    }
    
    private func updateInputsFromPermissions() {
        let ownerPermissions = (ownerRead ? "r" : "-") + (ownerWrite ? "w" : "-") + (ownerExecute ? "x" : "-")
        let groupPermissions = (groupRead ? "r" : "-") + (groupWrite ? "w" : "-") + (groupExecute ? "x" : "-")
        let publicPermissions = (publicRead ? "r" : "-") + (publicWrite ? "w" : "-") + (publicExecute ? "x" : "-")
        
        symbolicInput = ownerPermissions + groupPermissions + publicPermissions
        
        let ownerValue = (ownerRead ? 4 : 0) + (ownerWrite ? 2 : 0) + (ownerExecute ? 1 : 0)
        let groupValue = (groupRead ? 4 : 0) + (groupWrite ? 2 : 0) + (groupExecute ? 1 : 0)
        let publicValue = (publicRead ? 4 : 0) + (publicWrite ? 2 : 0) + (publicExecute ? 1 : 0)
        
        numericInput = "\(ownerValue)\(groupValue)\(publicValue)"
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
