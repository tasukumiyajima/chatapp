// :を押すと絵文字のsuggestを表示
$(document).ready(function(){
  $('#content_form, #room_search').textcomplete([
    {
      match: /\B:([\-+\w]*)$/,
      search: function(term, callback) {
        $.getJSON("/api/emojis", { query: term })
        .done(function (data) { callback(data); })
        .fail(function ()     { callback([]);   });
      },
      template: function(data) {
        return `<img src="${data.url}" class="emoji" /> ${data.value}`;
      },
      replace: function(data) {
        return `:${data.value}:`;
      },
      index: 1,
      maxCount: 10
    }
  ])
});

// showページを表示したら自動でページ最下部を表示する
$(document).ready(function(){
  if ($("#content_form").length) {
    window.scroll(0, $(document).height());
  }
});

// 無限スクロール
var allowShow = true;
$(document).ready(function(){
  if ($("#content_form").length) {
    $(window).on('scroll', function() {
      var pageHeight = $(document).height(); // ページの全ての高さ
      var positionFromTop = $(window).scrollTop(); // スクロールの位置
      if (allowShow && (positionFromTop <= (pageHeight * 0.01)) ) {
        allowShow = false;
        $('#result').text('読み込み中...');
        var oldestMessageId = $(".message:first").data("message_id");
        var room_id = $('#messages').data('room_id');
        $.ajax({
          url: "/show_additionally",
          type: "GET",
          cache: false,
          data: {
            oldest_message_id: oldestMessageId,
            id: room_id,
            remote: true
          },
          timeout: 10000
        })
        .then(function(data){
          $('#messages').prepend(data);
          $('#result').text('');
          setTimeout(function(){ allowShow = true; }, 1000);
        })
      }
    });
  }
});

// 下部にスクロールしたときに既読情報をアップデートする
var allowSend = true;
$(document).ready(function(){
  if ($("#content_form").length) {
    $(window).on('scroll', function() {
      var pageHeight = $(document).height(); // ページの全ての高さ
      var scrollPosition = $(window).scrollTop() + $(window).height(); // ページ最上部からのスクロールの位置
      if ( allowSend && ((pageHeight - scrollPosition) / pageHeight <= 0.01)) {
        allowSend = false;
        var oldestMessageId = $(".message:first").data("message_id");
        var latestMessageId = $(".message:last").data("message_id");
        var room_id = $('#messages').data('room_id');
        $.ajax({
          url: "/update_check",
          type: "GET",
          cache: false,
          data: {
            oldest_message_id: oldestMessageId,
            latest_message_id: latestMessageId,
            id: room_id,
            remote: true
          },
          timeout: 10000
        })
        .then(function(data){
          $('#messages').html(data);
          setTimeout(function(){ allowSend = true; }, 10000);
        })
      }
    });
  }
});

// 検索モーダルの消去ボタン
$(document).on("click", '.close-modal', function(){
  $(this).parents('#searched-modal').fadeOut();
  return false;
});
