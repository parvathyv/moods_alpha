google.load('visualization', '1', {'packages':['corechart','wordtree','table']});
google.setOnLoadCallback(function() {
  drawChart(root, comments_array, colors_array);
});

function drawChart(root, comments, colors) {
  var data = google.visualization.arrayToDataTable(
    comments
  );

  var data1 = google.visualization.arrayToDataTable(
    colors
  );

  var options = {
  fontName: 'Oswald',
  fontColor:'#FF0000',
  minFontSize: 24,
    wordtree: {
      format: 'implicit',
      word: root
    }
  };

  var options1 = {
    fontName:'Oswald',
    title: 'COLORS',
    colors: ['#FFA500', '#0850a1', '#44474b','#789448','#e53a0f','#6f066f']
  };
 
  var chart = new google.visualization.WordTree(document.getElementById('wordtree_basic'));
  chart.draw(data, options);

  var chart1 = new google.visualization.PieChart(document.getElementById('piechart'));

  chart1.draw(data1, options1);
}

$('.medbutton').click(function(event) {
  event.preventDefault(); 

  $.ajax({
    url: '/moods.json',
    method: "get",
    data: $('form').serialize(),
    success: function(data) {
      drawChart(data.root, data.comments, data.colors);
    }
  });
});