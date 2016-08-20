<?php
	session_start();

	// remove all session variables
	session_unset();

	// destroy the session
	session_destroy(); 

	// Redirecting To Home Page
	header("Location: index.html"); 
?>