<?php
    include_once("BaseDB.class.php");
    include_once("Database.class.php");

    if (isset($_REQUEST['warID'])) {
        $warID = $_REQUEST['warID'];
    } else {
        //Error
    }


    //connect to the db
    $dbBaseClass = new BaseDB();

    $sql = "SELECT
        dbo.OurParticipant.OurParticipantID, dbo.Player.GameName
    FROM
        dbo.OurParticipant INNER JOIN
        dbo.Player ON dbo.OurParticipant.PlayerID = dbo.Player.PlayerID
    WHERE WarID = $warID";

    $records = $dbBaseClass->dbQuery($sql);
    $data = array();
    $i = 0;
    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        $data['result'][$i++] = array(
            'OurParticipantID' => $record['OurParticipantID'],
            'GameName' => $record['GameName']
        );
    }
    echo json_encode($data);