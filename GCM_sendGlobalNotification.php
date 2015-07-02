<?php
    require_once('GCM_Loader.php');
    $db = new BaseDB();

    $message = $_REQUEST["message"];

    $i   = 0;
    $sql = "
      SELECT gcm_regid, game_name FROM dbo.gcm_users
    ";

    $result = $db->dbQuery($sql);
    $data   = array();

    while ($record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH)) {
        $result = send_push_notification($record['gcm_regid'], $message);
    }
    $db->Free($result);
    $db->close();
?>