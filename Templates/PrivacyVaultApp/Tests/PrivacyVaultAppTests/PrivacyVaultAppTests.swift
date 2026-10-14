import Foundation
import Testing
@testable import PrivacyVaultApp

@MainActor
@Suite("PrivacyVaultOperationsStore")
struct PrivacyVaultOperationsStoreTests {
    @Test func quickActionsCoverAlertsRecoverySharingAndAudit() {
        #expect(PrivacyVaultQuickAction.defaultActions.map(\.title) == [
            "Review Access Alerts", "Open Recovery Check", "Inspect Shared Vaults", "Run Audit Sweep"
        ])
    }

    @Test func hardeningFeaturedItemCountsItOnce() {
        let store = PrivacyVaultOperationsStore()
        let secured = store.snapshot.securedItems
        let others = Array(store.state.featuredItems.dropFirst())

        store.hardenFeaturedItem()

        #expect(store.state.featuredItems[0].status == .hardened)
        #expect(Array(store.state.featuredItems.dropFirst()) == others)
        #expect(store.snapshot.securedItems == secured + 1)
        #expect(store.state.protectionHeadline.contains("hardened"))
    }

    @Test func resolvingAlertsStopsAtZero() {
        let store = PrivacyVaultOperationsStore()
        let alerts = store.state.accessAlerts.count
        let events = store.state.auditEvents.count

        for _ in 0..<(alerts + 2) { store.resolveFirstAlert() }

        #expect(store.state.accessAlerts.isEmpty)
        #expect(store.health.accessAlerts == 0)
        #expect(store.state.auditEvents.count == events + alerts, "one audit event per resolved alert")
    }

    @Test func verifyingContactsClearsChecklistItemAndStopsWhenAllVerified() {
        let store = PrivacyVaultOperationsStore()

        store.verifyTrustedContact()
        #expect(store.state.trustedContacts.allSatisfy { $0.status == .verified })
        #expect(!store.state.recoveryChecklist.contains { $0.contains("Confirm trusted contacts") })

        let state = store.state
        store.verifyTrustedContact()
        #expect(store.state == state)
    }

    @Test func auditReviewResolvesOneCheckAtATime() {
        let store = PrivacyVaultOperationsStore()
        let pending = store.snapshot.pendingAudits
        let open = store.state.auditChecks.filter { $0.status.isOpen }.count

        store.completeAuditReview()

        let stillOpen = store.state.auditChecks.filter { $0.status.isOpen }.count
        #expect(stillOpen == open - 1)
        #expect(store.snapshot.pendingAudits == pending - 1)
    }

    @Test func pendingAuditsNeverGoNegative() {
        let store = PrivacyVaultOperationsStore()

        for _ in 0..<20 { store.completeAuditReview() }

        #expect(store.snapshot.pendingAudits >= 0)
        #expect(store.state.auditChecks.allSatisfy { !$0.status.isOpen })
    }

    @Test func rotatingRecoveryKitUpdatesSyncWindowAndScore() {
        let store = PrivacyVaultOperationsStore()

        store.rotateRecoveryWindow()

        #expect(store.health.recoveryReady)
        #expect(store.state.syncWindow.hasPrefix("Recovery package rotated"))
        #expect(!store.state.recoveryChecklist.contains { $0.contains("Verify sealed recovery kit") })
        #expect(store.state.profileMetrics.first { $0.label == "Weekly audit score" }?.value == "99%")
    }
}
