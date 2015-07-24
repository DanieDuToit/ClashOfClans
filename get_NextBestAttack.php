<?php

    require_once('GCM_Loader.php');

    $selectedWarID = $_REQUEST['selectedWarID'];
    $ownRank = $_REQUEST['rank'];

    $db = new BaseDB();

    //TODO Remember to change the hardcoded '0' (RankByExperience) below -> BIT
    $sql_callFunc = "SELECT (SELECT dbo.[PlayersNextBestAttack]($selectedWarID, $ownRank, 0) AS RankToAttack) AS RankToAttack";
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