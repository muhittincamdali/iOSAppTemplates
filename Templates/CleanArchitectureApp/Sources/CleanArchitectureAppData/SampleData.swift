import Foundation

extension SampleServer {
    /// The directory the sample server starts with. Two admins, three moderators, two
    /// inactive accounts, and names with diacritics to exercise search.
    public static let seedUsers: [UserDTO] = [
        seed(1, "Ada Lovelace", "ada.lovelace", "admin", joined: "2023-01-09"),
        seed(2, "Grace Hopper", "grace.hopper", "admin", joined: "2023-02-14"),
        seed(3, "Alan Turing", "alan.turing", "moderator", joined: "2023-05-02"),
        seed(4, "Zoë Martin", "zoe.martin", "member", joined: "2024-06-18"),
        seed(5, "Ömer Yılmaz", "omer.yilmaz", "member", joined: "2024-09-03"),
        seed(6, "José García", "jose.garcia", "moderator", joined: "2024-01-22"),
        seed(7, "Mei Chen", "mei.chen", "member", joined: "2025-03-11"),
        seed(8, "Priya Raman", "priya.raman", "member", joined: "2025-07-30"),
        seed(9, "Lars Eriksson", "lars.eriksson", "member", joined: "2023-11-05", active: false),
        seed(10, "Amara Okafor", "amara.okafor", "member", joined: "2026-02-17"),
        seed(11, "Kenji Watanabe", "kenji.watanabe", "member", joined: "2024-04-08", active: false),
        seed(12, "Sofia Rossi", "sofia.rossi", "moderator", joined: "2025-10-01")
    ]

    /// `00000000-0000-0000-0000-0000000000NN`, so ids stay the same on every launch.
    public static func seedID(_ number: UInt8) -> UUID {
        UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, number))
    }

    private static func seed(
        _ number: UInt8,
        _ name: String,
        _ mailbox: String,
        _ role: String,
        joined day: String,
        active: Bool = true
    ) -> UserDTO {
        let joinedAt = (try? Date("\(day)T09:00:00Z", strategy: .iso8601)) ?? .distantPast
        return UserDTO(
            id: seedID(number),
            fullName: name,
            email: "\(mailbox)@example.com",
            role: role,
            isActive: active,
            joinedAt: joinedAt
        )
    }
}
