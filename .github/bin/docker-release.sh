#!/bin/bash

echo "$GHCR_PASSWORD" | docker login ghcr.io -u "$GHCR_USERNAME" --password-stdin

export GHCR_PROJECT="democratic-csi"
export GHCR_REPO="ghcr.io/${GHCR_ORG,,}/${GHCR_PROJECT}"

if [[ -n "${IMAGE_TAG}" ]]; then
   # -t ${GHCR_REPO}:${IMAGE_TAG}
   docker buildx build --progress plain --pull --push --platform "${DOCKER_BUILD_PLATFORM}" -t "${GHCR_REPO}:${IMAGE_TAG}" \
      --label "org.opencontainers.image.created=$(date -u --iso-8601=seconds)" \
      --label "org.opencontainers.image.revision=${GITHUB_SHA}" \
      --build-arg OBJECTIVEFS_DOWNLOAD_ID="${OBJECTIVEFS_DOWNLOAD_ID}" \
      .
else
   :
fi
