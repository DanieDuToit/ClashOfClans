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
    $clanID = $_REQUEST['clanID'];
    $retArray = array();

    // Does player exist in the table
    $exist    = doesPlayerExist($gameName, $clanID);
    $playerID = getPlayerID($gameName, $clanID);

    if ($playerID === null) {
        echo json_encode([
            $retArray = array("responseOK" => false, "responseMessage" => "No such player")
        ]);
        goto EndOfFile;
    }
    if ($exist === true) {
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
            echo json_encode(array(
                $retArray = array("responseOK" => true, "responseMessage" => 'Record Updated Successfully')
            ));
        }
    } else {
        // Create a new record
        $sql = "
            INSERT INTO gcm_users (
              PlayerID, clanID, gcm_regid, game_name, email, created_at
            )
            VALUES (
              $playerID, $clanID, '$gcmRegistrationId', '$gameName', '$email', GETDATE()
            )
        ";
        $result = $db->dbQuery($sql);
        if ($result == false) {
            echo json_encode([
                $retArray = array("responseOK" => false, "responseMessage" => dbGetErrorMsg())
            ]);
        } else {
            echo json_encode(array(
                $retArray = array("responseOK" => true, "responseMessage" => 'Record Inserted Successfully')
            ));
        }
    }
    EndOfFile: