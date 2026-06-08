WORKSPACES := $(patsubst %/pyproject.toml,%,$(wildcard */pyproject.toml))

.PHONY: sync bump-dlthub-client bump-dlt $(WORKSPACES)

sync: $(WORKSPACES)

$(WORKSPACES):
	@echo "==> uv sync in $@"
	cd $@ && uv sync

# Bump the locked dlthub-client package to a specific version across all workspaces.
# Usage: make bump-dlthub-client VERSION=0.28.0
bump-dlthub-client:
	@test -n "$(VERSION)" || { echo "VERSION is required, e.g. make bump-dlthub-client VERSION=0.28.0"; exit 1; }
	@for ws in $(WORKSPACES); do \
		echo "==> bump dlthub-client to $(VERSION) in $$ws"; \
		(cd $$ws && uv lock --upgrade-package "dlthub-client==$(VERSION)"); \
	done

# Bump the locked dlt package to a specific version across all workspaces.
# Usage: make bump-dlt VERSION=1.28.0
bump-dlt:
	@test -n "$(VERSION)" || { echo "VERSION is required, e.g. make bump-dlt VERSION=1.28.0"; exit 1; }
	@for ws in $(WORKSPACES); do \
		echo "==> bump dlt to $(VERSION) in $$ws"; \
		(cd $$ws && uv lock --upgrade-package "dlt==$(VERSION)"); \
	done
