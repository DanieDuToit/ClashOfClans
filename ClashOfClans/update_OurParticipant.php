<?php
    session_start();
    $selectedWarID = $_SESSION["selectedWarID"];

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $OurParticipantID = $_REQUEST['ourparticipantid'];
    $playerid = $_REQUEST['playerid'];
    $rank = $_REQUEST['rank'];
    $experience = $_REQUEST['experience'];
    $townhallLevel = $_REQUEST['townhalllevel'];
    $db = new BaseDB();

    $sql = "UPDATE OurParticipant Set WarID = $selectedWarID, PlayerID = $playerid,
          Experience = $experience, Rank = $rank, TownHallLevel = $townhallLevel
          WHERE OurParticipantID = $OurParticipantID";
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

