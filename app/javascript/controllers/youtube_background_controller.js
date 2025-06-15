import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["player"]
  static values = {
    videoId: String,
    startTime: Number
  }

  connect() {
    this.initializePlayer()
  }

  initializePlayer() {
    // YouTube IFrame APIを動的に読み込む
    if (!window.YT) {
      const tag = document.createElement('script')
      tag.src = "https://www.youtube.com/iframe_api"
      const firstScriptTag = document.getElementsByTagName('script')[0]
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

      window.onYouTubeIframeAPIReady = () => {
        this.createPlayer()
      }
    } else {
      this.createPlayer()
    }
  }

  createPlayer() {
    this.player = new YT.Player(this.playerTarget, {
      videoId: this.videoIdValue,
      playerVars: {
        autoplay: 1,
        mute: 1,
        loop: 1,
        playlist: this.videoIdValue, // ループに必要
        controls: 0,
        showinfo: 0,
        rel: 0,
        start: this.startTimeValue,
        modestbranding: 1,
        iv_load_policy: 3
      },
      events: {
        'onReady': (event) => {
          event.target.playVideo()
        },
        'onStateChange': (event) => {
          // 動画終了時に再び指定時間から再生
          if (event.data === YT.PlayerState.ENDED) {
            event.target.seekTo(this.startTimeValue)
            event.target.playVideo()
          }
        }
      }
    })
  }
}
