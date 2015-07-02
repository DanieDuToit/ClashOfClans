<?php
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $selectedWarID = $_REQUEST["selectedWarID"];
    $i = 0;
    $dbBaseClass = new BaseDB();
    $sql = "
        SELECT  GameName, OurRank, TimeOfAttack, 1 AS Priority
          FROM [COC].[dbo].[View_WarProgress] where WarID = $selectedWarID and TimeOfAttack IS NULL AND [FirstAttack] = 1
        UNION
          SELECT  GameName, OurRank, TimeOfAttack, 0 AS Priority
        FROM [COC].[dbo].[View_WarProgress] where WarID = $selectedWarID AND TimeOfAttack IS NULL AND FirstAttack = 0 order by Priority DESC, timeofattack asc, OurRank DESC
    ";
    $records = $dbBaseClass->dbQuery($sql);
    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        $data['orderOfAttacks'][$i++] = array(
            'GameName' => $record['GameName'],
            'OurRank' => $record['OurRank']
        );
    }
    echo json_encode($data);
