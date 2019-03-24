import PlaygroundSupport
import Dispatch

public class ASHandler {

    var work: DispatchWorkItem!

    public init() {
        work = DispatchWorkItem(block: {
            self.setStatusToNil()
        })
    }

    public func setStatusToNil() {
		PlaygroundPage.current.assessmentStatus = nil
    }

    public func setFailMessage(_ message: String, _ solution: String? = nil) {
		work?.cancel()
        setStatusToNil()
        playSound(name: "incorrect")
		PlaygroundPage.current.assessmentStatus = .fail(hints: [message], solution: solution)
	}

    public func setPassMessage(_ message: String, keepAlive: Bool = false) {
		setStatusToNil()
        playSound(name: "win")
		PlaygroundPage.current.assessmentStatus = .pass(message: message)
        
        // cancel previous dispatcher
        work?.cancel()

        if keepAlive {
            // nothing
        } else {
            work = DispatchWorkItem(block: {
                self.setStatusToNil()
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: work)
        }
	}
}