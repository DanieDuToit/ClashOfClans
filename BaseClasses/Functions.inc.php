<?php
    include_once("BaseDB.class.php");
    include_once("Database.class.php");

    class WarStruct
    {
        public $id;
        public $dateString;
    }

    function dbGetErrorMsg()
    {
        $retVal = sqlsrv_errors();
        $retVal = $retVal[0]["message"];
        $retVal = preg_replace('/\[Microsoft]\[SQL Server Native Client [0-9]+.[0-9]+](\[SQL Server\])?/', '', $retVal);
        return $retVal;
    }//dbGetErrorMsg()

    function getWarLineForSelect()
    {
        $dbBaseClass = new BaseDB();
        $sql         = "SELECT WarID ,CONVERT(VARCHAR(30), [Date], 13) AS dateString FROM War WHERE Active = 1";
        $records     = $dbBaseClass->dbQuery($sql);
        $returnString = "";
        while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
            $returnString .= "<option value=\"{$record['WarID']}\">\"{$record['WarID']}\"</option>";
        }
        return $returnString;
    }

    function SendNotificationToNextAttacker()
    {
        $db = new BaseDB();

        $sql = "
            SELECT p.GameName, gcmu.gcm_regid
            FROM dbo.OurParticipant AS op INNER JOIN
                dbo.Player AS p ON op.PlayerID = p.PlayerID INNER JOIN
                dbo.gcm_users AS gcmu ON p.GameName = gcmu.game_name
            WHERE op.NextAttacker = 1
        ";

        $result = $db->dbQuery($sql);

        while ($record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH)) {
            $registatoin_ids[0] = $record['gcm_regid'];
            $msg                = array("data" => "cal" . $record['GameName'] . " it is your turn to attack!");
            send_push_notification($registatoin_ids, $msg);
        }
        $db->Free($result);
        $db->close();

    }