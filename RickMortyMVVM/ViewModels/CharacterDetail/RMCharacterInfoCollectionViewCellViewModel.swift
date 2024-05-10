//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 01.05.2024.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    private let type: `Type`
    private let value: String
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        return formatter
    }()
    
    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()

    public var title: String {
        self.type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty {
            return "None"
        }
        if let date = Self.dateFormatter.date(from: value), type == .created {
            return Self.shortFormatter.string(from: date)
        }
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum `Type`: String {
        case status = "Status"
        case gender = "Gender"
        case species = "Species"
        case origin = "Origin"
        case type = "Type"
        case location = "Location"
        case created = "Created"
        case episodeCount = "Episode count"
        
        var displayTitle: String {
            switch self {
            case    .status, .gender, .species,
                    .origin, .type, .location,
                    .created, .episodeCount:
                return rawValue
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemRed
            case .gender:
                return .systemMint
            case .type:
                return .systemCyan
            case .species:
                return .systemFill
            case .origin:
                return .green
            case .created:
                return .gray
            case .location:
                return .brown
            case .episodeCount:
                return .systemPink
            }
        }
    }
    
    // MARK: - Init
    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}
