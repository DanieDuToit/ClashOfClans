<?php
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $db = new BaseDB();

    $i      = 0;
    $sql    = "
      SELECT PlayerID, GameName FROM dbo.Player WHERE Active = 1 ORDER BY GameName
    ";
    $result = $db->dbQuery($sql);
    $data   = array();
    while ($record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH)) {
        $data['Players'][$i++] = array(
            'playerid' => $record['PlayerID'],
            'gamename' => $record['GameName']
        );
    }
    $db->Free($result);
    $db->close();
    echo json_encode($data);
