<?php

	include_once("connToDB.php");

	$sql_fetch = " SELECT name, dateNtime, cover_photo_url, owner_name, description, lat, lng, street
				   FROM eventsdb
				   ORDER BY dateNtime; ";

	if ( $retval = mysqli_query($conn, $sql_fetch) ) {
 		$rowcount = mysqli_num_rows($retval);
 		if ($rowcount != 0) {
			while($row = mysqli_fetch_assoc($retval)) {
			     $arr[] = $row;
			} 

			if ($arr != null) {
				echo '{"members":'.json_encode($arr).'}';
			} else {
				echo '$arr is null.';
			}
		} else {
			echo 'No results for this query.';
		}
	} else {
		die('Could not get data: ' . mysql_error());
	}
	
	//close the connection
	$conn->close();
?>