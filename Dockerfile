# Stage 1: dependencies
FROM rocker/r-ver:4.4.3 AS deps

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libcairo2-dev \
    libudunits2-dev \
    libgdal-dev \
    libglpk40 \
    libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy renv.lock file
COPY renv.lock renv.lock

# Install renv and restore packages
RUN R -e "options(renv.config.install.shortcuts = TRUE)"
RUN R -e "install.packages('renv', repos='https://packagemanager.posit.co/cran/2025-08-11')"
RUN R -e "renv::restore()"

# Stage 2: Full dev environment (with RStudio)
FROM rocker/rstudio:4.4.3 AS final-dev

ARG USERNAME
ARG EMAIL

ENV USER_USERNAME=${USERNAME}
ENV USER_EMAIL=${EMAIL}

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libcairo2-dev \
    libudunits2-dev \
    libgdal-dev \
    libglpk40 \
    libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

# Set RStudio theme and preferences
RUN mkdir -p /home/rstudio/.config/rstudio && \
    echo '{ \
        "editor_theme": "Tomorrow Night 80s", \
        "highlight_r_function_calls": true, \
        "rainbow_parentheses": true, \
        "font_size_points": 11 \
    }' > /home/rstudio/.config/rstudio/rstudio-prefs.json && \
    chown -R rstudio:rstudio /home/rstudio/.config

WORKDIR /home/rstudio

# Copy your entire project
COPY --chown=rstudio:rstudio . /home/rstudio/

# Copy installed packages from earlier stages
COPY --from=deps /usr/local/lib/R/site-library /usr/local/lib/R/site-library

EXPOSE 8787

# Stage 4: Minimal runtime app image (no RStudio)
FROM rocker/r-ver:4.4.3 AS final-app

RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libcairo2-dev \
    libudunits2-dev \
    libgdal-dev \
    libglpk40 \
    libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy app code
COPY . /app/

# Copy restored packages
COPY --from=deps /usr/local/lib/R/site-library /usr/local/lib/R/site-library

# Default command to run app
CMD ["R", "-e", "shiny::runApp('/app', host='0.0.0.0', port=3838)"]

EXPOSE 3838
