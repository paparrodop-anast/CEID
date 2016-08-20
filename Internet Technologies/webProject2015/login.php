<?php
	
	session_start(); // Starting session.

	require_once ('connToDB.php');

	ob_start(); // Just to fix a buffer error.

	$username = $_POST['username'];
	$password = $_POST['password'];

	// Protection from MySQL injection.
	$username = stripslashes($username);
	$password = stripslashes($password);
	$username = mysqli_real_escape_string($conn, $username);
	$password = mysqli_real_escape_string($conn, $password);

	if (isset($_POST['Submit'])) {
		if (empty($_POST['username']) || empty($_POST['password'])) {
			$error = "The username or the password is missing.";
		}
	}
	
	$error=''; // Variable To store the error message.
	
	// SQL query to fetch information of registered users and find user match.
	$query = mysqli_query($conn, "SELECT * FROM users WHERE username='$username' AND password='$password';");
	$arr = mysqli_fetch_array($query);

	if ($arr > 0) {
		$_SESSION['username'] = $arr['username']; // Initializing session.
		echo "Success! " . $_SESSION['username'];
		header("location: panel.html"); // Redirecting to the administrator panel.
	} else {
		$error = "The username or the password is invalid.";
		echo $error; // Printing error.
		header("location: index.html"); // Redirecting to the main page.
	}
	mysqli_close($conn); // Closing the connection.	
?>