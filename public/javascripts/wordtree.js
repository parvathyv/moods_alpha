 
        google.load('visualization', '1', {'packages':['corechart','wordtree','table']});


  
  
      google.setOnLoadCallback(drawChart);
     
     
      
      function drawChart() {
        var data = google.visualization.arrayToDataTable(
           comments_array
          
        );

          var data1 = google.visualization.arrayToDataTable(
         colors_array
        );


        var options = {
        fontName: 'Roberto',
          wordtree: {
            format: 'implicit',
            
            word: 'I feel '
          }
        };

         var options1 = {
          title: 'Moods',
          colors: ['#e0440e', '#00FF00', '#0000FF','#551A8B']
        };
       
          var chart = new google.visualization.WordTree(document.getElementById('wordtree_basic'));
          chart.draw(data, options);

          var chart1 = new google.visualization.PieChart(document.getElementById('piechart'));

          chart1.draw(data1, options1);
      
      }


