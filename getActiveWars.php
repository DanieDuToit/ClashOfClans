<?php
/**
 * Created by PhpStorm.
 * User: Danie
 * Date: 2015/06/06
 * Time: 08:31 AM
 */
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $i = 0;
    $dbBaseClass = new BaseDB();

    $sql = "
      SELECT CONVERT(CHAR(11), Date, 106) AS Date, WarID
      FROM dbo.War
      WHERE (Active = 1)
    ";

    $records = $dbBaseClass->dbQuery($sql);
    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        $data['wars'][$i++] = array (
            'Date' => $record['Date'],
            'WarID' => $record['WarID']
        );
    }
    echo json_encode($data);
