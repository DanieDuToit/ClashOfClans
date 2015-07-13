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
       AND ISNULL(StarsTaken, -1) <> -1
    ";

    $records = $db->dbQuery($sql);

    $data = array();
    $i       = 0;
    if (!sqlsrv_has_rows($records)) {
        $data['attacks'][0] = array(
            'TheirRank'  => 0,
            'StarsTaken' => 0
        );
    } else {
        while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
            $data['attacks'][$i] = array(
                'TheirRank'  => $record['TheirRank'],
                'StarsTaken' => $record['StarsTaken']
            );
            $i++;
        }
    }

    $db->Free($records);
    $db->close();

    echo json_encode($data);
