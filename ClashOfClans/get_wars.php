<?php

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $i = 0;
    $dbBaseClass = new BaseDB();
    $sql = "SELECT WarID, Date, NumberOfParticipants, WarsWeWon, WarsTheyWon, Active FROM War ORDER BY WarID";
    $records = $dbBaseClass->dbQuery($sql);
    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        $data[$i++] = array(
            'warid' => $record['WarID'],
            'wardate' => $record['Date'],
            'numberofparticipants' => $record['NumberOfParticipants'],
            'warswewon' => $record['WarsWeWon'],
            'warstheywon' => $record['WarsTheyWon'],
            'active' => $record['Active']
        );
    }
    echo json_encode($data);
