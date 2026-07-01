FROM mcr.microsoft.com/devcontainers/python:3.12

# Install AWS CLI v2 (not available via pip — use official binary)
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
    && unzip /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install \
    && rm -rf /tmp/awscliv2.zip /tmp/aws

# Copy and install Python dependencies
# Airflow has strict transitive constraints — install it first so pip resolves correctly
COPY requirements.txt /tmp/pip-tmp/requirements.txt
RUN pip3 --disable-pip-version-check --no-cache-dir install apache-airflow[snowflake,amazon] \
    && pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp
