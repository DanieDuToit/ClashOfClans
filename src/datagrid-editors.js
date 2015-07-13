/**
 * Created by dutoitd1 on 2015/05/28.
 */
$.extend($.fn.datagrid.defaults.editors,
    {
        workingcheckbox: {
            init: function (container, options) {
                var input = $('<input type="checkbox">').appendTo(container);
                return input;
            },
            getValue: function (target) {
                return $(target).prop('checked');
            },
            setValue: function (target, value) {
                $(target).prop('checked', value);
            },
            editor: {
                type: 'workingcheckbox',
                required: true
            }
        }

    });