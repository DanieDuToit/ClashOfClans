<?php
    include_once("menu.php");
    if (!isset($_SESSION["selectedClanID"])) {
        header("Location: Index.php?err=You must sign in first.");
        die();
    }
    $clanID = $_SESSION["selectedClanID"];
    $clanName = $_SESSION["ClanName"];
?>
<html>
<title>Wars admin page</title>
</html>
<body>
<p>Click the buttons on datagrid toolbar to do crud actions.</p>
<table id="dg" title="Dragonheart COC Wars" class="easyui-datagrid" style="width:400px;height:450px"
       url="get_wars.php?"
       toolbar="#toolbar" pagination="true"
       rownumbers="false" fitColumns="true" singleSelect="true">
    <thead>
    <tr>
        <input id="warid" hidden="hidden">
        <th field="wardate" width="150">War Date</th>
        <th field="numberofparticipants" width="150">Number of participants</th>
        <th field="active" width="50">Active</th>
    </tr>
    </thead>
</table>
<div id="toolbar">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newWar()">New
        War</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editWar()">Edit
        War</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyWar()">Remove
        War</a>
</div>
<div id="dlg" class="easyui-dialog" style="width:450px;height:350px;padding:5px 5px"
     closed="true" buttons="#dlg-buttons">
    <div class="ftitle">War Information</div>
    <form id="fm" method="post" novalidate>
        <div class="fitem">
            <label></label>
            <input name="warid" type="hidden">
        </div>
        <div class="fitem">
            <label for="wardate">War Date:</label>
            <input type="date" id="wardate" name="wardate" class="easyui-textbox" required="true">
        </div>
        <div class="fitem">
            <label for="numberofparticipants">Number_of_participants:</label>
            <input name="numberofparticipants" id="numberofparticipants" class="easyui-numberspinner"
                   style="width:60px;" required="required" data-options="min:10,max:50,editable:true">
        </div>
        <div class="fitem">
            <label for="warswewon">Wars we won:</label>
            <input name="warswewon" id="warswewon" class="easyui-numberspinner" style="width:60px;" required="required"
                   data-options="editable:true">
        </div>
        <div class="fitem">
            <label for="warstheywon">Wars they won:</label>
            <input name="warstheywon" id="warstheywon" class="easyui-numberspinner" style="width:60px;"
                   required="required" data-options="editable:true">
        </div>
        <div class="fitem">
            <label for="active">Active:</label>
            <select name="active" id="active">
                <option value="1">Yes</option>
                <option value="0">No</option>
            </select>
        </div>
    </form>
</div>
<div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6" iconCls="icon-ok" onclick="saveWar()" style="width:90px">Save</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"
       onclick="$('#dlg').dialog('close')" style="width:90px">Cancel</a>
</div>
<script type="text/javascript">
    var url;
    function newWar() {
        $('#dlg').dialog('open').dialog('setTitle', 'New War');
        $('#fm').form('clear');
        url = 'save_war.php';
    }
    function editWar() {
        var row = $('#dg').datagrid('getSelected');
        if (row) {
            $('#dlg').dialog('open').dialog('setTitle', 'Edit War');
            $('#fm').form('load', row);
            url = 'update_war.php?id=' + row.playerid;
        }
    }
    function saveWar() {
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
    function destroyWar() {
        var row = $('#dg').datagrid('getSelected');
        if (row) {
            $.messager.confirm('Confirm', 'Are you sure you want to destroy this war?', function (r) {
                if (r) {
                    $.post('destroy_war.php', {id: row.warid}, function (result) {
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