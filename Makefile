# --- Configuration Variables ---
CSS_FILES = style brands reset
CSS_DIR = css
CONTENT_FILES = *.html

# --- New Targets ---

# Default target: runs installation, then optimization
all: install-deps optimize-css

# Target to install dependencies
install-deps:
	@echo "Installing global npm dependencies (purgecss and clean-css-cli)..."
	@npm install -g purgecss clean-css-cli

# Main optimization target: runs purging, minification, and cleanup
optimize-css: purge minify clean

# Step 1: Purge unused CSS for all files
purge:
	@echo "Starting CSS Purge..."
	@for file in $(CSS_FILES); do \
		echo "-> Purging $$file..."; \
		purgecss --css $(CSS_DIR)/$$file.css --content $(CONTENT_FILES) --output $(CSS_DIR)/$$file.purged.css; \
	done

# Step 2: Minify the purged CSS for all files
minify:
	@echo "Starting CSS Minification..."
	@for file in $(CSS_FILES); do \
		echo "-> Minifying $$file..."; \
		cleancss -o $(CSS_DIR)/$$file.min.css $(CSS_DIR)/$$file.purged.css; \
	done

# Step 3: Cleanup intermediate files
clean:
	@echo "Cleaning up intermediate files..."
	@rm -f $(CSS_DIR)/*.purged.css

.PHONY: all install-deps optimize-css purge minify clean