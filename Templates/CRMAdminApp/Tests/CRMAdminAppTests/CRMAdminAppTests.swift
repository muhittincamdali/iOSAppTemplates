import Foundation
import Testing
@testable import CRMAdminApp

@MainActor
@Suite("CRMOperationsStore")
struct CRMOperationsStoreTests {
    private func account(_ name: String, in store: CRMOperationsStore) throws -> CRMAccountRecord {
        try #require(store.accounts.first { $0.name == name })
    }

    @Test func atRiskAccountsExcludeHealthyOnes() {
        let store = CRMOperationsStore()

        #expect(Set(store.atRiskAccounts.map(\.name)) == ["Northstar Health", "Atlas Freight"])
    }

    @Test func sponsorRecoveryMovesHighRiskToWatchAndReducesRescueARR() throws {
        let store = CRMOperationsStore()
        let northstar = try account("Northstar Health", in: store)

        store.logSponsorRecovery(northstar.id)

        #expect(try account("Northstar Health", in: store).risk == .watch)
        #expect(store.rescueARR == 300_000)
    }

    @Test func rescueARRNeverGoesNegative() throws {
        let store = CRMOperationsStore(rescueARR: 50_000)

        store.logSponsorRecovery(try account("Northstar Health", in: store).id)

        #expect(store.rescueARR == 0)
    }

    @Test func renewalPipelineEndsInSignedAndHealthyAccount() throws {
        let store = CRMOperationsStore()
        let renewal = try #require(store.renewals.first { $0.accountName == "Northstar Health" })

        store.approveDiscount(renewal.id)
        #expect(store.renewals[0].stage == .commercialReview)
        store.sendProposal(renewal.id)
        #expect(store.renewals[0].stage == .proposalSent)
        store.signRenewal(renewal.id)

        #expect(store.renewals[0].stage == .signed)
        #expect(try account("Northstar Health", in: store).risk == .healthy)
        #expect(!store.atRiskAccounts.contains { $0.name == "Northstar Health" })
    }

    @Test func resolvingRiskClearsAccountFromAtRiskList() throws {
        let store = CRMOperationsStore()

        store.resolveRisk(try account("Atlas Freight", in: store).id)

        #expect(store.atRiskAccounts.map(\.name) == ["Northstar Health"])
    }

    @Test func eachExpansionAddsEightyThousandARR() throws {
        let store = CRMOperationsStore()
        let halcyon = try account("Halcyon Capital", in: store)

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
