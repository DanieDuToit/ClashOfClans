<?php
    require_once('GCM_Loader.php');

    $db = new BaseDB();

    $WarID = $_REQUEST["selectedWarID"];

    $OurAttack        = 1;
    $OurParticipantID = $_REQUEST['ourparticipantid'];
    $TheirParticipantID = 0;
    if (isset($_REQUEST['theirparticipantid'])) {
        $TheirParticipantID = $_REQUEST['theirparticipantid'];
    }
    // If their rank has been passed then we must get theirParticipantID
    if (isset($_REQUEST['theirRank'])) {
        $sql    = "
            SELECT TheirParticipantID
            FROM dbo.TheirParticipant
            WHERE (Rank = {$_REQUEST['theirRank']}) AND (WarID = $WarID)
        ";
        $result = $db->dbQuery($sql);
        $record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);
        $TheirParticipantID = $record['TheirParticipantID'];
    }
    $StarsTaken = $_REQUEST['starstaken'];
    $FirstAttack = 0; // By default the second attack

    // See if this is the first or second attack
    $sql = "SELECT COUNT(AttackID) AS counter FROM Attack WHERE (WarID = $WarID) AND (OurParticipantID = $OurParticipantID) AND (ISNULL(StarsTaken, - 1) <> - 1) GROUP BY StarsTaken";
    $result = $db->dbQuery($sql);
    $record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);
    if ($record['counter'] == 0) {
        $FirstAttack = 1;
    } else if ($record['counter'] > 1) { // There is already 2 attacks
        echo json_encode([
            'errorMsg' => 'There is already 2 attacks for this Rank'
        ]);
        goto DONE;
    }

    $sql = "
        UPDATE Attack
        SET TheirParticipantID = $TheirParticipantID, StarsTaken = $StarsTaken,
          TimeOfAttack = GETDATE()
        WHERE OurParticipantID = $OurParticipantID
        AND FirstAttack = $FirstAttack AND OurAttack = 1
    ";
    $result = $db->dbQuery($sql);
    if ($result == false) {
        echo json_encode([
            'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
        ]);
        goto DONE;
    } else {

        // If this is the first attack
        //        $sqlIdentity = "select @@identity as EntityId";
        //        $resultID    = sqlsrv_query(Database::getInstance()->getConnection(), $sqlIdentity);
        //        $rowIdentity = sqlsrv_fetch_array($resultID);
        //        $AttackID    = $rowIdentity["EntityId"];
        // SET the "NextAttacker" flag (whether it is set or not)

        // Get the next player that must attack after this one
        $sql    = "
            SELECT TOP(1) B.OurParticipantID FROM
                (SELECT TOP (2) A.OurParticipantID, A.OurRank FROM
                    (SELECT  GameName, OurRank, TimeOfAttack, OurParticipantID, 1 AS Priority
                        FROM [COC].[dbo].[View_WarProgress] WHERE WarID = $WarID AND TimeOfAttack IS NULL AND [FirstAttack] = 1
                    UNION
                        SELECT  GameName, OurRank, TimeOfAttack, OurParticipantID, 0 AS Priority
                    FROM [COC].[dbo].[View_WarProgress] WHERE WarID = $WarID AND TimeOfAttack IS NULL AND FirstAttack = 0
                    ) AS A  ORDER BY A.Priority DESC, A.timeofattack ASC, A.OurRank DESC
                ) AS B ORDER BY B.OurRank DESC
        ";
        $result = $db->dbQuery($sql);
        if ($result == false) {
            echo json_encode([
                'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
            ]);
            goto DONE;
        } else {
            $record           = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);
            $OurParticipantID = $record['OurParticipantID'];
            // Set the NextAttacker flag for the player so that he can be prompt to attack
            $sql    = "
                UPDATE OurParticipant SET NextAttacker = 1
                WHERE OurParticipantID = $OurParticipantID
            ";
            $result = $db->dbQuery($sql);
            if (!$result) {
                $data['result'][0] =
                    array(
                        'success' => 0,
                        'error'   => dbGetErrorMsg()
                    );
            } else {
                array(
                    'success' => 1,
                    'error'   => ''
                );
                SendNotificationToNextAttacker();
            }
        }
    }
    DONE: