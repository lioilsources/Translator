.PHONY: test test-server test-core test-app deploy-spark

test: test-server test-core test-app

test-server:
	cd server && go vet ./... && go test -race ./...

test-core:
	cd app/packages/translator_core && dart analyze && dart test

test-app:
	cd app && flutter analyze && flutter test

# Jen kopie kódu; běh na SPARKu jde přes broker.
deploy-spark:
	rsync -az --exclude models --exclude app --exclude server ./ spark:deploy/Translator/
