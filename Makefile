.PHONY := init plan apply clean convert
.DEFAULT_GOAL := convert

ifndef AWS_SESSION_TOKEN
	$(error Not logged in, please run 'awsume')
endif

init:
	@cd terraform && terraform init -upgrade

plan: init
	@cd terraform && terraform plan

apply: init
	@cd terraform && terraform apply

clean:
	@rm -rf dist

convert: clean
	@mkdir dist
	@for FILE in src/*.bu; do \
		IGN="$$(basename $$FILE | sed 's/.bu$$/.ign/')"; \
		docker container run --rm -it -v $${PWD}:/pwd --workdir /pwd quay.io/coreos/butane:release --pretty --strict $$FILE > dist/$$IGN; \
	done
