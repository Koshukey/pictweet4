$(function(){
  function buildHTML(comment){
    var html = `<p>
                  <strong>
                    <a href=${comment.id}>${comment.user_name}</a>
                    ：
                  </strong>
                  ${comment.text}
                </p>`
    return html;
//HTMLを追記 by テンプレートリテラル法(バックティック文字で囲む)
console.log(html);
  }
  $('#new_comment').on('submit', function(e){
    e.preventDefault();
    var formData = new FormData(this);
    var href = window.location.href + '/comments'
    $.ajax({
      url: href,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      var html = buildHTML(data);
      $('.comments').append(html)
      $('.textbox').val('')
    })
    .fail(function(){
      alert('error');
//サーバーエラーの時はfail関数が呼ばれるようにする
    })
  })
});
