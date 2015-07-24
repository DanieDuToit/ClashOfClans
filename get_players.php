<?php
    session_start();

    if (!isset($_SESSION["selectedClanID"])) {
        header("Location: Index.php?err=You must sign in first.");
        die();
    }

    $selectedClanID = $_SESSION["selectedClanID"];

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $i = 0;
    $dbBaseClass = new BaseDB();
    $activeOnly = $_REQUEST['activeonly'];
    if ($activeOnly === 1) {
        $records = $dbBaseClass->dbQuery("SELECT PlayerID, GameName, RealName, Active FROM Player
          WHERE active=1 AND ClanID = $selectedClanID");
    } else {
        $records = $dbBaseClass->dbQuery("SELECT PlayerID, GameName, RealName, Active FROM Player
          WHERE ClanID = $selectedClanID");
    }

    $data = array();
    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        $data[$i++] = array (
            'playerid' => $record['PlayerID'],
            'gamename' => $record['GameName'],
            'realname' => $record['RealName'],
            'active' => $record['Active']
        );
    }
    echo json_encode($data);
