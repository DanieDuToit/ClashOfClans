<?php

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $selectedWarID = $_REQUEST['selectedWarID'];
    $OurParticipantID = $_REQUEST['OurParticipantID'];

    $db = new BaseDB();

    $sql = "
      select ISNULL(TheirRank, -1) AS TheirRank,
        ISNULL(StarsTaken, -1) AS StarsTaken
      from View_OurAttackedOpponents
      WHERE WarID = $selectedWarID AND OurParticipantID = $OurParticipantID
    ";

    $result = $db->dbQuery($sql);

    $i = 0;
    $data = array();
    while ($record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH)) {
        $data['attacks'][$i++] = array(
            'TheirRank' => $record['TheirRank'],
            'StarsTaken' => $record['StarsTaken']
        );
    }
    $db->Free($result);
    $db->close();

    echo json_encode($data);

