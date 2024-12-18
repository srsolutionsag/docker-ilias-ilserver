IMAGE_NAME ?= srsolutions/ilias-ilserver

IMAGES = \
	7/openjdk8-jre \
	7/openjdk11-jre \
	8/openjdk11-jre \
	9/openjdk11-jre \
	9/openjdk17-jre

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
	docker build --rm \
		-f $$branch/Dockerfile \
		--build-arg JAVA_VERSION=$$java \
		--build-arg ILIAS_BRANCH=$$branch \
		-t $(IMAGE_NAME):$$branch-$$variant \
		.

.PHONY: tag
tag: $(LATEST)
	for i in $(IMAGES); do \
		variant=$(call variant,$$i);
		branch=$(call branch,$$i);
		tag=$(call tag,$$i);
		echo "Tagging $(IMAGE_NAME):$$tag as $(IMAGE_NAME):$$branch"; \
		docker tag $(IMAGE_NAME):$$tag $(IMAGE_NAME):$$branch; \
	done
	latest=$(IMAGE_NAME):$(call tag,$(LATEST))
	echo "Tagging $$latest as latest"
	docker tag $$latest $(IMAGE_NAME):latest

.PHONY: push
push:
	docker push -a $(IMAGE_NAME)
