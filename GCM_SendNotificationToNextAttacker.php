<?php
    require_once('GCM_Loader.php');
    $db = new BaseDB();

    $sql = "
        SELECT p.GameName, gcmu.gcm_regid
        FROM dbo.OurParticipant AS op INNER JOIN
            dbo.Player AS p ON op.PlayerID = p.PlayerID INNER JOIN
            dbo.gcm_users AS gcmu ON p.GameName = gcmu.game_name
        WHERE op.NextAttacker = 1
    ";

    $result = $db->dbQuery($sql);
    $data   = array();

    while ($record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH)) {
        $registatoin_ids[0] = $record['gcm_regid'];
        $msg                = array("data" => "cal" . $record['GameName'] . " it is your turn to attack!");
        send_push_notification($registatoin_ids, $msg);
    }
    $db->Free($result);
    $db->close();
