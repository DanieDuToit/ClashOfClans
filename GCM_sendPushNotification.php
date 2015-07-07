<?php
    require_once('GCM_Loader.php');
    $db = new BaseDB();

    $message  = $_REQUEST["message"];
    $gameName = $_REQUEST["gameName"];

    $i   = 0;
    $sql = "";
    if ($gameName == "all") {
        $sql = "
      SELECT gcm_regid, game_name FROM dbo.gcm_users
    ";
    } else {
        $sql = "
      SELECT gcm_regid, game_name FROM dbo.gcm_users WHERE game_name = '$gameName'
    ";
    }

    $result = $db->dbQuery($sql);
    $data   = array();

    $registatoin_ids = array();
    $i               = 0;
    while ($record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH)) {
        $registatoin_ids[$i++] = $record['gcm_regid'];
    }
    $db->Free($result);
    $db->close();
    $msg    = array("data" => $message);
    // TODO Remove
    //    $result = send_push_notification($registatoin_ids, $msg);
?>