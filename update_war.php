<?php

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $warID       = $_REQUEST['warid'];
    $warDate     = $_REQUEST['wardate'];
    $NumberOfParticipants = $_REQUEST['numberofparticipants'];
    $WarsWeWon   = $_REQUEST['warswewon'];
    $WarsTheyWon = $_REQUEST['warstheywon'];
    $active      = $_REQUEST['active'];

    $i      = 0;
    $dbBaseClass = new BaseDB();
    $sql    = "UPDATE WAR SET Date = '$warDate', NumberOfParticipants = $NumberOfParticipants,
      WarsWeWon = $WarsWeWon, WarsTheyWon = $WarsTheyWon, Active = $active WHERE WarID = $warID";
    $result = $dbBaseClass->dbQuery($sql);
    if ($result == false) {
        echo json_encode([
            'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
        ]);
    } else {
        echo json_encode([
            'success' => 'success'
        ]);
    }
