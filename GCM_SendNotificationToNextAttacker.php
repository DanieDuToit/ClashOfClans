<?php
    require_once('GCM_Loader.php');

    $clanID = $_REQUEST['clanID'];

    SendNotificationToNextAttacker($clanID);
