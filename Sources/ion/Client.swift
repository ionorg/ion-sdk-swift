import Foundation
import WebRTC // @TODO MAYBE WE ABSTRACT THIS AWAY

class Client {
    /// The signalling client used to establish and maintain connections.
    private(set) var signal: Signal

    /// The publisher and subscriber WebRTC transports.
    private(set) var transports = [Role: WebRTCClient]()

    /// The ICE servers used for WebRTC.
    private var iceServers: [RTCIceServer]

    /// Creates a new `ion` client.
    ///
    /// - Parameters:
    ///     - signal: The signalling client.
    ///     - iceServers: The WebRTC ICE servers.
    init(signal: Signal, iceServers: [RTCIceServer]) {
        self.signal = signal
        self.iceServers = iceServers
        self.signal.delegate = self
    }

    /// Joins a session.
    ///
    /// - Parameters:
    ///     - session: The id of the session.
    func join(session _: String) {
        let publisher = WebRTCClient(role: .publisher, iceServers: iceServers)

        transports[.publisher] = publisher
        transports[.subscriber] = WebRTCClient(role: .subscriber, iceServers: iceServers)

        transports.forEach { _, stream in
            stream.delegate = self
        }

        publisher.offer(completion: { result in
            switch result {
            case .failure:
                break // @TODO
            case let .success(description):
                debugPrint(description)
//                self.signal.offer(description)
            }
        })
    }

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
