 $('.largebutton').click(function(event) {
       event.preventDefault(); 

        $.ajax({
        url: '/moods',
        method: 'POST',
        data: $('form').serialize()
         
        });
      });


  $('.medbutton').click(function(event) {
       event.preventDefault(); 

        $.ajax({
        url: '/moods',
        method: 'get',
        data: $('form').serialize()
         
        });
      });