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

// 送信ボタンを押したときにApp.roomのspeakメソッドを発火
var allowClick = true;
$(document).ready(function(){
  $('#message-btn').click(function(event){
    var text = $('#content_form').val();
    if(allowClick && text !== '') {
      allowClick = false;
      App.room.speak(text);
      $('#content_form').val('');
      $('html, body').animate({ scrollTop: $(document).height() });
      allowClick = true;
      event.preventDefault();
    } else {
      event.preventDefault();
    }
  });
});
