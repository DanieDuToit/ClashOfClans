<?php
    include_once("menu.php");

    if (!isset($_SESSION["selectedClanID"])) {
        header("Location: Index.php?err=You must sign in first.");
        die();
    }

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $clanID = $_SESSION["selectedClanID"];
    $selectedWarID = $_REQUEST['selectedWarID'];
    // Set session variables
    $_SESSION["selectedWarID"] = "$selectedWarID";
?>
<html>
<title>Manage Our Attack</title>
</html>
<body>
<h2>Opponent's Attacks admin</h2>

<p>Click the buttons on datagrid toolbar to do crud actions.</p>
<table id="dg" title="Their Attacks" class="easyui-datagrid" style="width:500px;height:400px"
       url="get_theirAttacks.php?"
       toolbar="#toolbar" pagination="true"
       rownumbers="false" fitColumns="true" singleSelect="true">
    <thead>
    <tr>
        <th field="theirparticipant" width="100">Their Partcicpant</th>
        <th field="ourparticipant" width="100">Our Partcicpant</th>
        <th field="firstattack" width="50">First Attack</th>
        <th field="starstaken" width="50">Stars Taken</th>
    </tr>
    </thead>
</table>
<div id="toolbar">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newTheirAttack()">New
        Attack</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editTheirAttack()">Edit
        Attack</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true"
       onclick="destroyTheirAttack()">Remove Attack</a>
</div>
<div id="dlg" class="easyui-dialog" style="width:500px;height:350px;padding:10px 20px"
     closed="true" buttons="#dlg-buttons">
    <div class="ftitle">Attack Information</div>
    <form id="fm" method="post" novalidate>
        <input name="warid" type="hidden">
        <input name="attackid" type="hidden">

        <div class="fitem">
            <label>First Attack?</label>
            <select name="firstattack">
                <option value="1">Yes</option>
                <option value="0">No</option>
            </select>
        </div>
        <div class="fitem">
            <label>Their Participant:</label>
            <select name="theirparticipantid" id="theirparticipantid" required="true">
                <?php
                    $dbBaseClass = new BaseDB();
                    $sql = "SELECT CONCAT('Rank (#',  Rank, ')') As Participant, TheirParticipantID
                        FROM dbo.TheirParticipant
                        WHERE WarID = $selectedWarID";
                    $records = $dbBaseClass->dbQuery($sql);
                    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
                        echo "<option value=\"{$record['TheirParticipantID']}\">" . $record['Participant'] . "</option>";
                    }
                ?>
            </select>
        </div>
        <div class="fitem">
            <label>Our Participant:</label>
            <select name="ourparticipantid" id="ourparticipantid" required="true">
                <?php
                    $dbBaseClass = new BaseDB();
                    $sql = "
                        SELECT
                        CONCAT(dbo.Player.GameName, ' (#', dbo.OurParticipant.Rank, ')') As Participant,
                          dbo.OurParticipant.OurParticipantID
                        FROM
                          dbo.Player INNER JOIN dbo.OurParticipant ON dbo.Player.PlayerID = dbo.OurParticipant.PlayerID
                        WHERE WarID = $selectedWarID";
                    $records = $dbBaseClass->dbQuery($sql);
                    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
                        echo "<option value=\"{$record['OurParticipantID']}\">" . $record['Participant'] . "</option>";
                    }
                ?>
            </select>
        </div>
        <div class="fitem">
            <label for="starstaken">Stars Taken:</label>
            <input name="starstaken" id="starstaken" class="easyui-numberspinner" required="required"
                   data-options="min:0,max:3,editable:true" style="width:40px;">
        </div>
    </form>
</div>
<div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="saveTheirAttack()"
       style="width:90px">Save</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
       onclick="$('#dlg').dialog('close')" style="width:90px">Cancel</a>
</div>
<script type="text/javascript">
    var url;
    function newTheirAttack() {
        $('#dlg').dialog('open').dialog('setTitle', 'Their New Attack');
        $('#fm').form('clear');
        url = 'save_theirAttack.php';
    }
    function editTheirAttack() {
        var row = $('#dg').datagrid('getSelected');
        if (row) {
            $('#dlg').dialog('open').dialog('setTitle', 'Edit Their Attack');
            $('#fm').form('load', row);
            url = 'update_theirAttack.php?id=' + row.attackid;
        }
    }
    function saveTheirAttack() {
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
    function destroyTheirAttack() {
        var row = $('#dg').datagrid('getSelected');
        if (row) {
            $.messager.confirm('Confirm', 'Are you sure you want to destroy this attack?', function (r) {
                if (r) {
                    $.post('destroy_theirAttack.php', {id: row.attackid}, function (result) {
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
    function showVal(newVal) {
        jQuery("#starCount").val(newVal);
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