<?php

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $selectedWarID = $_REQUEST['selectedWarID'];
    $ownRank = $_REQUEST['rank'];

    $db = new BaseDB();

    $sql_callFunc = "SELECT (SELECT dbo.[PlayersNextBestAttack]($selectedWarID, $ownRank) AS RankToAttack) AS RankToAttack";
    $result = $db->dbQuery($sql_callFunc);
    $rankToAttack = 0;
    $err = "";
    $record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);
    if ($record == false) {
        $err = dbGetErrorMsg();
    }
    $db->Free($result);
    $db->close();
    $data['rankToAttack'][0] = array('rank' => $record['RankToAttack']);

    echo json_encode($data);