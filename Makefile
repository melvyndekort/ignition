.PHONY := clean serve
.DEFAULT_GOAL := convert

clean:
	@rm -rf dist

dist:
	@mkdir -p dist

dist/%.ign: src/%.bu | dist
	@echo "Converting $< to $@"
	@podman container run --rm -v $${PWD}:/pwd --workdir /pwd quay.io/coreos/butane:release --pretty --strict $< > $@

convert: $(patsubst src/%.bu,dist/%.ign,$(wildcard src/*.bu))

serve: convert
	@echo "Serving ignition files at http://localhost:80"
	@podman run --rm -p 80:80 -v $${PWD}/dist:/usr/share/nginx/html:ro nginx:alpine
