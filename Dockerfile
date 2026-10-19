
FROM python:3.12-slim

WORKDIR /app

# Copy only the application code into the image.
COPY app.py .

# Run as a non-root user.
RUN useradd --create-home appuser \
    && chown -R appuser:appuser /app

USER appuser

CMD ["python", "app.py"]
