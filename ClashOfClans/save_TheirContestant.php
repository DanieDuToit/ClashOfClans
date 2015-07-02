<?php
    session_start();
    $selectedWarID = $_SESSION["selectedWarID"];

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $rank = $_REQUEST['rank'];
    $experience = $_REQUEST['experience'];
    $townhallLevel = $_REQUEST['townhalllevel'];
    $db = new BaseDB();

    $sql = "INSERT INTO TheirParticipant(WarID, Experience, Rank, TownHallLevel)
      VALUES ($selectedWarID, $experience, $rank, $townhallLevel)";
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

