import Foundation

class Client {
    /// The signalling client used to establish and maintain connections.
    private(set) var signal: Signal

    /// The publisher and subscriber WebRTC transports.
    private(set) var transports = [Role: WebRTCClient]()

    /// Creates a new `ion` client.
    ///
    /// - Parameters:
    ///     - signal: The signalling client.
    init(signal: Signal) {
        self.signal = signal
        self.signal.delegate = self
    }

    /// Joins a session.
    ///
    /// - Parameters:
    ///     - session: The id of the session.
    func join(session _: String) {}

    /// Closes the connection.
    func close() {
        signal.close()

        transports.forEach { _, transport in
            transport.delegate = nil
            transport.close()
        }
    }
}

extension Client: SignalDelegate {
    func signal(_: Signal, didReceiveTrickle _: Trickle) {}

    func signal(_: Signal, didReceiveDescription _: SessionDescription) {}
}
