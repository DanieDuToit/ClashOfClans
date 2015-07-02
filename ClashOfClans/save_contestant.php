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

    $sql = "INSERT INTO OurParticipant(WarID, PlayerID, Experience, Rank, TownHallLevel)
      VALUES ($selectedWarID, $playerid, $experience, $rank, $townhallLevel)";
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

