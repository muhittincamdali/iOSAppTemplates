import Foundation
import Testing
@testable import SubscriptionLifestyleApp

@MainActor
@Suite("SubscriptionLifestyleOperationsStore")
struct SubscriptionLifestyleOperationsStoreTests {
    @Test func enrollingDraftProgram() {
        let store = SubscriptionLifestyleOperationsStore()
        let draft = store.programs.first { $0.status == .draft }!

        store.enroll(draft.id)

        #expect(store.programs.first { $0.id == draft.id }?.status == .enrolled)
        #expect(store.operatorHeadline.contains(draft.title))
    }

    @Test func completingSessionExtendsMatchingStreak() {
        let store = SubscriptionLifestyleOperationsStore()
        let program = store.programs.first { $0.title == "Wellness Streak" }!
        let streak = store.streaks.first { $0.programTitle == "Wellness Streak" }!

        store.completeSession(program.id)

        let updated = store.streaks.first { $0.id == streak.id }!
        #expect(store.programs.first { $0.id == program.id }?.status == .active)
        #expect(updated.days == streak.days + 1)
        #expect(updated.status == .healthy)
    }

    @Test func completingSessionWithoutStreakLeavesStreaksAlone() {
        let store = SubscriptionLifestyleOperationsStore()
        let program = store.programs.first { $0.title == "Premium Coaching" }!
        let streaks = store.streaks.map(\.days)

        store.completeSession(program.id)

        #expect(store.streaks.map(\.days) == streaks)
    }

    @Test func churnRiskMovesFromOfferToSaved() {
        let store = SubscriptionLifestyleOperationsStore()
        let risk = store.risks.first { $0.status == .open }!

        store.recoverRisk(risk.id)
        #expect(store.risks.first { $0.id == risk.id }?.status == .offerSent)

        store.resolveRisk(risk.id)
        #expect(store.risks.first { $0.id == risk.id }?.status == .saved)
    }

    @Test func recoveringStreakAddsTwoDays() {
        let store = SubscriptionLifestyleOperationsStore()
        let watched = store.streaks.first { $0.status == .watch }!

        store.recoverStreak(watched.id)

        #expect(store.streaks.first { $0.id == watched.id }?.days == watched.days + 2)
        #expect(store.streaks.allSatisfy { $0.status == .healthy })
    }

    @Test func switchingPlanLeavesExactlyOneCurrentPlan() {
        let store = SubscriptionLifestyleOperationsStore()
        let annual = store.plans.first { $0.name == "Annual Reset" }!

        store.switchPlan(annual.id)

        #expect(store.plans.filter(\.isCurrent).map(\.name) == ["Annual Reset"])
    }

    @Test func switchingToUnknownPlanClearsCurrentWithoutHeadline() {
        let store = SubscriptionLifestyleOperationsStore()
        let headline = store.operatorHeadline

        store.switchPlan(UUID())

        #expect(store.plans.filter(\.isCurrent).isEmpty)
        #expect(store.operatorHeadline == headline)
    }

    @Test func experimentLifecycle() {
        let store = SubscriptionLifestyleOperationsStore()
        let draft = store.experiments.first { $0.status == .draft }!

        store.launchExperiment(draft.id)
        #expect(store.experiments.first { $0.id == draft.id }?.status == .running)

        store.closeExperiment(draft.id)
        #expect(store.experiments.first { $0.id == draft.id }?.status == .won)
    }
}
