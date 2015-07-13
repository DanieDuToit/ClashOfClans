<?php
    /**
     * Created by PhpStorm.
     * User: Danie
     * Date: 2015/06/07
     * Time: 10:35 AM
     */

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $warID = $_REQUEST['WarID'];
    $db = new BaseDB();

    $sql_callFunc = "SELECT (SELECT dbo.[GetNumberOfParticipants]($warID)) AS result";
    $result = $db->dbQuery($sql_callFunc);

    $record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);
    if ($record == false) {
        $err = dbGetErrorMsg();
    }
    $db->Free($result);
    $db->close();
    $data['number'][0] = array('counter' => $record['result']);
    echo json_encode($data);