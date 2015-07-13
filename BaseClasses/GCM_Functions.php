<?php
    include_once("GCM_Functions.php");
    //Storing new user and returns user details

    function storePlayer($name, $email, $gcm_regid)
    {
        $db = new BaseDB();

        // insert user into database
        $sql = "INSERT INTO gcm_users(name, email, gcm_regid, created_at) VALUES('$name', '$email', '$gcm_regid', GETDATE())";
        $result = $db->dbQuery($sql);

        // check for successful store
        if ($result) {

            // get user details
            $id = $db->getLastId('gcm_users'); // last inserted id
            $result = $db->dbQuery("SELECT * FROM gcm_users WHERE id = $id") or die(dbGetErrorMsg());
            // return user details
            $NumRecords = sqlsrv_num_rows($result);
            if ($NumRecords > 0) {
                return sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);
            } else {
                return false;
            }

        } else {
            return false;
        }
    }

    /**
     * Get user by email
     */
    function getPlayerByEmail($email)
    {
        $db = new BaseDB();
        $result = $db->dbQuery("SELECT TOP(1) FROM gcm_users WHERE email = '$email'");
        return $result;
    }

    /**
     * Get user by gameName
     */
    function getPlayerByGameName($gameName)
    {
        $db = new BaseDB();
        $result = $db->dbQuery("SELECT TOP(1) FROM gcm_users WHERE game_name = '$gameName'");
        return $result;
    }

    // Getting all registered users
    function getAllPlayers()
    {
        $db     = new BaseDB();
        $result = $db->dbQuery("SELECT * FROM gcm_users");
        return $result;
    }

    // Validate user
    function doesPlayerExist($gameName)
    {
        $db     = new BaseDB();
        $result = $db->dbQuery("SELECT count(id) AS count from gcm_users WHERE game_name = '$gameName'");
        $record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);
        if ($record['count'] > 0) {
            // user exist
            return true;
        } else {
            // user does not existed
            return false;
        }
    }

    //Sending Push Notification
    function send_push_notification($registatoin_ids, $message)
    {


        // Set POST variables
        $url = 'https://android.googleapis.com/gcm/send';

        $fields = array(
            'registration_ids' => $registatoin_ids,
            'data' => $message,
        );

        $headers = array(
            'Authorization: key=' . GOOGLE_API_KEY,
            'Content-Type: application/json'
        );
        //print_r($headers);
        // Open connection
        $ch = curl_init();

        // Set the url, number of POST vars, POST data
        curl_setopt($ch, CURLOPT_URL, $url);

        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

        // Disabling SSL Certificate support temporarly
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));

        // Execute post
        $result = curl_exec($ch);
        if ($result === false) {
            $err = curl_error($ch);
            die('Curl failed: ' . curl_error($ch));
        }

        // Close connection
        curl_close($ch);
        echo $result;
    }

?>