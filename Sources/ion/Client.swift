import Foundation
import WebRTC // @TODO MAYBE WE ABSTRACT THIS AWAY

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
    func signal(_: Signal, didReceiveTrickle trickle: Trickle) {
        guard let target = transports[trickle.target] else {
            return
        }

        target.set(remoteCandidate: RTCIceCandidate(
            sdp: trickle.candidate.candidate,
            sdpMLineIndex: Int32(trickle.candidate.sdpMLineIndex),
            sdpMid: nil
        ))
    }

    func signal(_: Signal, didReceiveDescription _: SessionDescription) {}
}

extension Client: WebRTCClientDelegate {
    func webRTCClient(_: WebRTCClient, didDiscoverLocalCandidate _: RTCIceCandidate) {}

    func webRTCClient(_: WebRTCClient, didChangeConnectionState _: RTCIceConnectionState) {}

    func webRTCClient(_: WebRTCClient, didReceiveData _: Data, onChannel _: String) {}

    func webRTCClientShouldNegotiate(_: WebRTCClient) {}
}
