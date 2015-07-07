<?php
    require_once('GCM_Loader.php');
    $db = new BaseDB();

    $sql = "
      SELECT gcm_regid, game_name FROM dbo.gcm_users
    ";

    $result = $db->dbQuery($sql);
    $data   = array();

    $registatoin_ids = array();

    while ($record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH)) {
        $registatoin_ids[0] = $record['gcm_regid'];
        $msg                = array("data" => "ann" . $record['game_name'] . " this is a test message. Please notify that you have received it via the Whatsapp Chat group. Thank you.");
        //        send_push_notification($registatoin_ids, $msg);
    }
    $db->Free($result);
    $db->close();
?>