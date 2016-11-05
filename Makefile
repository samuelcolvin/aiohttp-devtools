.PHONY: install
install:
	pip install -U pip
	pip install .
	python setup.py check  # bodge to make sure livereload is downloaded
	pip install -Ur tests/requirements.txt

.PHONY: isort
isort:
	isort -rc -w 120 -sg */template/* aiohttp_devtools
	isort -rc -w 120 tests

.PHONY: lint
lint:
	python setup.py check -rms
	flake8 aiohttp_devtools/ tests/
	pytest aiohttp_devtools --isort -p no:sugar -q --cache-clear

.PHONY: test
test:
	py.test --cov=aiohttp_devtools --isort && coverage combine

.PHONY: testcov
testcov:
	py.test --cov=aiohttp_devtools --fast && (echo "building coverage html"; coverage combine; coverage html)

.PHONY: all
all: testcov lint

.PHONY: clean
clean:
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]' `
	rm -f `find . -type f -name '*~' `
	rm -f `find . -type f -name '.*~' `
	rm -rf .cache
	rm -rf htmlcov
	rm -rf *.egg-info
	rm -f .coverage
	rm -f .coverage.*
	rm -rf build
	python setup.py clean
