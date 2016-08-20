<?php 

	define('FACEBOOK_SDK_V4_SRC_DIR', '/facebook-sdk/facebook-php-sdk-v4-4.0-dev/src/Facebook/');
    require __DIR__ . '/facebook-sdk/facebook-php-sdk-v4-4.0-dev/autoload.php';

	require_once( 'Facebook/FacebookRequest.php' );
	require_once( 'Facebook/FacebookSession.php' );
	require_once( 'Facebook/FacebookRedirectLoginHelper.php' );
	require_once( 'Facebook/FacebookResponse.php' );
	require_once( 'Facebook/FacebookSDKException.php' );
	require_once( 'Facebook/FacebookRequestException.php' );
	require_once( 'Facebook/FacebookAuthorizationException.php' );
	require_once( 'Facebook/FacebookServerException.php' );
	require_once( 'Facebook/GraphObject.php' );
	require_once( 'Facebook/GraphUser.php' );
	require_once( 'Facebook/GraphLocation.php' );
	require_once( 'Facebook/GraphSessionInfo.php' );
	require_once( 'Facebook/Entities/AccessToken.php' );
	require_once( 'Facebook/HttpClients/FacebookHttpable.php' );
	require_once( 'Facebook/HttpClients/FacebookCurlHttpClient.php' );
	require_once( 'Facebook/HttpClients/FacebookCurl.php' ); 

	require_once( 'connToDB.php' );
	require_once( 'appInfo.php' );

	use Facebook\FacebookSession;
	use Facebook\FacebookRequest;
	use Facebook\FacebookRequestException;
	use Facebook\GraphUser;
	use Facebook\GraphObject;
	use Facebook\GraphLocation;
	use Facebook\FacebookRedirectLoginHelper;
	use Facebook\FacebookResponse;
	use Facebook\FacebookSDKException;
	use Facebook\FacebookServerException;
	use Facebook\GraphSessionInfo;
	use Facebook\FacebookAuthorizationException;
	use Facebook\Entities\AccessToken;
	use Facebook\HttpClients\FacebookHttpable;
	use Facebook\HttpClients\FacebookCurlHttpClient;
	use Facebook\HttpClients\FacebookCurl;

	header('Content-type: text/html; charset=utf-8');

	date_default_timezone_set('Europe/Athens');

	FacebookSession::setDefaultApplication($appId, $appSecret);
	FacebookSession::enableAppSecretProof(false);

	$session = new FacebookSession($accTok);

	// Take the user's entry.
	$fb_page = mysqli_real_escape_string($conn, $_POST['addData']); 
	
	// Catch a Facebook exception, when the entry is not valid.
	try{
		/* make the API call */
		$page_request = new FacebookRequest(
			$session,
		  	'GET',
		  	'/'. $fb_page
		);
		$page_response = $page_request->execute();
		$response_array = $page_response->getGraphObject()->asArray();
		$page_id = $response_array['id'];

		/* make the API call */
		$request = new FacebookRequest(
			$session,
		  	'GET',
		  	'/'. $page_id .'/events'
		);
		$response = $request->execute();
		$graphObject = $response->getGraphObject()->asArray();

		if($graphObject['data'] != 0){
			foreach ($graphObject['data'] as $value) {
					
			    // Preparing the information about the event.
				$value->name = mysqli_real_escape_string($conn, $value->name);
			    $datetime = new DateTime($value->start_time);
			    $dateFormatted = $datetime->format('Y-m-d H:i:s');
			    $request_pic = new FacebookRequest($session, 'GET', '/' . $value->id . "/picture?redirect=false");
			    $response_pic = $request_pic->execute();
			    $graphObject_pic = $response_pic->getGraphObject()->asArray();
			    $cover_photo = $graphObject_pic['url'];
			    $descr = mysqli_real_escape_string($conn, $value->description);
			    $lat = $value->place->location->latitude;
			    $lng = $value->place->location->longitude;
			    $street = $value->place->location->street;

			    // Printing out the above information for debugging.
				// echo ">> "
			 //    . $value->id . " | "
			 //    . $value->name . " | "
			 //    . $dateFormatted . " | "
			 //    . $descr  . " | "
			 //    . "(" . $lat . ", " . $lng . ") | "
				// . $street . "</br></br>";

			    // Making the SQL query.
			    $sql = "INSERT INTO eventsdb (id, name, dateNtime, cover_photo_url, description, lat, lng, street)
			    	    VALUES($value->id,
			    	    	  '$value->name',
			    	    	  '$dateFormatted',
			    	    	  '$cover_photo',
			    	    	  '$descr',
			    	    	   $lat,
			    	    	   $lng,
			    	    	  '$street')";
			    $retval = mysqli_query($conn, $sql);

			    // Check if any row changed after the query.
			    $rowNum = mysqli_affected_rows($conn);
			    if($rowNum == 1){ $rowBool = true; }
			}

			// Send the response in JSON format.
			if($rowBool) {
				echo '{"addData": 0 }';
			} else {
				echo '{"addData": 1 }';
			}
		} else {
			echo '{"addData": 2 }';
	    }    		
	} catch(Facebook\FacebookAuthorizationException $e){
		echo '{"addData": 3 }';
	}	

	// Close the connection.
    $conn->close();
?>