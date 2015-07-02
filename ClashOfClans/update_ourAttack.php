<?php
    session_start();

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

//    $WarID = $_SESSION["selectedWarID"];
    $AttackID = $_REQUEST['attackid'];
//    $OurAttack = 1;
    $FirstAttack = $_REQUEST['firstattack'];
    $OurParticipantID = $_REQUEST['ourparticipantid'];
    $TheirParticipantID = $_REQUEST['theirparticipantid'];
    $StarsTaken = $_REQUEST['starstaken'];

    $db = new BaseDB();

    $sql = "UPDATE Attack SET FirstAttack = $FirstAttack, OurParticipantID = $OurParticipantID,
      TheirParticipantID = $TheirParticipantID, StarsTaken = $StarsTaken WHERE AttackID = $AttackID";
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
