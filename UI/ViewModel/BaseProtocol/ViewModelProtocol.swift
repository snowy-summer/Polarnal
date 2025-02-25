//
//  ViewModelProtocol.swift
//  Polarnal
//
//  Created by 최승범 on 12/3/24.
//

import Foundation
import Combine

protocol ViewModelProtocol: AnyObject, ObservableObject {
    
    associatedtype Intent
    
    var cancellables: Set<AnyCancellable> {get set}
    
    func apply(_ intent: Intent)
}
