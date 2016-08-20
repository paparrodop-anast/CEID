<?php 

	header('Content-type: text/html; charset=utf-8');

	include_once( 'connToDB.php' );

	// Take the user's entry.
	$search = mysqli_real_escape_string($conn, $_POST['search']);    

	// Make the query to the database.
	$sql = "SELECT *
			FROM eventsdb
			WHERE (name LIKE '%".$search."%' OR description LIKE '%".$search."%' OR dateNtime LIKE '%".$search."%')"; 
	$retval = mysqli_query($conn, $sql); 

	// Make sure that the query was successful.
	if(!$retval){
		die('Could not get data: ' . mysql_error());
	} 

	// Check if the search was successful, and then send the response.
	if ($retval) {
		while($row = mysqli_fetch_assoc($retval)){
		     $arr[] = $row;  
		}  

		echo '{"search":'.json_encode($arr).'}';
	} else {
		echo "Wrong Input";
	}

	// Close the connection.
	$conn->close();
?>