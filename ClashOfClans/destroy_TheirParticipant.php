<?php

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $playerid = $_REQUEST['id'];

    $db = new BaseDB();

    $sql = "DELETE FROM TheirParticipant WHERE TheirParticipantID = '$playerid'";
    $result = $db->dbQuery($sql);
    if ($result == false) {
        echo json_encode([
            'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
        ]);
    } else {
        echo json_encode([
            'success' => 'success'
        ]);
    }
    $db->Free($result);
    $db->close();
