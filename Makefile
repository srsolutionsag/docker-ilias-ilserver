IMAGE_NAME ?= srsolutions/ilias-ilserver

PLATFORM ?= linux/amd64,linux/arm64
OUTPUT ?= type=image,push=true

IMAGES = \
	8/openjdk11-jre \
	9/openjdk11-jre \
	9/openjdk17-jre \
	10-beta/openjdk11 \
	10-beta/openjdk17 \
	10-beta/openjdk21

LATEST = 9/openjdk17-jre

variant = $$(basename $1)
branch  = $$(basename $$(dirname $1))
tag     = $$(echo $1 | sed 's|/|-|')
java    = $$(echo $1 | sed -E 's|.*openjdk(.*)|\1|')

.ONESHELL:
.SILENT:

all: $(IMAGES) tag

.PHONY: $(IMAGES)
$(IMAGES):
	variant=$(call variant,$@)
	branch=$(call branch,$@)
	java=$(call java,$$variant)
	echo "Pulling image eclipse-temurin:$$java"
	docker pull eclipse-temurin:$$java
	echo "Building $(IMAGE_NAME):$$branch-$$variant"
	docker buildx build --platform $(PLATFORM) --pull \
		-f $$branch/Dockerfile \
		--build-arg JAVA_VERSION=$$java \
		--build-arg ILIAS_BRANCH=$$branch \
		-t $(IMAGE_NAME):$$branch-$$variant \
		--output $(OUTPUT) \
		.

.PHONY: tag
tag:
	tag () {
		case "${OUTPUT}" in
			*push=false*)
				docker tag $$1 $$2
				;;
			*push=true*)
				docker buildx imagetools create $$1 --tag $$2
				;;
		esac
	}
	for i in $(IMAGES); do \
		variant=$(call variant,$$i);
		branch=$(call branch,$$i);
		tag=$(call tag,$$i);
		echo "Tagging $(IMAGE_NAME):$$tag as $(IMAGE_NAME):$$branch"; \
		tag $(IMAGE_NAME):$$tag $(IMAGE_NAME):$$branch; \
	done
	latest=$(IMAGE_NAME):$(call tag,$(LATEST))
	echo "Tagging $$latest as latest"
	tag $$latest $(IMAGE_NAME):latest

local: PLATFORM=local
local: export BUILDX_BUILDER=default
local: OUTPUT=type=image,push=false
local: all

.PHONY: pull
pull:
	for i in $(IMAGES); do \
		variant=$(call variant,$$i);
		branch=$(call branch,$$i);
		tag=$(call tag,$$i);
		echo "Pulling $(IMAGE_NAME):$$tag"; \
		docker pull $(IMAGE_NAME):$$tag; \
		echo "Pulling $(IMAGE_NAME):$$branch"; \
		docker pull $(IMAGE_NAME):$$branch; \
	done
	echo "Pulling $(IMAGE_NAME):latest"
	docker pull $(IMAGE_NAME):latest
