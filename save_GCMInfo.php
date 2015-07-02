<?php
    include_once("GCM_Loader.php");
    $db = new BaseDB();

    $gameName = $_REQUEST['gameName'];
    if (isset($_REQUEST['email'])) {
        $email = $_REQUEST['email'];
    } else {
        $email = '';
    }
    $gcmRegistrationId = $_REQUEST['gcmRegistrationId'];
    $retArray = array();

    // Does player exist in the table
    $exist = doesPlayerExist($gameName);
    if ($exist === true){
        // Update the existing record
        $sql = "
            UPDATE gcm_users
            SET email = '$email', gcm_regid = '$gcmRegistrationId'
            WHERE game_name = '$gameName'
        ";
        $result = $db->dbQuery($sql);
        if ($result == false) {
            echo json_encode([
                $retArray = array("responseOK" => false, "responseMessage" => dbGetErrorMsg())
            ]);
        } else {
            echo json_encode(array (
                $retArray = array("responseOK" => true, "responseMessage" => 'Record Updated Successfully')
            ));
        }
    } else {
        // Create a new record
        $sql = "
            INSERT INTO gcm_users (
              gcm_regid, game_name, email, created_at
            )
            VALUES (
              '$gcmRegistrationId', '$gameName', '$email', GETDATE()
            )
        ";
        $result = $db->dbQuery($sql);
        if ($result == false) {
            echo json_encode([
                $retArray = array("responseOK" => false, "responseMessage" => dbGetErrorMsg())
            ]);
        } else {
            echo json_encode(array (
                $retArray = array("responseOK" => true, "responseMessage" => 'Record Inserted Successfully')
            ));
        }
    }
