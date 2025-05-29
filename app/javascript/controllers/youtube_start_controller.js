document.addEventListener('turbo:load', function() {
  // YouTube動画プレーヤーの時間を更新する関数
  window.updateVideoTime = function(videoId, seconds) {
    var iframe = document.getElementById('youtube-player');
    if (iframe) {
      iframe.src = 'https://www.youtube.com/embed/' + videoId + '?start=' + seconds + '&autoplay=1';
    }
    return false;
  }
});
