# Default environment
HUGO_ENVIRONMENT ?= production

# Hugo build command
HUGO_BUILD = HUGO_ENVIRONMENT=$(HUGO_ENVIRONMENT) hugo --gc --minify

# Hugo serve command
HUGO_SERVE = HUGO_ENVIRONMENT=$(HUGO_ENVIRONMENT) hugo server

# Pagefind command
PAGEFIND = npx pagefind --source "public"

.PHONY: init
init:
	@echo "Initializing git submodules..."
	git submodule init
	git submodule update

.PHONY: build
build:
	@echo "Building site with Hugo (environment: $(HUGO_ENVIRONMENT))..."
	$(HUGO_BUILD)
	@echo "Running Pagefind..."
	$(PAGEFIND)

.PHONY: serve
serve: build
	@echo "Starting Hugo server (environment: $(HUGO_ENVIRONMENT))..."
	$(HUGO_SERVE)

.PHONY: build-production
build-production:
	@$(MAKE) build HUGO_ENVIRONMENT=production

.PHONY: build-local
build-local:
	@$(MAKE) build HUGO_ENVIRONMENT=local

.PHONY: serve-production
serve-production:
	@$(MAKE) serve HUGO_ENVIRONMENT=production

.PHONY: serve-local
serve-local:
	@$(MAKE) serve HUGO_ENVIRONMENT=local

.PHONY: deploy-preview
deploy-preview:
	@echo "Building site for Netlify preview deployment..."
	HUGO_ENVIRONMENT=$(HUGO_ENVIRONMENT) hugo --gc --minify -b $(DEPLOY_PRIME_URL)
	@echo "Running Pagefind..."
	$(PAGEFIND)

.PHONY: clean
clean:
	@echo "Cleaning up generated files..."
	rm -rf public
	rm -rf resources

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  init               : Initialize git submodules"
	@echo "  build              : Build Hugo site and run Pagefind indexing"
	@echo "  serve              : Build site, run Pagefind, then start Hugo server"
	@echo "  build-production   : Build site in production environment"
	@echo "  build-local        : Build site in local environment"
	@echo "  serve-production   : Build and serve site in production environment"
	@echo "  serve-local        : Build and serve site in local environment"
	@echo "  deploy-preview     : Build site for Netlify preview deployment"
	@echo "  clean              : Remove generated files"
	@echo ""
	@echo "You can also set the environment directly:"
	@echo "  make build HUGO_ENVIRONMENT=production"
	@echo "  make serve HUGO_ENVIRONMENT=local"
	@echo ""
	@echo "After cloning the repository, run 'make init' to set up git submodules."
	@echo "For Netlify preview deployments, use 'make deploy-preview'."
