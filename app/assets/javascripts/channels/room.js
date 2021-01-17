$(document).ready(function(){
  // RoomChannelとroomごとのsabscriptionを作る
  room_id = $('#messages').data('room_id')
  App.room = App.cable.subscriptions.create({ 
    channel: "RoomChannel",
    room_id: room_id
  }, {
    connected: function() {
      // Called when the subscription is ready for use on the server
    },

    disconnected: function() {
      // Called when the subscription has been terminated by the server
    },

    // サーバーサイドからブロードキャスト(送信)されたものを受け取る
    received: function(data) {
      if (data['room_id'] === room_id) {
        return $('#messages').append(data['message']);
      }
    },

    // テキストボックスの文字列=messageをroom_channel.rbのspeakアクションに送信
    speak: function(message) {
      return this.perform('speak', {
        message: message
      });
    }
  });
});

  // enterが押されたときにApp.roomのspeakメソッドを発火させる
$(document).on('keypress', '[data-behavior~=room_speaker]', function(event){
  if (event.keyCode === 13) {
    App.room.speak(event.target.value);　// event.target.valueでテキストボックスに打ち込んだ文字列を取得する
    event.target.value = ''; // テキストボックスを空にする
    return event.preventDefault(); // ブラウザのデフォルトの動作をpreventする
  }
});

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
