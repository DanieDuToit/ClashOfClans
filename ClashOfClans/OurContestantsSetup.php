<?php
    session_start();
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $selectedWarID = $_REQUEST['selectedWarID'];
    // Set session variables
    $_SESSION["selectedWarID"] = "$selectedWarID";
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dragonheart's C.O.C. Our Contestant's Setup</title>
    <link rel="stylesheet" type="text/css" href="themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="themes/icon.css">
    <link rel="stylesheet" type="text/css" href="themes/color.css">
    <!--    <link rel="stylesheet" type="text/css" href="demo/demo.css">-->
    <script type="text/javascript" src="src/jquery.min.js"></script>
    <script type="text/javascript" src="src/jquery.easyui.min.js"></script>
</head>
<body>
<h2>Dragonheart's C.O.C. Our Contestant's Setup</h2>

<div class="fitem">
    <label>WAR:</label>
    <select name="warid" id="warid"">
    <?php
        $dbBaseClass = new BaseDB();
        $sql = "SELECT WarID ,CONVERT(VARCHAR(30), [Date], 13) AS dateString FROM War WHERE WarID = $selectedWarID";
        $records = $dbBaseClass->dbQuery($sql);
        while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
            echo "<option value={$record['WarID']}>War ID:{$record['WarID']} => {$record['dateString']}</option>";
        }
    ?>
    </select>
</div>


<p>Click the buttons on datagrid toolbar to do crud actions.</p>
<table id="dg" title="Our Contestants Setup" class="easyui-datagrid" style="width:700px;height:450px"
       url="get_participantsForWar.php?selectedWarID=<?php $selectedWarID ?>"
       toolbar="#toolbar" pagination="true"
       rownumbers="false" fitColumns="true" singleSelect="true">
    <thead>
    <tr>
        <th field="playerid" width="30">ID</th>
        <th field="gamename" width="100">Game Name</th>
        <th field="realname" width="100">Real Name</th>
        <th field="rank" width="40">Rank</th>
        <th field="experience" width="40">Experience</th>
        <th field="townhalllevel" width="40">T/H Level</th>
        <th field="warid" width="40">War ID</th>
    </tr>
    </thead>
</table>
<div id="toolbar">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newContestant()">New
        Player</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editContestant()">Edit
        Player</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true"
       onclick="destroyContestant()">Remove Player</a>
</div>
<div id="dlg" class="easyui-dialog" style="width:500px;height:350px;padding:10px 20px"
     closed="true" buttons="#dlg-buttons">
    <div class="ftitle">Player Information</div>
    <form id="fm" method="post" novalidate>
        <input type="hidden" name="selectedWarID" id="selectedWarID" value="<?php $selectedWarID ?>">
        <input type="hidden" name="ourparticipantid" id="ourparticipantid">
<!--        <input name="playerid" type="hidden">-->

        <div class="fitem">
            <label>Contestant:</label>
            <select name="playerid" id="playerid"">
            <?php
                $dbBaseClass = new BaseDB();
                $sql = "SELECT PlayerID, GameName FROM Player WHERE Active = 1";
                $records = $dbBaseClass->dbQuery($sql);
                while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
                    echo "<option value=\"{$record['PlayerID']}\">" . $record['GameName'] . "</option>";
                }
            ?>
            </select>
        </div>

        <div class="fitem">
            <label>Rank:</label>
            <select name="rank" required="true">
                <?php
                    for ($i = 1; $i <= 50; $i++) {
                        echo "<option value=\"$i\">" . $i . "</option>";
                    }
                ?>
            </select>
        </div>
        <div class="fitem">
            <label>Experience:</label>
            <input name="experience" class="easyui-textbox" required="true">
        </div>
        <div class="fitem">
            <label>Townhall Level</label>
            <input name="townhalllevel" class="easyui-textbox" required="true">
        </div>
        <div class="fitem">
            <label>Participate?</label>
            <select name="participate">
                <option value="1">Yes</option>
                <option value="0">No</option>
            </select>
        </div>
</div>
</form>
</div>
<div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="saveContestant()"
       style="width:90px">Save</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
       onclick="javascript:$('#dlg').dialog('close')" style="width:90px">Cancel</a>
</div>
<script type="text/javascript">
    var url;
    function newContestant() {
        $('#dlg').dialog('open').dialog('setTitle', 'New Player');
        $('#fm').form('clear');
        url = 'save_contestant.php';
    }

    function editContestant() {
        var row = $('#dg').datagrid('getSelected');
        if (row) {
            $('#dlg').dialog('open').dialog('setTitle', 'Edit Player');
            $('#fm').form('load', row);
            url = 'update_OurParticipant.php?id=' + row.playerid;
        }
    }
    function saveContestant() {
        $('#fm').form('submit', {
            url: url,
            onSubmit: function () {
                return $(this).form('validate');
            },
            success: function (result) {
                var result = eval('(' + result + ')');
                if (result.errorMsg) {
                    $.messager.show({
                        title: 'Error',
                        msg: result.errorMsg
                    });
                } else {
                    $('#dlg').dialog('close'); // close the dialog
                    $('#dg').datagrid('reload'); // reload the player data
                }
            }
        });
    }
    function destroyContestant() {
        var row = $('#dg').datagrid('getSelected');
        if (row) {
            $.messager.confirm('Confirm', 'Are you sure you want to destroy this player?', function (r) {
                if (r) {
                    $.post('destroy_OurParticipant.php', {id: row.ourparticipantid}, function (result) {
                        if (result.success) {
                            $('#dg').datagrid('reload'); // reload the player data
                        } else {
                            $.messager.show({ // show error message
                                title: 'Error',
                                msg: result.errorMsg
                            });
                        }
                    }, 'json');
                }
            });
        }
    }

</script>
<style type="text/css">
    #fm {
        margin: 0;
        padding: 10px 30px;
    }

    .ftitle {
        font-size: 14px;
        font-weight: bold;
        padding: 5px 0;
        margin-bottom: 10px;
        border-bottom: 1px solid #ccc;
    }

    .fitem {
        margin-bottom: 5px;
    }

    .fitem label {
        display: inline-block;
        width: 150px;
    }

    .fitem input {
        width: 160px;
    }
</style>
</body>
</html>