<?php
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $warID = $_REQUEST['selectedWarID'];
    $db = new BaseDB();

    $sql = "
        SELECT [GameName]
            ,[OurRank]
            ,[OurExperience]
            ,[OurTownhall]
            ,[TheirRank]
            ,[TheirExperience]
            ,[TheirTownhall]
        FROM [COC].[dbo].[View_OurStatsVSTheirStats]
        WHERE WarID = $warID ORDER BY OurRank
    ";

    $records = $db->dbQuery($sql);

    $data = array();
    $i = 0;
    if (!$records) {
        $data['stats'][0] = array(
            'GameName' => '',
            'OurRank' => 0,
            'OurExperience' => 0,
            'OurTownhall' => 0,
            'TheirRank' => 0,
            'TheirExperience' => 0,
            'TheirTownhall' => 0,
        );
    } else {
        while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
            $data['stats'][$i] =
                array(
                    'GameName' => $record['GameName'],
                    'OurRank' => $record['OurRank'],
                    'OurExperience' => $record['OurExperience'],
                    'OurTownhall' => $record['OurTownhall'],
                    'TheirRank' => $record['TheirRank'],
                    'TheirExperience' => $record['TheirExperience'],
                    'TheirTownhall' => $record['TheirTownhall']
                );
            $i++;
        }
    }

    $db->Free($records);
    $db->close();

    echo json_encode($data);
