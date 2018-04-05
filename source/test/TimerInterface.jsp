<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.math.*, java.text.*" %>
<% request.setCharacterEncoding("utf-8");%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="javax.telephony.*" %>
<%@ page import="java.util.Timer" %>
<%@ page import="java.util.TimerTask" %>
<%@ page import="java.util.Date" %>
<%!
     class CounterTimerTask extends java.util.TimerTask {
        /**
        * Date format used in message.  Includes milliseconds.
        */

        public final SimpleDateFormat FMT = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss.SSS aa");

        private String time;
        private Date sked;

        public CounterTimerTask(String time, Date sked) {
           this.time = time;
           this.sked = sked;
        }

        public void run() {
           System.out.println("Starting " + time);
           System.out.println(FMT.format(sked) + " Thread " + time);

              try {
                  Thread.sleep(500);
              } catch(Exception ex) {}
          

          //cancel();

        }
     }
%>
<%
     
     Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
		String dateStr = sdf.format(today);
     
     java.text.SimpleDateFormat date_format = new java.text.SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
    Date sked = date_format.parse(dateStr);

     Timer timer = new Timer();
    TimerTask task = new CounterTimerTask("starting", sked);
    timer.schedule(task, sked);
%>
<BR>
Result: <%=sked%>
<BR>
<A HREF="index.html">Back</A>
<body>
</html>
		