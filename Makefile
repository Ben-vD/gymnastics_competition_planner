# === Convenience combo targets ===
docker-build-run: docker-build-rstudio run-bash-rstudio
docker-rebuild-run: docker-rebuild-rstudio run-bash-rstudio

# === Full dev (RStudio) build targets ===
docker-build-rstudio:
	docker build -f Dockerfile --target final-dev --rm \
		-t rhino-sem-rstudio-dev . 2>&1 | tee build.log

docker-rebuild-rstudio:
	docker build -f Dockerfile --target final-dev --rm --no-cache \
		-t rhino-sem-rstudio-dev . 2>&1 | tee build.log

run-bash-rstudio:
	docker run --rm -p 8787:8787 \
		-v ~/.ssh:/home/rstudio/.ssh \
		-e PASSWORD=123 rhino-sem-rstudio-dev \
		bash -c "apt-get update && apt-get install -y openssh-client && /init"

# === Minimal app (no RStudio) build targets ===
docker-build-application:
	docker build -f Dockerfile --target final-app --rm \
		-t rhino-sem-app . 2>&1 | tee build.log

docker-rebuild-application:
	docker build -f Dockerfile --target final-app --rm --no-cache \
		-t rhino-sem-app . 2>&1 | tee build.log

run-application:
	docker run --rm -p 3838:3838 rhino-sem-app
