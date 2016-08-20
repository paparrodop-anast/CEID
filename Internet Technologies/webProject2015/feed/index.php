<?php
	
	include_once("../connToDB.php");

	$rssfeed = '<?xml version="1.0" encoding="UTF-8"?>';
	$rssfeed .= '<rss version="2.0">';
	$rssfeed .= '<channel>';
	$rssfeed .= '<title>Web Project 2015 - RSS Feed</title>';

	$sql_fetch = " SELECT name, description, dateNtime
				   FROM eventsdb
				   ORDER BY dateNtime
				   LIMIT 10; ";
	$retval = mysqli_query($conn, $sql_fetch);

	while($row = mysqli_fetch_assoc($retval)) {
        $rssfeed .= '<item>';
        $rssfeed .= '<title><![CDATA[' . $row['name'] . ']]></title>';
        $rssfeed .= '<description><![CDATA[' . $row['description'] . ']]></description>';
        $rssfeed .= '<pubDate>' . $row['dateNtime'] . '</pubDate>';
        $rssfeed .= '</item>';
    }
 
    $rssfeed .= '</channel>';
    $rssfeed .= '</rss>';
 
 	header("Content-Type: text/xml");
 	
    echo $rssfeed;

    // Close the connection.
	$conn->close();
?>