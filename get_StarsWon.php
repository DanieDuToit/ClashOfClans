<?php
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $warID = $_REQUEST['selectedWarID'];
    $db = new BaseDB();

    $sql = "
        SELECT TheirRank, MAX(StarsTaken) AS StarsTaken
        FROM dbo.View_StarsTaken
        GROUP BY TheirRank, OurAttack, WarID
        HAVING (OurAttack = 1) AND (WarID = $warID)
    ";

    $records = $db->dbQuery($sql);

    $data = array();
    $i = 0;
    if(!$records) {
        $data['starsWon'][0] = array(
            'TheirRank' => 0,
            'StarsTaken' => 0
        );
    } else {
        while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
            $data['starsWon'][$i] =
                array(
                    'TheirRank' => $record['TheirRank'],
                    'StarsTaken' => $record['StarsTaken']
                );
            $i++;
        }
    }

    $db->Free($records);
    $db->close();

    echo json_encode($data);
