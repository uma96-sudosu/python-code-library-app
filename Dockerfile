FROM python:3.12-slim AS build
WORKDIR /app
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

FROM python:3.12-slim
WORKDIR /app
ENV PATH="/opt/venv/bin:$PATH"
RUN addgroup --system mod && adduser --system --ingroup mod uma
COPY --from=build --chown=uma:mod /opt/venv /opt/venv
COPY --from=build --chown=uma:mod /app .
USER uma
CMD ["python","app.py"]
