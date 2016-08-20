<?php
	$hostname = "127.0.0.1"; // Or "localhost", it's the IP of the server.
	$usernameDB = "root";  // Required username for connection to database.
	$passwordDB = "tavoulinou"; // Required password for connection to database.
	$database = "webprojectdb"; // The name of the database created for the current project.

	// Variable to store error message.
	$error = ''; 
	
	// Establishing connection with the server.
	$conn = mysqli_connect($hostname, $usernameDB, $passwordDB);

	// Making sure that the encoding is UTF-8.
	$conn->set_charset("utf8");

	// Check connection: if there isn't one, print an error message.
	if (!$conn) {
		die("Connection failed: " . mysqli_connect_error());
	}

	// Selecting database to connect to.
	$db = mysqli_select_db($conn, $database);
?>
