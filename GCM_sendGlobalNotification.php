<?php
    require_once('GCM_Loader.php');
    $db = new BaseDB();

    $message = $_REQUEST["message"];

    $i    = 0;
    $sql = "
      SELECT gcm_regid, game_name FROM dbo.gcm_users
    ";

    $result = $db->dbQuery($sql);
    $data = array();

    $registatoin_ids = array();
    $i               = 0;
    while ($record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH)) {
        $s                     = $message;
        $s1                    = $record['gcm_regid'];
        $registatoin_ids[$i++] = $record['gcm_regid'];
    }
    $msg    = array("data" => $message);
    $result = send_push_notification($registatoin_ids, $msg);
    $db->Free($result);
    $db->close();
?>