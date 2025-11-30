import UIKit
import Foundation

struct HapticFeedbackManager {
    
    static func triggerImpact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    static func triggerNotification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(type)
        }
    }
    
    static func light() {
        triggerImpact(.light)
    }
    
    static func success() {
        triggerNotification(.success)
    }
}
