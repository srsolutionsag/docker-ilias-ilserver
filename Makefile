IMAGE_NAME ?= sturai/ilias-ilserver

IMAGES = 5.2/openjdk8-jre \
	5.3/openjdk8-jre \
	5.4/openjdk8-jre \
	6-beta/openjdk8-jre

LATEST = 5.4/openjdk8-jre

variant = $$(basename $1)
branch  = $$(basename $$(dirname $1))
tag     = $$(echo $1 | sed 's|/|-|')
java    = $$(echo $1 | sed -E 's|.*openjdk(.*)|\1|')

.ONESHELL:

all: $(IMAGES) tag

.PHONY: $(IMAGES)
$(IMAGES):
	@variant=$(call variant,$@)
	@branch=$(call branch,$@)
	@java=$(call java,$$variant)
	@echo "Building $(IMAGE_NAME):$$branch-$$variant"
	docker build --rm --pull \
		-f $$branch/Dockerfile \
		--build-arg JAVA_VERSION=$$java \
		-t $(IMAGE_NAME):$$branch-$$variant \
		.

.PHONY: tag
tag: $(LATEST)
	@for i in $(IMAGES); do \
		variant=$(call variant,$$i);
		branch=$(call branch,$$i);
		tag=$(call tag,$$i);
		echo "Tagging $(IMAGE_NAME):$$tag as $(IMAGE_NAME):$$branch"; \
		docker tag $(IMAGE_NAME):$$tag $(IMAGE_NAME):$$branch; \
	done
	@latest=$(IMAGE_NAME):$(call tag,$(LATEST))
	@echo "Tagging $$latest as latest"
	docker tag $$latest $(IMAGE_NAME):latest

.PHONY: push
push:
	docker push $(IMAGE_NAME)
