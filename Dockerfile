# Use the official Jupyter base image with Python 3.10 and scientific stack
FROM jupyter/scipy-notebook:python-3.10.12

# Work in /app
WORKDIR /app

# Install Python deps
COPY requirements.txt /app/requirements.txt
RUN pip install --quiet --no-cache-dir -r requirements.txt

# Copy project artifacts (for reproducible submission)
COPY student_dropout_fairness.ipynb /app/student_dropout_fairness.ipynb
COPY data.csv /app/data.csv
COPY metrics_comparison.csv /app/metrics_comparison.csv
COPY README.md /app/README.md

# Ensure permissions for jovyan (recommended for Jupyter stacks)
USER root
RUN chown -R jovyan:users /app
USER jovyan

EXPOSE 8888

# Start JupyterLab in /app with no token
CMD ["start-notebook.sh", \
     "--ServerApp.root_dir=/app", \
     "--ServerApp.ip=0.0.0.0", \
     "--ServerApp.open_browser=False", \
     "--ServerApp.token="]
