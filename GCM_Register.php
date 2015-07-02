<?php
    require_once('GCM_Loader.php');

    // return json response
    $json = array();

    $nameUser  = $_REQUEST["name"];
    $nameEmail = $_REQUEST["email"];
    $gcmRegID  = $_REQUEST["regId"]; // GCM Registration ID got from device

    /**
     * Registering a user device in database
     * Store reg id in users table
     */
    if (isset($nameUser) && isset($nameEmail) && isset($gcmRegID)) {

        // Store user details in db
        $res = storePlayer($nameUser, $nameEmail, $gcmRegID);

        $registatoin_ids = array($gcmRegID);
        $message = array("product" => "shirt");

        $result = send_push_notification($registatoin_ids, $message);

        echo $result;
    } else {
        // user details not found
    }
?>