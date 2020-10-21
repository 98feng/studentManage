<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


    <script type="text/javascript">

        $(function () {

            //为创建按钮绑定事件，打开添加操作的模态窗口
            $("#addBtn").click(function () {

                $(".time").datetimepicker({
                    minView: "month",
                    language: 'zh-CN',
                    format: 'yyyy-mm-dd',
                    autoclose: true,
                    todayBtn: true,
                    pickerPosition: "bottom-left"
                });
                /*

                    操作模态窗口的方式：

                        需要操作的模态窗口的jquery对象，调用modal方法，为该方法传递参数 show:打开模态窗口   hide：关闭模态窗口


                 */

                //走后台，目的是为了取得用户信息列表，为所有者下拉框铺值
                $.ajax({

                    url: "workbench/activity/getUserList.do",
                    type: "get",
                    dataType: "json",
                    success: function (data) {

                        /*

                            data
                                [{"id":?,"name":?,"loginAct":?.......},{2},{3}...]

                         */

                        var html = "<option></option>";

                        //遍历出来的每一个n，就是每一个user对象
                        $.each(data, function (i, n) {

                            html += "<option value='" + n.id + "'>" + n.name + "</option>";

                        })

                        $("#create-owner").html(html);
                        //在js中使用el表达式，el表达式一定要套用在字符串中
                        var id = "${user.id}";

                        $("#create-owner").val(id);
                        //所有者下拉框处理完毕后，展现模态窗口
                        $("#createActivityModal").modal("show");

                    }

                })


            })


            //为保存按钮绑定事件，执行添加操作
            $("#saveBtn").click(function () {

                $.ajax({

                    url: "workbench/activity/creatActivity.do",
                    data: {

                        "owner": $.trim($("#create-owner").val()),
                        "name": $.trim($("#create-name").val()),
                        "gender": $.trim($("#create-gender").val()),
                        "grade": $.trim($("#create-grade").val()),
                        "stunum": $.trim($("#create-stunum").val()),
                        "startDate": $.trim($("#create-startDate").val()),
                        "endDate": $.trim($("#create-endDate").val()),
                        "description": $.trim($("#create-description").val())

                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        /*

                            data
                                {"success":true/false}

                         */
                        if (data.success) {


                            //做完添加操作后，应该回到第一页，维持每页展现的记录数

                            pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


                            $("#activityAddForm")[0].reset();

                            //关闭添加操作的模态窗口
                            $("#createActivityModal").modal("hide");


                        } else {

                            alert("添加学生信息活动失败");

                        }


                    }

                })

            })


            //页面加载完毕后触发一个方法
            //默认展开列表的第一页，每页展现两条记录
            pageList(1, 2);

            //为查询按钮绑定事件，触发pageList方法
            $("#searchBtn").click(function () {
                /*

                    点击查询按钮的时候，我们应该将搜索框中的信息保存起来,保存到隐藏域中


                 */

                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-gender").val($.trim($("#search-gender").val()));
                $("#hidden-grade").val($.trim($("#search-grade").val()));
                $("#hidden-startDate").val($.trim($("#search-startDate").val()));
                $("#hidden-endDate").val($.trim($("#search-endDate").val()));

                pageList(1, 2);

            })


            //为全选的复选框绑定事件，触发全选操作
            $("#qx").click(function () {

                $("input[name=xz]").prop("checked", this.checked);

            })


            $("#activityBody").on("click", $("input[name=xz]"), function () {

                $("#qx").prop("checked", $("input[name=xz]").length == $("input[name=xz]:checked").length);

            })

            //为删除按钮绑定事件，执行学生信息活动删除操作
            $("#deleteBtn").click(function () {

                //找到复选框中所有挑√的复选框的jquery对象
                var $xz = $("input[name=xz]:checked");

                if ($xz.length == 0) {

                    alert("请选择需要删除的记录");

                    //肯定选了，而且有可能是1条，有可能是多条
                } else {


                    if (confirm("确定删除所选中的记录吗？")) {

                        //url:workbench/activity/delete.do?id=xxx&id=xxx&id=xxx

                        //拼接参数
                        var param = "";

                        //将$xz中的每一个dom对象遍历出来，取其value值，就相当于取得了需要删除的记录的id
                        for (var i = 0; i < $xz.length; i++) {

                            param += "id=" + $($xz[i]).val();

                            //如果不是最后一个元素，需要在后面追加一个&符
                            if (i < $xz.length - 1) {

                                param += "&";

                            }

                        }

                        //alert(param);
                        $.ajax({

                            url: "workbench/activity/delete.do",
                            data: param,
                            type: "post",
                            dataType: "json",
                            success: function (data) {

                                /*

                                    data
                                        {"success":true/false}

                                 */
                                if (data.success) {

                                    //删除成功后
                                    //回到第一页，维持每页展现的记录数
                                    pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


                                } else {

                                    alert("删除学生信息活动失败");

                                }


                            }

                        })


                    }


                }


            })


            //为修改按钮绑定事件，打开修改操作的模态窗口
            $("#editBtn").click(function () {

                var $xz = $("input[name=xz]:checked");

                if ($xz.length == 0) {

                    alert("请选择需要修改的记录");

                } else if ($xz.length > 1) {

                    alert("只能选择一条记录进行修改");

                    //肯定只选了一条
                } else {

                    var id = $xz.val();

                    $.ajax({

                        url: "workbench/activity/getUserListAndActivity.do",
                        data: {

                            "id": id

                        },
                        type: "get",
                        dataType: "json",
                        success: function (data) {

                            /*

                                data
                                    用户列表
                                    学生信息活动对象

                                    {"uList":[{用户1},{2},{3}],"a":{学生信息活动}}

                             */

                            //处理所有者下拉框
                            var html = "<option></option>";

                            $.each(data.uList, function (i, n) {

                                html += "<option value='" + n.id + "'>" + n.name + "</option>";

                            })

                            $("#edit-owner").html(html);


                            //处理单条activity
                            $("#edit-id").val(data.a.id);
                            $("#edit-name").val(data.a.name);
                            $("#edit-owner").val(data.a.owner);
                            $("#edit-gender").val(data.a.gender);
                            $("#edit-grade").val(data.a.grade);
                            $("#edit-stunum").val(data.a.stunum);
                            $("#edit-startDate").val(data.a.startDate);
                            $("#edit-endDate").val(data.a.endDate);
                            $("#edit-description").val(data.a.description);

                            //所有的值都填写好之后，打开修改操作的模态窗口
                            $("#editActivityModal").modal("show");

                        }

                    })

                }

            })
            $("#updateBtn").click(function () {

                $.ajax({

                    url: "workbench/activity/update.do",
                    data: {

                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "name": $.trim($("#edit-name").val()),
                        "gender": $.trim($("#edit-gender").val()),
                        "grade": $.trim($("#edit-grade").val()),
                        "stunum": $.trim($("#edit-stunum").val()),
                        "startDate": $.trim($("#edit-startDate").val()),
                        "endDate": $.trim($("#edit-endDate").val()),
                        "description": $.trim($("#edit-description").val())

                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        /*

                            data
                                {"success":true/false}

                         */
                        if (data.success) {
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


                            //关闭修改操作的模态窗口
                            $("#editActivityModal").modal("hide");


                        } else {

                            alert("修改学生信息活动失败");

                        }


                    }

                })

            })


        });

        function pageList(pageNo, pageSize) {

            //将全选的复选框的√干掉
            $("#qx").prop("checked", false);

            //查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-gender").val($.trim($("#hidden-gender").val()));
            $("#search-grade").val($.trim($("#hidden-grade").val()));
            $("#search-stunum").val($.trim($("#hidden-stunum").val()));
            $("#search-startDate").val($.trim($("#hidden-startDate").val()));
            $("#search-endDate").val($.trim($("#hidden-endDate").val()));

            $.ajax({

                url: "workbench/activity/pageList.do",
                data: {

                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "gender": $.trim($("#search-gender").val()),
                    "grade": $.trim($("#search-grade").val()),
                    "stunum": $.trim($("#search-stunum").val()),
                    "startDate": $.trim($("#search-startDate").val()),
                    "endDate": $.trim($("#search-endDate").val())

                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    /*

                        data

                            学生信息活动信息列表
                            [{学生信息活动1},{2},{3}] List<Activity> aList
                            一会分页插件需要的：查询出来的总记录数
                            {"total":100} int total

                            {"total":100,"dataList":[{学生信息活动1},{2},{3}]}

                     */

                    var html = "";

                    //每一个n就是每一个学生信息活动对象
                    $.each(data.dataList, function (i, n) {

                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.gender + '</td>';
                        html += '<td>' + n.grade + '</td>';
                        html += '<td>' + n.stunum + '</td>';
                        html += '<td>' + n.startDate + '</td>';
                        html += '<td>' + n.endDate + '</td>';
                        html += '</tr>';

                    })

                    $("#activityBody").html(html);

                    //计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                    //数据处理完毕后，结合分页查询，对前端展现分页信息
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        //该回调函数时在，点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });


                }

            })

        }

    </script>
</head>
<body>

<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-gender"/>
<input type="hidden" id="hidden-grade"/>
<input type="hidden" id="hidden-stunum"/>
<input type="hidden" id="hidden-startDate"/>
<input type="hidden" id="hidden-endDate"/>


<!-- 修改学生信息活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改学生信息活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <input type="hidden" id="edit-id"/>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">管理员<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">


                            </select>
                        </div>
                        <label  class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-gender">
                                <option value ="男">男</option>
                                <option value ="女">女</option>
                            </select>
                        </div>
                        <br>
                        <br>
                        <label class="col-sm-2 control-label">学生姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                        <label  class="col-sm-2 control-label">班级</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-grade">
                        </div>

                    </div>

                    <div class="form-group">

                        <label   class="col-sm-2 control-label">学号</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-stunum">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate">
                        </div>
                        <label  class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 创建信息活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建学生信息</h4>
            </div>
            <div class="modal-body">

                <form id="activityAddForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label class="col-sm-2 control-label">管理员<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">


                            </select>
                        </div>
                        <label  class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-gender">
                                <option value ="男">男</option>
                                <option value ="女">女</option>
                            </select>
                        </div>
                        <br>
                        <br>
                        <label class="col-sm-2 control-label">学生姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                        <label  class="col-sm-2 control-label">班级</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-grade">
                        </div>

                    </div>

                    <div class="form-group">

                        <label   class="col-sm-2 control-label">学号</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-stunum">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate">
                        </div>
                        <label  class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate">
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>学生信息活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">学生姓名</div>
                        <input class="form-control" type="text" id="search-name">
                        <div class="input-group-addon">管理员</div>
                        <input class="form-control" type="text" id="search-owner">
                        <div class="input-group-addon">性别</div>
                            <select class="form-control" id="search-gender">
                                <option selected value ="男"style="width: 60px">男</option>
                                <option value ="女" style="width:60px">女</option>
                                <option value ="" style="width:60px">空</option>
                            </select>
                        <div class="input-group-addon">班级</div>
                        <input class="form-control" type="text" id="search-grade">
                        <div class="input-group-addon">学号</div>
                        <input class="form-control" type="text" id="search-stunum">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate"/>
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate">
                    </div>
                </div>
                <button type="button" id="searchBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 30%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>
                    创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>学生姓名</td>
                    <td>管理员</td>
                    <td>性别</td>
                    <td>班级</td>
                    <td>学号</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--<tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="activityPage"></div>

        </div>

    </div>

</div>
</body>
</html>