<?php
    include_once("menu.php");

    if (!isset($_SESSION["selectedClanID"])) {
        header("Location: Index.php?err=You must sign in first.");
        die();
    }

    $selectedClanID = $_SESSION["selectedClanID"];

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $contestant = isset($_REQUEST['contestant']) ? $_REQUEST['contestant'] : -1;
    $reset = isset($_REQUEST['reset']) ? 1 : 0;
    if ($reset === 1) {
        echo "<h2 class='error'>Please make sure you select the correct war. This action cannot be reversed.</h2>";
    }
?>
    <html>
    <title>War Selection</title>
    <h2>
        <br>
    <?php
        if ($contestant == 0) {
            echo 'Select The War For Our Contestant Setup';
        } else if ($contestant == 1) {
            echo 'Select The War For Their Contestant Setup';
        } else if ($contestant == 2) {
            echo 'Select The War For Managing Our Attacks';
        } else if ($contestant == 3) {
            echo 'Select The War For Managing Their Attacks';
        } else if ($reset = 1) {
            echo 'Select The War That you want to Reset Or Initialize';
        }
    ?>
    </h2>
    </html>
    <form id="form1" name="form1" method="post">
        <label for="select">Select:</label>
        <select name="selectedWarID" id="selectedWarID">
            <?php
                $dbBaseClass = new BaseDB();
                $sql = "SELECT WarID ,CONVERT(VARCHAR(30), [Date], 13) AS dateString FROM War WHERE ClanId = $selectedClanID ORDER BY WarID DESC";
                $records = $dbBaseClass->dbQuery($sql);
                while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
                    echo "<option value={$record['WarID']}>War Date:{$record['dateString']}</option>";
                }
            ?>
        </select>
        <br>
        <br>
        <input name="submit" type="submit" id="submit" formaction=
            <?php
                if ($contestant == 0) {
                    echo '"OurContestantsSetup.php"';
                } else if ($contestant == 1) {
                    echo '"TheirContestantsSetup.php"';
                } else if ($contestant == 2) {
                    echo '"ManageOurAttack.php"';
                } else if ($contestant == 3) {
                    echo '"ManageTheirAttack.php"';
                } else if ($reset = 1) {
                    echo '"InitializeWar.php"';
                }
            ?>
        value="Select">
        <br>
    </form>
<?php
/**
 * Created by PhpStorm.
 * User: Danie
 * Date: 2015/05/31
 * Time: 03:30 AM
 */