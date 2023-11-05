###################################################
#################### MaRP v0.3 ####################
###################################################

# What R command should we run?
RCMD := R -q -e

# Which fields in Description should be considered as "dependencies"?
DEP_FIELDS := c("Depends", "Imports")
# This should return a valid R vector

# Get package information
PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

.PHONY: all
all: check clean

.PHONY: deps
deps:
	@Rscript -e\
   'depstring <- packageDescription(pkg = ".",\
																		lib.loc = ".",\
																		fields =$(DEP_FIELDS));\
		depstring <- Reduce(paste, Filter(\(x) !is.na(x), depstring));\
		if (!is.null(depstring)) {\
			deps <- gsub("^R \\\(>= [0-9.]+\\\)", "", depstring);\
			deps <- gsub(",\\n", ",", deps);\
			deps <- strsplit(trimws(deps), ",")[[1]];\
			for (d in deps) {\
				if (!require(d, quietly = TRUE)) {\
					cat(paste("Installing", d, "\n"));\
					install.packages(d)\
				} else {\
					cat(paste(d, "already installed\n"))\
				}\
			}\
		} else {\
			cat("No dependencies\n")\
		}'

.PHONY: document
document:
	@$(RCMD) "roxygen2::roxygenize()"

.PHONY: build
build:
	cd ..;\
	R CMD build --no-manual $(PKGSRC)

.PHONY: build-cran
build-cran:
	cd ..;\
	R CMD build $(PKGSRC)

.PHONY: test
test:
ifneq (,$(wildcard tests/tinytest.R))
	@$(RCMD) "tinytest::build_install_test('.')"
endif
ifneq (,$(wildcard tests/testthat.R))
	@$(RCMD) "testthat::test_package('.')"
endif

.PHONY: install
install: build
	cd ..;\
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

.PHONY: build-cran
check: build-cran
	cd ..;\
	R CMD check $(PKGNAME)_$(PKGVERS).tar.gz --as-cran

.PHONY: vignettes
vignettes:
	@echo NYI

.PHONY: clean
clean:
	cd ..;\
	$(RM) -r $(PKGNAME).Rcheck/ $(PKGNAME)_$(PKGVERS).tar.gz

### Uncomment to enable these features
# .PHONY: coverage
# coverage:
# 	@$(RCMD) "covr::report(file = 'coverage.html', browse = TRUE)"

# .PHONY: goodpractice
# goodpractice:
# 	@$(RCMD) "goodpractice::gp('.')"

# .PHONY: check_win_old
# check_win_old:        # Check & build on win-builder old release
# 	@echo NYI

# .PHONY: check_win
# check_win:            # ... on win-builder release
# 	@echo NYI

# .PHONY: check_win_dev
# check_win_dev:        # ... on win-builder dev
# 	@echo NYI
