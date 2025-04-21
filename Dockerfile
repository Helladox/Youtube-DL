FROM python:3.12-alpine

# Install system dependencies
RUN apk add ffmpeg --no-cache

# Install python dependencies
WORKDIR /app
COPY ./requirements.txt .
RUN pip install --upgrade pip -r requirements.txt

# Add volumes for performance with io intensive operations
VOLUME /app/logs
VOLUME /app/temp

# Copy app
COPY telegram_youtube_downloader /app/telegram_youtube_downloader

# Run
CMD gunicorn app:app & python -m telegram_youtube_downloader
