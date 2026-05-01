import Foundation
import SwiftUI
import PrivacyVaultAppCore

private enum PrivacyVaultInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "PrivacyVaultApp",
            "status": "completed",
            "summary": summary,
            "steps": steps,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        guard JSONSerialization.isValidJSONObject(payload),
              let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys]) else {
            return
        }

        try? data.write(to: documentsURL.appendingPathComponent("interaction-proof.json"), options: [.atomic])
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct PrivacyVaultAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            PrivacyVaultWorkspaceRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultWorkspaceRootView: View {
    @StateObject private var store = PrivacyVaultOperationsStore()

    var body: some View {
        TabView {
            PrivacyVaultHomeView(
                snapshot: store.snapshot,
                collections: store.collections,
                actions: store.actions,
                health: store.health,
                state: store.state
            )
            .tabItem {
                Image(systemName: "lock.doc.fill")
                Text("Vault")
            }

            PrivacyVaultAlertsView(state: store.state)
                .tabItem {
                    Image(systemName: "bell.badge.fill")
                    Text("Alerts")
                }

            PrivacyVaultRecoveryView(state: store.state)
                .tabItem {
                    Image(systemName: "key.horizontal.fill")
                    Text("Recovery")
                }

            PrivacyVaultAuditView(state: store.state)
                .tabItem {
                    Image(systemName: "checkmark.shield.fill")
                    Text("Audit")
                }

            PrivacyVaultProfileView(snapshot: store.snapshot, health: store.health, state: store.state)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.teal)
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class PrivacyVaultOperationsStore: ObservableObject {
    @Published var snapshot = PrivacyVaultDashboardSnapshot.sample
    @Published var collections = PrivacyVaultCollectionCard.sampleCards
    @Published var actions = PrivacyVaultQuickAction.defaultActions
    @Published var health = PrivacyVaultOperationalHealth.sample
    @Published var state = PrivacyVaultWorkspaceState.sample

    private var interactionProofScheduled = false

    func runInteractionProofIfNeeded() {
        guard PrivacyVaultInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        DispatchQueue.main.async {
            var steps: [String] = []

            self.hardenFeaturedItem()
            steps.append("Hardened featured item")

            self.resolveFirstAlert()
            steps.append("Resolved first access alert")

            self.verifyTrustedContact()
            steps.append("Verified trusted contact")

            self.completeAuditReview()
            steps.append("Completed audit review")

            self.rotateRecoveryWindow()
            steps.append("Rotated recovery window")

            PrivacyVaultInteractionProofMode.write(
                summary: self.state.protectionHeadline,
                steps: steps
            )
        }
    }

    private func hardenFeaturedItem() {
        guard let item = state.featuredItems.first else { return }
        let updatedItems = state.featuredItems.enumerated().map { index, current in
            if index == 0 {
                return PrivacyVaultItem(
                    id: current.id,
                    title: current.title,
                    category: current.category,
                    owner: current.owner,
                    status: "Hardened",
                    summary: "Recovery package rotated and reveal rules tightened for the next secure sync window.",
                    nextStep: "Keep the hardened bundle sealed until the next travel readiness review.",
                    statusColorName: "green"
                )
            }
            return current
        }

        snapshot = PrivacyVaultDashboardSnapshot(
            securedItems: snapshot.securedItems + 1,
            pendingAudits: snapshot.pendingAudits,
            sharedVaults: snapshot.sharedVaults,
            protectionHealth: "Featured vault item hardened and ready for the next secure sync."
        )

        replaceState(
            protectionHeadline: "\(item.title) is now hardened and ready for controlled reveal.",
            featuredItems: updatedItems
        )
    }

    private func resolveFirstAlert() {
        guard !state.accessAlerts.isEmpty else { return }
        let updatedAlerts = Array(state.accessAlerts.dropFirst())

        health = PrivacyVaultOperationalHealth(
            accessAlerts: max(0, health.accessAlerts - 1),
            medianUnlockSeconds: health.medianUnlockSeconds,
            recoveryReady: health.recoveryReady
        )

        replaceState(
            accessAlerts: updatedAlerts,
            auditEvents: [
                "Access alert resolved and session trust restored."
            ] + state.auditEvents,
            trustNotes: [
                "Latest suspicious session was reviewed and closed before the current sync window."
            ] + state.trustNotes
        )
    }

    private func verifyTrustedContact() {
        guard let index = state.trustedContacts.firstIndex(where: { $0.status != "Verified" }) else { return }
        var contacts = state.trustedContacts
        let current = contacts[index]
        contacts[index] = PrivacyVaultTrustedContact(
            id: current.id,
            name: current.name,
            role: current.role,
            status: "Verified"
        )

        replaceState(
            recoveryChecklist: state.recoveryChecklist.filter { !$0.contains("Confirm trusted contacts") },
            trustedContacts: contacts
        )
    }

    private func completeAuditReview() {
        guard let index = state.auditChecks.firstIndex(where: { $0.status != "Resolved" && $0.status != "Complete" }) else { return }
        var checks = state.auditChecks
        let current = checks[index]
        checks[index] = PrivacyVaultAuditCheck(
            id: current.id,
            title: current.title,
            status: "Resolved",
            summary: "Quarterly review cleared and linked grants recertified.",
            nextStep: "Monitor until the next weekly audit sweep.",
            statusColorName: "green"
        )

        snapshot = PrivacyVaultDashboardSnapshot(
            securedItems: snapshot.securedItems,
            pendingAudits: max(0, snapshot.pendingAudits - 1),
            sharedVaults: snapshot.sharedVaults,
            protectionHealth: snapshot.protectionHealth
        )

        replaceState(
            auditChecks: checks,
            auditEvents: [
                "Audit queue item resolved and logged for the weekly control review."
            ] + state.auditEvents
        )
    }

    private func rotateRecoveryWindow() {
        health = PrivacyVaultOperationalHealth(
            accessAlerts: health.accessAlerts,
            medianUnlockSeconds: health.medianUnlockSeconds,
            recoveryReady: true
        )

        replaceState(
            syncWindow: "Recovery package rotated • next encrypted sync in 12 minutes",
            recoveryChecklist: state.recoveryChecklist.filter { !$0.contains("Verify sealed recovery kit") },
            profileMetrics: state.profileMetrics.map { metric in
                if metric.label == "Weekly audit score" {
                    return PrivacyVaultMetric(label: metric.label, value: "99%")
                }
                return metric
            }
        )
    }

    private func replaceState(
        protectionHeadline: String? = nil,
        syncWindow: String? = nil,
        featuredItems: [PrivacyVaultItem]? = nil,
        accessAlerts: [PrivacyVaultAccessAlert]? = nil,
        recoveryChecklist: [String]? = nil,
        trustedContacts: [PrivacyVaultTrustedContact]? = nil,
        auditChecks: [PrivacyVaultAuditCheck]? = nil,
        auditEvents: [String]? = nil,
        trustNotes: [String]? = nil,
        profileMetrics: [PrivacyVaultMetric]? = nil
    ) {
        state = PrivacyVaultWorkspaceState(
            protectionHeadline: protectionHeadline ?? state.protectionHeadline,
            biometricPolicy: state.biometricPolicy,
            syncWindow: syncWindow ?? state.syncWindow,
            operatorName: state.operatorName,
            roleSummary: state.roleSummary,
            featuredItems: featuredItems ?? state.featuredItems,
            accessAlerts: accessAlerts ?? state.accessAlerts,
            recoveryChecklist: recoveryChecklist ?? state.recoveryChecklist,
            trustedContacts: trustedContacts ?? state.trustedContacts,
            auditChecks: auditChecks ?? state.auditChecks,
            auditEvents: auditEvents ?? state.auditEvents,
            trustNotes: trustNotes ?? state.trustNotes,
            profileMetrics: profileMetrics ?? state.profileMetrics
        )
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultHomeView: View {
    let snapshot: PrivacyVaultDashboardSnapshot
    let collections: [PrivacyVaultCollectionCard]
    let actions: [PrivacyVaultQuickAction]
    let health: PrivacyVaultOperationalHealth
    let state: PrivacyVaultWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    PrivacyVaultHeroCard(snapshot: snapshot, health: health, state: state)
                    PrivacyVaultQuickActionGrid(actions: actions)
                    PrivacyVaultSensitiveItemsCard(items: state.featuredItems)
                    PrivacyVaultCollectionsCard(collections: collections)
                    PrivacyVaultTrustCard(state: state, health: health)
                }
                .padding(16)
            }
            .navigationTitle("Vault")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultHeroCard: View {
    let snapshot: PrivacyVaultDashboardSnapshot
    let health: PrivacyVaultOperationalHealth
    let state: PrivacyVaultWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Protection Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(state.protectionHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(snapshot.protectionHealth)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                PrivacyVaultMetricChip(title: "Secured", value: "\(snapshot.securedItems)")
                PrivacyVaultMetricChip(title: "Audits", value: "\(snapshot.pendingAudits)")
                PrivacyVaultMetricChip(title: "Shared", value: "\(snapshot.sharedVaults)")
            }

            HStack {
                Label(state.biometricPolicy, systemImage: "faceid")
                Spacer()
                Text(state.syncWindow)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.teal)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.teal.opacity(0.16), .blue.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultMetricChip: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultQuickActionGrid: View {
    let actions: [PrivacyVaultQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.teal)
                        Text(action.title)
                            .font(.subheadline.weight(.semibold))
                        Text(action.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultSensitiveItemsCard: View {
    let items: [PrivacyVaultItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Critical Items")
                .font(.title3.weight(.bold))

            ForEach(items) { item in
                NavigationLink {
                    PrivacyVaultItemDetailView(item: item)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text("\(item.category) - \(item.owner)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(item.status)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(item.statusColor)
                        }
                        Text(item.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultCollectionsCard: View {
    let collections: [PrivacyVaultCollectionCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Vault Lanes")
                .font(.title3.weight(.bold))

            ForEach(collections) { collection in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(collection.title)
                            .font(.headline)
                        Text(collection.ctaLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(collection.itemCount)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.teal)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultTrustCard: View {
    let state: PrivacyVaultWorkspaceState
    let health: PrivacyVaultOperationalHealth

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trust Signals")
                .font(.title3.weight(.bold))

            HStack(spacing: 12) {
                PrivacyVaultOperationTile(title: "Alerts", value: "\(health.accessAlerts)")
                PrivacyVaultOperationTile(title: "Unlock", value: "\(health.medianUnlockSeconds)s")
                PrivacyVaultOperationTile(title: "Recovery", value: health.recoveryReady ? "Ready" : "Review")
            }

            ForEach(state.trustNotes, id: \.self) { note in
                Label(note, systemImage: "arrow.right.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultOperationTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.headline.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultAlertsView: View {
    let state: PrivacyVaultWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.accessAlerts) { alert in
                    NavigationLink {
                        PrivacyVaultAlertDetailView(alert: alert)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(alert.title)
                                Spacer()
                                Text(alert.severity)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(alert.severityColor)
                            }
                            Text(alert.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(alert.timestamp)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Alerts")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultRecoveryView: View {
    let state: PrivacyVaultWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Recovery Checklist") {
                    ForEach(state.recoveryChecklist, id: \.self) { step in
                        Label(step, systemImage: "checkmark.circle")
                    }
                }

                Section("Trusted Contacts") {
                    ForEach(state.trustedContacts) { contact in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(contact.name)
                            Text("\(contact.role) - \(contact.status)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Recovery")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultAuditView: View {
    let state: PrivacyVaultWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Audit Queue") {
                    ForEach(state.auditChecks) { check in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(check.title)
                                Spacer()
                                Text(check.status)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(check.statusColor)
                            }
                            Text(check.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(check.nextStep)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Recent Vault Events") {
                    ForEach(state.auditEvents, id: \.self) { event in
                        Label(event, systemImage: "clock.arrow.circlepath")
                    }
                }
            }
            .navigationTitle("Audit")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultProfileView: View {
    let snapshot: PrivacyVaultDashboardSnapshot
    let health: PrivacyVaultOperationalHealth
    let state: PrivacyVaultWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(state.operatorName)
                            .font(.headline)
                        Text(state.roleSummary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Label(state.biometricPolicy, systemImage: "person.badge.shield.checkmark")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Protection Health") {
                    Label("Secured items: \(snapshot.securedItems)", systemImage: "lock.fill")
                    Label("Pending audits: \(snapshot.pendingAudits)", systemImage: "checkmark.shield.fill")
                    Label("Recovery ready: \(health.recoveryReady ? "Yes" : "No")", systemImage: "key.horizontal.fill")
                }

                Section("Metrics") {
                    ForEach(state.profileMetrics, id: \.label) { metric in
                        HStack {
                            Text(metric.label)
                            Spacer()
                            Text(metric.value)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.teal)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultItemDetailView: View {
    let item: PrivacyVaultItem

    var body: some View {
        List {
            Section("Vault Item") {
                Text(item.title)
                    .font(.headline)
                Text(item.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Security") {
                Label(item.category, systemImage: "folder.fill")
                Label(item.owner, systemImage: "person.fill")
                Label(item.status, systemImage: "shield.lefthalf.filled")
            }

            Section("Next Step") {
                Text(item.nextStep)
                    .font(.body)
            }
        }
        .navigationTitle(item.title)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct PrivacyVaultAlertDetailView: View {
    let alert: PrivacyVaultAccessAlert

    var body: some View {
        List {
            Section("Alert") {
                Text(alert.title)
                    .font(.headline)
                Text(alert.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Signal") {
                Label(alert.severity, systemImage: "exclamationmark.triangle.fill")
                Label(alert.timestamp, systemImage: "clock.fill")
                Label(alert.origin, systemImage: "location.fill")
            }

            Section("Action") {
                Text(alert.nextStep)
                    .font(.body)
            }
        }
        .navigationTitle("Alert")
    }
}

public struct PrivacyVaultQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let systemImage: String
    public let detail: String

    public init(
        id: UUID = UUID(),
        title: String,
        systemImage: String,
        detail: String
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.detail = detail
    }

    public static let defaultActions: [PrivacyVaultQuickAction] = [
        PrivacyVaultQuickAction(
            title: "Review Access Alerts",
            systemImage: "shield.lefthalf.filled.badge.checkmark",
            detail: "Inspect unusual unlock attempts, new-device access and recently revoked sessions."
        ),
        PrivacyVaultQuickAction(
            title: "Open Recovery Check",
            systemImage: "key.horizontal.fill",
            detail: "Verify trusted contacts, emergency kit rotation and sealed recovery package status."
        ),
        PrivacyVaultQuickAction(
            title: "Inspect Shared Vaults",
            systemImage: "person.crop.rectangle.stack.fill",
            detail: "Audit who can reveal family, legal and business vault items before the next sync window."
        ),
        PrivacyVaultQuickAction(
            title: "Run Audit Sweep",
            systemImage: "checkmark.shield.fill",
            detail: "Clear the weekly review queue for policy drift, stale grants and long-idle secrets."
        )
    ]
}

struct PrivacyVaultWorkspaceState: Hashable, Sendable {
    let protectionHeadline: String
    let biometricPolicy: String
    let syncWindow: String
    let operatorName: String
    let roleSummary: String
    let featuredItems: [PrivacyVaultItem]
    let accessAlerts: [PrivacyVaultAccessAlert]
    let recoveryChecklist: [String]
    let trustedContacts: [PrivacyVaultTrustedContact]
    let auditChecks: [PrivacyVaultAuditCheck]
    let auditEvents: [String]
    let trustNotes: [String]
    let profileMetrics: [PrivacyVaultMetric]

    static let sample = PrivacyVaultWorkspaceState(
        protectionHeadline: "Vault integrity is healthy, but family-share access and one travel unlock need review today.",
        biometricPolicy: "Face ID required for all sensitive reveals",
        syncWindow: "Next encrypted sync in 42 minutes",
        operatorName: "Maren Cole",
        roleSummary: "Security operations lead for private vault lifecycle, recovery policy and audit readiness",
        featuredItems: [
            PrivacyVaultItem(
                title: "Executive Passport Bundle",
                category: "Identity Vault",
                owner: "Maren Cole",
                status: "Protected",
                summary: "Primary travel identity pack with border-control docs, visas and emergency copies.",
                nextStep: "Rotate the sealed backup package before the June travel window.",
                statusColorName: "green"
            ),
            PrivacyVaultItem(
                title: "Family Medical Archive",
                category: "Document Safe",
                owner: "Shared Family Vault",
                status: "Review",
                summary: "One trusted-contact grant changed after the last recovery rehearsal.",
                nextStep: "Confirm the updated family contact list and re-run access acknowledgment.",
                statusColorName: "orange"
            ),
            PrivacyVaultItem(
                title: "Board Cap Table Export",
                category: "Business Vault",
                owner: "Finance Team",
                status: "Sensitive",
                summary: "Board-ready ownership export with limited reveal rules and quarterly expiry.",
                nextStep: "Expire last quarter's contractor link and issue a fresh board-only share.",
                statusColorName: "red"
            )
        ],
        accessAlerts: [
            PrivacyVaultAccessAlert(
                title: "New device attempted vault reveal",
                severity: "High",
                summary: "A first-time device requested reveal access for the family medical archive.",
                timestamp: "Today 09:12",
                origin: "Berlin, DE",
                nextStep: "Confirm owner identity and revoke session if the request stays unverified.",
                severityColorName: "red"
            ),
            PrivacyVaultAccessAlert(
                title: "Travel unlock exceeded normal duration",
                severity: "Watch",
                summary: "An airport unlock session stayed open longer than the normal secure window.",
                timestamp: "Today 06:45",
                origin: "AMS Airport",
                nextStep: "Review the unlock log and shorten the travel policy timeout if needed.",
                severityColorName: "orange"
            )
        ],
        recoveryChecklist: [
            "Confirm trusted contacts completed identity refresh this month.",
            "Verify sealed recovery kit storage location and checksum match.",
            "Test emergency restore instructions with the latest policy version.",
            "Reconfirm the family vault disclosure ladder."
        ],
        trustedContacts: [
            PrivacyVaultTrustedContact(name: "Lina Brooks", role: "Primary family contact", status: "Verified"),
            PrivacyVaultTrustedContact(name: "Dev Patel", role: "Legal executor", status: "Awaiting acknowledgement"),
            PrivacyVaultTrustedContact(name: "Ava Stone", role: "Business continuity contact", status: "Verified")
        ],
        auditChecks: [
            PrivacyVaultAuditCheck(
                title: "Shared grant recertification",
                status: "In Review",
                summary: "Three shared-vault links are due for quarterly approval.",
                nextStep: "Collect owner approval before tomorrow's sync cycle.",
                statusColorName: "orange"
            ),
            PrivacyVaultAuditCheck(
                title: "Dormant secret cleanup",
                status: "Ready",
                summary: "Two deprecated API credentials remain in the business vault.",
                nextStep: "Archive the old credentials and replace linked references.",
                statusColorName: "green"
            ),
            PrivacyVaultAuditCheck(
                title: "Sensitive export verification",
                status: "Action Needed",
                summary: "A board-export package is still accessible to one expired contractor account.",
                nextStep: "Revoke the share and append the event to the audit log.",
                statusColorName: "red"
            )
        ],
        auditEvents: [
            "Weekly audit sweep completed with 96% policy compliance.",
            "Trusted contact rehearsal finished in 11 minutes.",
            "Two inactive reveal sessions auto-revoked overnight."
        ],
        trustNotes: [
            "Family vault grants are reviewed every Sunday before the encrypted sync window.",
            "Business-vault exports now expire automatically after seven days.",
            "Recovery rehearsal success rate stayed above target for the last five cycles."
        ],
        profileMetrics: [
            PrivacyVaultMetric(label: "Protected collections", value: "11"),
            PrivacyVaultMetric(label: "Trusted contacts", value: "7"),
            PrivacyVaultMetric(label: "Weekly audit score", value: "96%")
        ]
    )
}

struct PrivacyVaultItem: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let category: String
    let owner: String
    let status: String
    let summary: String
    let nextStep: String
    let statusColorName: String

    init(
        id: UUID = UUID(),
        title: String,
        category: String,
        owner: String,
        status: String,
        summary: String,
        nextStep: String,
        statusColorName: String
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.owner = owner
        self.status = status
        self.summary = summary
        self.nextStep = nextStep
        self.statusColorName = statusColorName
    }

    var statusColor: Color {
        switch statusColorName {
        case "red":
            return .red
        case "orange":
            return .orange
        default:
            return .green
        }
    }
}

struct PrivacyVaultAccessAlert: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let severity: String
    let summary: String
    let timestamp: String
    let origin: String
    let nextStep: String
    let severityColorName: String

    init(
        id: UUID = UUID(),
        title: String,
        severity: String,
        summary: String,
        timestamp: String,
        origin: String,
        nextStep: String,
        severityColorName: String
    ) {
        self.id = id
        self.title = title
        self.severity = severity
        self.summary = summary
        self.timestamp = timestamp
        self.origin = origin
        self.nextStep = nextStep
        self.severityColorName = severityColorName
    }

    var severityColor: Color {
        switch severityColorName {
        case "red":
            return .red
        case "orange":
            return .orange
        default:
            return .green
        }
    }
}

struct PrivacyVaultTrustedContact: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let role: String
    let status: String

    init(
        id: UUID = UUID(),
        name: String,
        role: String,
        status: String
    ) {
        self.id = id
        self.name = name
        self.role = role
        self.status = status
    }
}

struct PrivacyVaultAuditCheck: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let status: String
    let summary: String
    let nextStep: String
    let statusColorName: String

    init(
        id: UUID = UUID(),
        title: String,
        status: String,
        summary: String,
        nextStep: String,
        statusColorName: String
    ) {
        self.id = id
        self.title = title
        self.status = status
        self.summary = summary
        self.nextStep = nextStep
        self.statusColorName = statusColorName
    }

    var statusColor: Color {
        switch statusColorName {
        case "red":
            return .red
        case "orange":
            return .orange
        default:
            return .green
        }
    }
}

struct PrivacyVaultMetric: Hashable, Sendable {
    let label: String
    let value: String
}
