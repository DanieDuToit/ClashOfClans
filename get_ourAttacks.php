<?php
    session_start();
    $selectedWarID = $_SESSION["selectedWarID"];

    //

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $i       = 0;
    $dbBaseClass = new BaseDB();
    $sql     = "
        SELECT atk.AttackID, atk.OurAttack, atk.FirstAttack, atk.OurParticipantID,
            atk.TheirParticipantID, atk.StarsTaken, dbo.Player.GameName,
            dbo.TheirParticipant.Rank,
            CONCAT(dbo.Player.GameName, ' (#', part.Rank, ')') As OurParticipant,
            CONCAT('Rank (#',  dbo.TheirParticipant.Rank, ')') As TheirParticipant
        FROM dbo.Attack AS atk INNER JOIN
            dbo.OurParticipant AS part ON atk.OurParticipantID = part.OurParticipantID INNER JOIN
            dbo.Player ON part.PlayerID = dbo.Player.PlayerID LEFT OUTER JOIN
            dbo.TheirParticipant ON atk.TheirParticipantID = dbo.TheirParticipant.TheirParticipantID
        WHERE (atk.OurAttack = 1) AND (atk.WarID = $selectedWarID)
        ORDER BY atk.TimeOfAttack DESC
    ";
    $records = $dbBaseClass->dbQuery($sql);
    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        $data[$i++] = array(
            'ourparticipant'   => $record['OurParticipant'],
            'theirparticipant' => $record['TheirParticipant'],
            'attackid'         => $record['AttackID'],
            'ourattack'        => $record['OurAttack'],
            'firstattack'      => $record['FirstAttack'],
            'ourparticipantid' => $record['OurParticipantID'],
            'theirparticipantid' => $record['TheirParticipantID'],
            'starstaken'       => $record['StarsTaken'],
            'gamename'         => $record['GameName']
        );
    }
    echo json_encode($data);
