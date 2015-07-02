<?php

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $i = 0;
    $dbBaseClass = new BaseDB();
    $sql = "
        SELECT atk.AttackID, atk.OurAttack, atk.FirstAttack, atk.OurParticipantID,
            atk.TheirParticipantID, atk.StarsTaken, dbo.Player.GameName,
            dbo.TheirParticipant.Rank,
            CONCAT(dbo.Player.GameName, ' (#', part.Rank, ')') As OurParticipant,
            CONCAT('Rank (#',  dbo.TheirParticipant.Rank, ')') As TheirParticipant
        FROM  dbo.TheirParticipant RIGHT OUTER JOIN
            dbo.Attack AS atk ON dbo.TheirParticipant.TheirParticipantID = atk.TheirParticipantID LEFT OUTER JOIN
            dbo.Player INNER JOIN
            dbo.OurParticipant AS part ON dbo.Player.PlayerID = part.PlayerID ON atk.OurParticipantID = part.OurParticipantID

        WHERE (atk.OurAttack = 0)
        ORDER BY atk.TimeOfAttack DESC
    ";
    $records = $dbBaseClass->dbQuery($sql);
    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        $data['theirAttacks'][$i++] = array(
            'ourparticipant' => $record['OurParticipant'],
            'theirparticipant' => $record['TheirParticipant'],
            'attackid' => $record['AttackID'],
            'ourattack' => 0,
            'firstattack' => $record['FirstAttack'],
            'ourparticipantid' => $record['OurParticipantID'],
            'theirparticipantid' => $record['TheirParticipantID'],
            'starstaken' => $record['StarsTaken'],
            'gamename' => $record['GameName']
        );
    }
    echo json_encode($data);
