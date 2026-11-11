import Foundation

class CopilotAuthStatusWatcher {
    static let pollInterval: TimeInterval = 30
    private var timer: Timer?

    public init(_ service: GitHubCopilotService) {
        // Capture `service` weakly at the outer Task so the inner timer closure
        // doesn't inherit an implicit strong reference from the Task.
        Task { @MainActor [weak service] in
            self.timer = Timer.scheduledTimer(withTimeInterval: Self.pollInterval, repeats: true) { _ in
                service?.updateStatusInBackground()
            }
        }
    }

    deinit {
        let t = timer
        Task { @MainActor in
            t?.invalidate()
        }
    }
}
