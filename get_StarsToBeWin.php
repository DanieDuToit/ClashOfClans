<?php
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $warID = $_REQUEST['selectedWarID'];
    $db = new BaseDB();

    $sql = "
        SELECT Rank, StarsToBeWin
        FROM View_StarsToBeWin
        WHERE WarID = $warID
        ORDER BY WarID, Rank
    ";

    $records = $db->dbQuery($sql);

    $data = array();
    $i = 0;
    if (!$records) {
        $data['starsLeftToWin'][0] = array(
            'TheirRank' => 0,
            'StarsLeft' => 0
        );
    } else {
        while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
            $data['starsLeftToWin'][$i] =
                array(
                    'TheirRank' => $record['Rank'],
                    'StarsToBeWin' => $record['StarsToBeWin']
                );
            $i++;
        }
    }

    $db->Free($records);
    $db->close();

    echo json_encode($data);
