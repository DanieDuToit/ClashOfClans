<?php
    include_once("menu.php");
    if (!isset($_SESSION["selectedClanID"])) {
        header("Location: Index.php?err=You must sign in first.");
        die();
    }
    $clanID = $_SESSION["selectedClanID"];
?>

<!DOCTYPE html>
<title>Player admin page</title>
<body>
<h2>Player admin page</h2>
<p>Click the buttons on datagrid toolbar to do crud actions.</p>
<table id="dg" title="Dragonheart COC Players" class="easyui-datagrid" style="width:500px;height:450px"
       url="get_players.php?activeonly=0&clanId=<?php echo $clanID; ?>"
       toolbar="#toolbar" pagination="true"
       rownumbers="false" fitColumns="true" singleSelect="true">
    <thead>
    <tr>
        <!--        <th field="playerid" width="30">ID</th>-->
        <th field="gamename" width="200">Game Name</th>
        <th field="realname" width="200">Real Name</th>
        <th field="active" width="50">Active</th>
    </tr>
    </thead>
</table>
<div id="toolbar">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newPlayer()">New
        Player</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editPlayer()">Edit
        Player</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyPlayer()">Remove
        Player</a>
</div>
<div id="dlg" class="easyui-dialog" style="width:450px;height:300px;padding:10px 20px"
     closed="true" buttons="#dlg-buttons">
    <div class="ftitle">Player Information</div>
    <form id="fm" method="post" novalidate>
        <input name="clanId" id="clanId" type="hidden" value="<?php echo $clanID; ?>">
        <div class="fitem">
            <label></label>
            <input name="playerid" type="hidden">
        </div>
        <div class="fitem">
            <label>Game Name:</label>
            <input name="gamename" class="easyui-textbox" required="true">
        </div>
        <div class="fitem">
            <label>Real Name:</label>
            <input name="realname" class="easyui-textbox">
        </div>
        <div class="fitem">
            <label>Active:</label>
            <select name="active">
                <option value="1">Yes</option>
                <option value="0">No</option>
            </select>
        </div>
    </form>
</div>
<div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="savePlayer()"
       style="width:90px">Save</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
       onclick="$('#dlg').dialog('close')" style="width:90px">Cancel</a>
</div>
<script type="text/javascript">
    var url;
    function newPlayer() {
        $('#dlg').dialog('open').dialog('setTitle', 'New Player');
        $('#fm').form('clear');
        url = 'save_player.php';
    }
    function editPlayer() {
        var row = $('#dg').datagrid('getSelected');
        if (row) {
            $('#dlg').dialog('open').dialog('setTitle', 'Edit Player');
            $('#fm').form('load', row);
            url = 'update_player.php?id=' + row.playerid;
        }
    }
    function savePlayer() {
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
    function destroyPlayer() {
        var row = $('#dg').datagrid('getSelected');
        if (row) {
            $.messager.confirm('Confirm', 'Are you sure you want to destroy this player?', function (r) {
                if (r) {
                    $.post('destroy_player.php', {id: row.playerid}, function (result) {
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