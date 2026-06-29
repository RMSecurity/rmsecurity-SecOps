# =============================================================================
# rmsecurity — Reporting Image
# Converts markdown + data into professional PDF and DOCX reports.
# Used by the automation engine in 03-AUTOMATION and 41-REPORTING.
# =============================================================================

FROM python:3.12-slim

LABEL org.opencontainers.image.source="https://github.com/rmsecurity/ccos"
LABEL org.opencontainers.image.description="rmsecurity report generation environment"
LABEL maintainer="rmsecurity"

RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    wkhtmltopdf \
    librsvg2-bin \
    fontconfig \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /reports

CMD ["python3", "-m", "report_engine"]
