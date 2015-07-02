<?php
/**
 * Created by PhpStorm.
 * User: dutoitd1
 * Date: 2015/05/27
 * Time: 12:25 PM
 */
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $playerid = $_REQUEST['playerid'];

    $db = new BaseDB();

    $sql = "delete from player WHERE PlayerID = '$playerid'";
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
