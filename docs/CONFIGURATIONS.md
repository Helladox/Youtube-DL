# Configurations

---

## Table of contents
- [Set config via env](#set-config-via-env)
- [logger_options](#logger_options)
- [telegram_bot_options](#telegram_bot_options)
    - [base_url](#base_url)
    - [default_command](#default_command)
    - [authorization_options](#authorization_options)
- [youtube_search_options](#youtube_search_options)
- [youtube_downloader_options](#youtube_downloader_options)
    - [audio_options and video_options](#audio_options-and-video_options)
    - [allowed_url_patterns](#allowed_url_patterns)
    - [formats](#formats)
- [Full config example](#full-config-example)

<br>

### Set config via env
#### You can override any config value with environment variables using `__` as a separator between nested values.
```bash
# Example for setting default command
export telegram_bot_options__default_command=video

# Example for setting cookiefile for audio and video options
export youtube_downloader_options__audio_options__cookiefile=/home/user/cookies.txt
export youtube_downloader_options__video_options__cookiefile=/home/user/cookies.txt

# Even array indexes can be used for nested values
export telegram_bot_options__authorization_options__users__0__id=123
export telegram_bot_options__authorization_options__users__0__claims=audio,help
```

---

### Configuration file path `telegram_youtube_downloader\configs\config.yaml`.

---

### `logger_options`
```yaml
logger_options:
  log_path: logs        # Can be abs path
  root_log_level: 30    # Log level for other libraries
  app_log_level: 20     # Log level for application
  backup_count: 10      # Number of log files to keep
  max_bytes: 10485760   # Max log file size (10MB)
```

---

### `telegram_bot_options`
### Timeouts for different media types
```yaml
telegram_bot_options:
  text_timeout_seconds: 30
  video_timeout_seconds: 300 
  audio_timeout_seconds: 300
```

### `base_url`
### Base url of the telegram api server, set this if you are using a custom api server. [See usage with api server](https://github.com/cccaaannn/telegram_youtube_downloader/blob/master/docs/API_SERVER.md)
  - Custom api server has advantages like uploading files up to 2000 MB 
```yaml
telegram_bot_options:
  base_url: null
```

### `default_command`
### Default command runs a specified command on text messages, you can directly send a url to execute the default command.
  - audio: runs audio command on message.
  - video: runs video command on message.
  - null: disables feature.
```yaml
telegram_bot_options:
  default_command: null    # audio,video,null
```

### `authorization_options`
### Authorization has 3 modes
   - DISABLED: (default) Disable authorization checks altogether which allows everyone to use any command
   - ALLOW_SELECTED: Block everyone by default and allow only selected group
   - BLOCK_SELECTED: Allow everyone by default and block selected group
### Users array used to allow or block users depending on the mode
### Claims are the individual operations per user to allow or block specific operations
   - Available claims `about,help,formats,sites,audio,video,search`
   - `all` can be used to represent all claims
### This example blocks everyone but user `111` can use `about,help,formats,sites,audio` commands and user `222` can use all commands.
```yaml
authorization_options:
  mode: "ALLOW_SELECTED"
  users: 
    - id: 111           # user's telegram id
      claims: "about,help,formats,sites,audio"
    - id: 222           # user's telegram id
      claims: "all"
```
### This example allows everyone but user `111` can not use `video` command and user `222` can not use any command.
```yaml
authorization_options:
  mode: "BLOCK_SELECTED"
  users: 
    - id: 111           # user's telegram id
      claims: "video"
    - id: 222           # user's telegram id
      claims: "all"
```

---

### `youtube_search_options`
```yaml
youtube_search_options:
  max_results: 5   # Limit search results with 5
```

---

### `youtube_downloader_options`
```yaml
youtube_downloader_options:
  max_video_duration_seconds: 1200   # 20 min
  max_audio_duration_seconds: 3000   # 50 min
```

### `audio_options` and `video_options`
### audio_options and video_options are directly passed to youtube_dl on their respective download types, you can add different flags to change download configurations.
### `format` property will be overridden by the default format on the formats section
```yaml
youtube_downloader_options:
  audio_options:
    postprocessors: 
      - key: "FFmpegExtractAudio"
        preferredcodec: "mp3"
    format: "bestaudio/best"
    noplaylist: true

  video_options:
    postprocessors: 
      - key: "FFmpegVideoConvertor"
        preferedformat: "mp4"
    format: "bestvideo+bestaudio"
    noplaylist: true
```

### `allowed_url_patterns` 
### Array of url regex for allowed paths, names will be used on `/sites` command
### Restrict sites with.
```yaml
allowed_url_patterns:
  - name: youtube
    pattern: "^https://(.*\\.?youtube.com/.*$|youtu.be$)"
  - name: instagram
    pattern: "^https://.*instagram.com/.*$"
  - name: twitter
    pattern: "^https://.*twitter.com/.*$"
  - name: facebook
    pattern: "^https://.*facebook.com/.*$"
```
### Allow all sites. Downloads still will be restricted by [supported sites of the yt-dlp lib](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)
```yaml
allowed_url_patterns:
  - name: All sites allowed
    pattern: "^https://.*$"
```

### `formats`
### There has to be one value with `is_default=true` flag, it will be used on all downloads that does not specified a format.
### More format values can be found on [youtube-dl documentation](https://github.com/ytdl-org/youtube-dl/blob/master/README.md#format-selection-examples) 
```yaml
youtube_downloader_options:
  formats:
    VIDEO:
      - name: best
        value: "bestvideo+bestaudio/best"
      - name: worst
        value: "worstvideo+worstaudio/worst"
      - name: 1080p
        value: "137+bestaudio/best"
      - name: 720p
        value: "136+bestaudio/best"
        is_default: true
      - name: 480p
        value: "135+bestaudio/best"
      - name: 360p
        value: "134+bestaudio/best"
      - name: 240p
        value: "133+bestaudio/best"
    AUDIO:
      - name: best
        value: "bestaudio/best"
        is_default: true
      - name: worst
        value: "worstaudio/worst"
```

---

### Full config example
```yaml
logger_options:
  log_path: logs                                  # Can be abs path
  root_log_level: 30                              # Warning
  app_log_level: 20                               # Info
  backup_count: 10                                # Number of log files to keep
  max_bytes: 10485760                             # Max log file size (10MB)

telegram_bot_options:
  text_timeout_seconds: 30                        # 30 sec
  video_timeout_seconds: 300                      # 5 min  
  audio_timeout_seconds: 300                      # 5 min

  base_url: null                                  # See docs/CONFIGURATIONS.md for more information (Ex: http://telegram-bot-api:8081/bot)
  default_command: null                           # audio,video,null docs/CONFIGURATIONS.md for more information

  authorization_options:
    mode: "DISABLED"                              # See docs/CONFIGURATIONS.md for more information about authorization
    users: []

youtube_search_options:
  max_results: 5                                  # Limit search results with 5

youtube_downloader_options:
  max_video_duration_seconds: 1200                # 20 min
  max_audio_duration_seconds: 3000                # 50 min

  audio_options:                                  # audio_options are directly passed to youtube_dl on audio downloads
    postprocessors: 
      - key: "FFmpegExtractAudio"
        preferredcodec: "mp3"
    format: "bestaudio/best"                      # format will be overridden by the default format on the formats section
    noplaylist: true

  video_options:                                  # video_options are directly passed to youtube_dl on video downloads
    postprocessors: 
      - key: "FFmpegVideoConvertor"
        preferedformat: "mp4"
    format: "bestvideo+bestaudio"                 # format will be overridden by the default format on the formats section
    noplaylist: true

  allowed_url_patterns:                           # Array of url regex for allowed paths, names will be used on '/sites' command
    - name: All sites allowed
      pattern: "^https://.*$"
  
  formats:
    VIDEO:
      - name: best
        value: "bestvideo+bestaudio/best"
      - name: worst
        value: "worstvideo+worstaudio/worst"
      - name: 1080p
        value: "137+bestaudio/best"
      - name: 720p
        value: "136+bestaudio/best"
        is_default: true
      - name: 480p
        value: "135+bestaudio/best"
      - name: 360p
        value: "134+bestaudio/best"
      - name: 240p
        value: "133+bestaudio/best"
    AUDIO:
      - name: best
        value: "bestaudio/best"
        is_default: true
      - name: worst
        value: "worstaudio/worst"

```
