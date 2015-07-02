<?php
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $warID = $_REQUEST['selectedWarID'];
    $db = new BaseDB();

    $sql = "
        select GameName,
            CASE FirstAttack
                WHEN 1 THEN 'First'
                WHEN 0 THEN 'Second'
            END AS Attack,
            StarsTaken,
            OurRank,
            TheirRank
        FROM View_WarProgress
        WHERE WarID = $warID AND OurAttack = 1 ORDER BY OurRank ASC, FirstAttack DESC
    ";

    $records = $db->dbQuery($sql);

    $data = array();
    $i = 0;
    if(!$records) {
        $data['stats'][0] = array(
            'GameName' => '',
            'Attack' => '',
            'StarsTaken' => 0,
            'OurRank' => 0,
            'TheirRank' => 0
        );
    } else {
        while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
            $data['stats'][$i] =
                array(
                    'GameName' => $record['GameName'],
                    'Attack' => $record['Attack'],
                    'StarsTaken' => $record['StarsTaken'],
                    'OurRank' => $record['OurRank'],
                    'TheirRank' => $record['TheirRank']
                );
            $i++;
        }
    }

    $db->Free($records);
    $db->close();

    echo json_encode($data);
