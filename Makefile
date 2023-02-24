.PHONY := init plan apply clean convert
.DEFAULT_GOAL := convert

init:
	ifndef AWS_SESSION_TOKEN
		$(error Not logged in, please run 'awsume')
	endif
	@cd terraform && terraform init -upgrade

plan: init
	@cd terraform && terraform plan

apply: init
	@cd terraform && terraform apply

clean:
	@rm -rf target

convert: clean
	@mkdir target
	@for FILE in src/*.bu; do \
		IGN="$$(basename $$FILE | sed 's/.bu$$/.ign/')"; \
		docker container run --rm -it -v $${PWD}:/pwd --workdir /pwd quay.io/coreos/butane:release --pretty --strict $$FILE > target/$$IGN; \
	done
