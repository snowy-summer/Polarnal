//
//  DesignOfFolderIcon.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import Foundation

enum DesignOfFolderIcon: String, CaseIterable {
    case list
    case penceil
    case mappin
    case birthday
    case graduate
    case gym
    case exersice
    case forkAndNife
    case cup
    case tv
    case camping
    case music
    case game
    case home
    case airplane
    case camera
    case tennis
    case hospital
    case creditCard
    case study
    case clip
    case cloud
    case wifi
    case delivery
    case computer
    case market
    case doc
    case key
    case clock
    case heart
    
    init(rawValue: String) {
        if let matchingCase = DesignOfFolderIcon.allCases.first(where: { $0.rawValue == rawValue }) {
            self = matchingCase
        } else {
            self = .list
        }
    }
    
    var iconName: String {
        switch self {
        case .list:
            return "list.bullet"
        case .penceil:
            return "pencil"
        case .mappin:
            return "mappin"
        case .birthday:
            return "birthday.cake"
        case .graduate:
            return "graduationcap"
        case .gym:
            return "dumbbell"
        case .exersice:
            return "figure.run"
        case .forkAndNife:
            return "fork.knife"
        case .cup:
            return "cup.and.saucer"
        case .tv:
            return "tv"
        case .camping:
            return "tent"
        case .music:
            return "music.note"
        case .game:
            return "gamecontroller"
        case .home:
            return "house"
        case .airplane:
            return "airplane"
        case .camera:
            return "camera"
        case .tennis:
            return "tennis.racket"
        case .hospital:
            return "stethoscope"
        case .creditCard:
            return "creditcard"
        case .study:
            return "pencil.and.ruler"
        case .clip:
            return "paperclip"
        case .cloud:
            return "icloud"
        case .wifi:
            return "wifi"
        case .delivery:
            return "truck.box"
        case .computer:
            return "desktopcomputer"
        case .market:
            return "cart"
        case .doc:
            return "doc"
        case .key:
            return "key"
        case .clock:
            return "clock"
        case .heart:
            return "heart"
        }
    }
}
