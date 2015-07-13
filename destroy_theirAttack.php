<?php
    session_start();

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    //    $WarID = $_SESSION["selectedWarID"];
    $AttackID = $_REQUEST['id'];

    $db = new BaseDB();

    $sql = "DELETE Attack WHERE AttackID = $AttackID";
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

