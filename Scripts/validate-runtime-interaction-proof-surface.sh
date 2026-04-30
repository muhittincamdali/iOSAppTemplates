#!/usr/bin/env bash

set -euo pipefail

grep -Fq "validate-runtime-app-interactions.sh" .github/workflows/standalone-ios-proof.yml || { echo "Workflow missing automated interaction validator call" >&2; exit 1; }
grep -Fq "validate-runtime-app-interactions.sh" README.md || { echo "README missing automated interaction validator link" >&2; exit 1; }
grep -Fq "validate-runtime-app-interactions.sh" PROJECT_STATUS.md || { echo "PROJECT_STATUS missing automated interaction validator link" >&2; exit 1; }
grep -Fq "validate-runtime-app-interactions.sh" Documentation/Proof-Matrix.md || { echo "Proof matrix missing automated interaction validator link" >&2; exit 1; }

for app in EcommerceApp SocialMediaApp ProductivityApp FinanceApp EducationApp FoodDeliveryApp TravelPlannerApp AIAssistantApp NewsBlogApp MusicPodcastApp MarketplaceApp BookingReservationsApp TeamCollaborationApp CRMAdminApp; do
  grep -Fq "$app" README.md || { echo "README missing $app automated interaction truth" >&2; exit 1; }
  grep -Fq "$app" PROJECT_STATUS.md || { echo "PROJECT_STATUS missing $app automated interaction truth" >&2; exit 1; }
  grep -Fq "$app" Documentation/Proof-Matrix.md || { echo "Proof matrix missing $app automated interaction truth" >&2; exit 1; }
done

echo "Automated runtime interaction proof surface looks good."
