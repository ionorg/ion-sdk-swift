import Foundation

// @TODO
protocol Transport {}

class Client {
    /// The signalling client used to establish and maintain connections.
    private(set) var signal: Signal

    /// The publisher and subscriber WebRTC transports.
    private(set) var transports = [Role: Transport]()

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
    func close() {}
}

extension Client: SignalDelegate {}
