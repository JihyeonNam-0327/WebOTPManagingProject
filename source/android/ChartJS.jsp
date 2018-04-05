<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import="java.net.*, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<%
request.setCharacterEncoding("utf-8");
String id = "";
id = request.getParameter("id"); //학번
String name = "";


//try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	int size = 0; //배열의 크기
	query = "select count(status) from attendanceDB where _id=?;";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,id);
	rset = pstm.executeQuery();
	while(rset.next()){
		size = rset.getInt(1);
	}
	
	out.println("<input type='hidden' id='size' value='"+size+"' />");
	
	String[] attd_date = new String[size];
	int[] attd_status = new int[size];
	
	query = "select name from memberDB where _id=?";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,id);
	rset = pstm.executeQuery();
	while(rset.next()){
		name = rset.getString(1);
	}
	out.println("<input type='hidden' id='name' value='"+name+"' />");
	
	int status = 0;
	query = "select date, status from attendanceDB where _id=? order by date;"; //날짜가 가장 가까운 날짜부터 출력! (우선은)
	pstm = conn.prepareStatement(query);
	pstm.setString(1,id);
	rset = pstm.executeQuery();
	int cnt = 0;
	while(rset.next()){
		attd_date[cnt] = rset.getString(1);
		attd_date[cnt] = attd_date[cnt].substring(0,10);
		status = rset.getInt(2);
		switch(status){
			 case 1 : attd_status[cnt] = 0;	//지각, 나쁜점 : 0
					  break;
			 case 2 : attd_status[cnt] = 2;	//조퇴, 중간점 : 2
					  break;
			 case 4 : attd_status[cnt] = -2;//결석, 최하점 : -2
					  break;
			 case 5 : attd_status[cnt] = 4;	//출석, 최고점 : 4
					  break;
		}
		cnt++;
	}

	rset.close();
	pstm.close();
	conn.close();
/*}catch(SQLException e){
	out.println("SQLe " + e.toString());
}catch(Exception e){
	out.println("Exception " + e.toString());
}*/
%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.13.0/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
</head>
<body>
<br><br><br><br>
<canvas id="myChart" width="400"></canvas>
<br><br>
<center>* 4점 : 출석, &nbsp;2점 : 조퇴, &nbsp;0점 : 지각, &nbsp;-2점 : 결석</center>
<script>
var size = $('#size').val();
var name = $('#name').val();
var time_Array = new Array(size);
<%for(int i=0;i<size;i++){%>
time_Array[<%=i%>]='<%=attd_date[i]%>';
<%}%>

var status_Array = new Array(size);
<%for(int i=0;i<size;i++){%>
status_Array[<%=i%>]='<%=attd_status[i]%>';
<%}%>

var ctx = document.getElementById("myChart").getContext('2d');
var randomColorPlugin = {

    // We affect the `beforeUpdate` event
    beforeUpdate: function(chart) {
        var backgroundColor = [];
        var borderColor = [];
        
        // For every data we have ...
        for (var i = 0; i < chart.config.data.datasets[0].data.length; i++) {
        
        	// We generate a random color
        	var color = "rgba(" + Math.floor(Math.random() * 255) + "," + Math.floor(Math.random() * 255) + "," + Math.floor(Math.random() * 255) + ",";
            
            // We push this new color to both background and border color arrays
            backgroundColor.push(color + "0.2)");
            borderColor.push(color + "1)");
        }
        
        // We update the chart bars color properties
        chart.config.data.datasets[0].backgroundColor = backgroundColor;
        chart.config.data.datasets[0].borderColor = borderColor;
    }
};

Chart.pluginService.register(randomColorPlugin);

var myChart = new Chart(ctx, {
    type: 'line',
    data: {
		
        labels: time_Array,
        datasets: [{
            label: name + ' 님의 출결 현황 차트입니다.',
            data: status_Array,
            backgroundColor: 'rgba(255, 99, 132, 0.2)',
            borderColor: 'rgba(255,99,132,1)',
            borderWidth: 1
        }]
    },
    options: {
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero: true,
                    stepSize: 1,
                    min: -2,
                    max: 4
                }
            }]
        }
    }
});

</script>
</body>
</html>