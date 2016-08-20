<?php

	header('Content-type: text/html; charset=utf-8');
	
	include_once( 'connToDB.php' );

	// Take the user's entry.
	$delete = mysqli_real_escape_string($conn, $_POST['deleteData']);    

	// Make the query to the database.
	$sql = "DELETE FROM eventsdb
			WHERE name LIKE '%".$delete."%' "; 
	$retval = mysqli_query($conn, $sql); 

	// Check if any row changed after the query.
	$rowNum = mysqli_affected_rows($conn);

	// Make sure that the query was successful.
	if(!$retval) {
		die('Could not get data: ' . mysql_error());
	} 

	// Send the response.
	if($rowNum != 0) {
		echo '{"deleteData": 0 }';
	} else if($rowNum == 0) {
		echo '{"deleteData": 1 }';
	}

	// Close the connection.
	$conn->close();
?>