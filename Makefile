.PHONY: help generate clean feature-module

TUIST := mise exec -- tuist

help:
	@echo "Available targets:"
	@echo "  make generate"
	@echo "      Install Tuist package dependencies and generate the workspace."
	@echo "  make clean"
	@echo "      Remove generated Xcode and Tuist build outputs only."
	@echo "  make feature-module NAME=NewFeature HAS_DEMO=false"
	@echo "      Scaffold a feature module with goolbitg's Project.module style."

generate:
	$(TUIST) install
	$(TUIST) generate

clean:
	find . -maxdepth 1 -name "*.xcworkspace" -type d -prune -exec rm -rf {} +
	find Projects -name "*.xcodeproj" -type d -prune -exec rm -rf {} +
	find Projects -path "*/Derived/ModuleMaps" -type d -prune -exec rm -rf {} +
	rm -rf .tuist-cache Tuist/.build

feature-module:
	@if [ -z "$(NAME)" ]; then \
		echo "Usage: make feature-module NAME=NewFeature HAS_DEMO=false"; \
		exit 1; \
	fi
	$(TUIST) scaffold FeatureModule --name $(NAME) --has-demo $(or $(HAS_DEMO),false)
