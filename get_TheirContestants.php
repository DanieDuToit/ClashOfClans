<?php
    session_start();
    $selectedWarID = $_SESSION["selectedWarID"];

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $i   = 0;
    $dbBaseClass = new BaseDB();
    $sql = "SELECT dbo.TheirParticipant.Rank, dbo.TheirParticipant.Experience,
      dbo.TheirParticipant.TownHallLevel, dbo.TheirParticipant.TheirParticipantID, dbo.TheirParticipant.WarID
      FROM
        dbo.TheirParticipant
      WHERE
        (WarID = $selectedWarID) ORDER BY Rank
    ";
    $records     = $dbBaseClass->dbQuery($sql);

    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        $data[$i++] = array(
            'rank'       => $record['Rank'],
            'experience' => $record['Experience'],
            'townhalllevel' => $record['TownHallLevel'],
            'participantid' => $record['TheirParticipantID'],
            'warid'      => $record['WarID']
        );
    }
    echo json_encode($data);
