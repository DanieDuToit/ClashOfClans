<?php
/**
 * Created by PhpStorm.
 * User: dutoitd1
 * Date: 2015/05/27
 * Time: 11:54 AM
 */
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $i = 0;
    $dbBaseClass = new BaseDB();
    $activeOnly = $_REQUEST['activeonly'];
    if ($activeOnly === 1) {
        $records     = $dbBaseClass->dbQuery("SELECT PlayerID, GameName, RealName, Active FROM Player WHERE active=1");
    } else {
        $records     = $dbBaseClass->dbQuery("SELECT PlayerID, GameName, RealName, Active FROM Player");
    }


    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        $data[$i++] = array (
            'playerid' => $record['PlayerID'],
            'gamename' => $record['GameName'],
            'realname' => $record['RealName'],
            'active' => $record['Active']
        );
    }
    echo json_encode($data);
