document.addEventListener("turbo:load", function() {
  // 返信ボタンの非表示
  // .reply-buttonのクラスがあるすべての要素を取得し、clickイベントを付与
  document.querySelectorAll('.reply-button').forEach(button => {
    button.addEventListener('click', function() {
      // その要素ないのdata-comment-idを主徳し、そのidから該当の返信ボタンを見つける
      const commentId = this.getAttribute('data-comment-id');
      const replyForm = document.getElementById(`reply-form-${commentId}`);

      // 返信ボタンは現在開いているもの以外閉じる
      document.querySelectorAll('.reply-form').forEach(form => {
        if (form.id !== `reply-form-${commentId}`) {
          form.style.display = 'none';
        }
      })
      // 返信フォームを表示・非表示する
      replyForm.style.display = replyForm.style.display === 'none' ? 'block' : 'none';
    });
  });

  // 返信後に返信用フォーム非表示
  // turboが終わってから処理開始
  document.addEventListener('turbo:submit-end', function(event) {
    // 直近イベントを取得して、その親に.reply-formがあるものを取得
    const form = event.target;

    if (form.closest('.reply-form')) {
      form.closest('.reply-form').style.display = 'none';
    }
  });
});
