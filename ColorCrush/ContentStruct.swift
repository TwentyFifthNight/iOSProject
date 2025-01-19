import Foundation
import SwiftUI

enum ContentType { case blank, oval, drop, app, circle, star, heart, snow}

struct Content{
    var contentType: ContentType
    var foregroundColor: Color {
        switch self.contentType {
        case .blank: return .clear
        case .oval: return .orange
        case .drop: return .cyan
        case .app: return .green
        case .circle: return .blue
        case .star: return .yellow
        case .heart: return .red
        case .snow: return .white
        }
    }
    var systemName: String {
        switch self.contentType {
        case .blank: return ""
        case .oval: return "oval.portrait.fill"
        case .drop: return "drop.fill"
        case .app: return "app.fill"
        case .circle: return "circle.fill"
        case .star: return "star.fill"
        case .heart: return "heart.fill"
        case .snow: return "snow"
        }
    }
}
