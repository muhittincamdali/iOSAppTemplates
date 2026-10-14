import Foundation
import Testing
@testable import CRMAdminApp

@MainActor
@Suite("CRMOperationsStore")
struct CRMOperationsStoreTests {
    private func account(_ name: String, in store: CRMOperationsStore) -> CRMAccountRecord {
        store.accounts.first { $0.name == name }!
    }

    @Test func atRiskAccountsExcludeHealthyOnes() {
        let store = CRMOperationsStore()

        #expect(Set(store.atRiskAccounts.map(\.name)) == ["Northstar Health", "Atlas Freight"])
    }

    @Test func sponsorRecoveryMovesHighRiskToWatchAndReducesRescueARR() {
        let store = CRMOperationsStore()
        let northstar = account("Northstar Health", in: store)

        store.logSponsorRecovery(northstar.id)

        #expect(account("Northstar Health", in: store).risk == .watch)
        #expect(store.rescueARR == 300_000)
    }

    @Test func rescueARRNeverGoesNegative() {
        let store = CRMOperationsStore(rescueARR: 50_000)

        store.logSponsorRecovery(account("Northstar Health", in: store).id)

        #expect(store.rescueARR == 0)
    }

    @Test func renewalPipelineEndsInSignedAndHealthyAccount() {
        let store = CRMOperationsStore()
        let renewal = store.renewals.first { $0.accountName == "Northstar Health" }!

        store.approveDiscount(renewal.id)
        #expect(store.renewals[0].stage == .commercialReview)
        store.sendProposal(renewal.id)
        #expect(store.renewals[0].stage == .proposalSent)
        store.signRenewal(renewal.id)

        #expect(store.renewals[0].stage == .signed)
        #expect(account("Northstar Health", in: store).risk == .healthy)
        #expect(!store.atRiskAccounts.contains { $0.name == "Northstar Health" })
    }

    @Test func resolvingRiskClearsAccountFromAtRiskList() {
        let store = CRMOperationsStore()

        store.resolveRisk(account("Atlas Freight", in: store).id)

        #expect(store.atRiskAccounts.map(\.name) == ["Northstar Health"])
    }

    @Test func eachExpansionAddsEightyThousandARR() {
        let store = CRMOperationsStore()
        let halcyon = account("Halcyon Capital", in: store)

        store.createExpansion(halcyon.id)
        store.createExpansion(halcyon.id)

        #expect(store.expansionARR == 610_000 + 160_000)
    }

    @Test func reassigningAndCompletingTasks() {
        let store = CRMOperationsStore()
        let task = store.tasks[0]

        store.reassignTask(task.id)
        #expect(store.tasks[0].owner == "Revenue Operations")
        #expect(store.tasks[0].status == .inFlight)

        store.completeTask(task.id)
        #expect(store.tasks[0].status == .done)
    }

    @Test func unknownIdentifiersLeaveStateUntouched() {
        let store = CRMOperationsStore()
        let headline = store.operatorHeadline

        store.logSponsorRecovery(UUID())
        store.signRenewal(UUID())
        store.completeTask(UUID())
        store.createExpansion(UUID())

        #expect(store.operatorHeadline == headline)
        #expect(store.expansionARR == 610_000)
        #expect(store.rescueARR == 420_000)
    }
}
