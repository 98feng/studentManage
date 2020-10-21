<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


    <script>

        $(function () {
            if (window.top != window) {
                window.top.location = window.location;
            }
            //页面加载完毕后，将用户文本框中的内容清空
            $("#loginAct").val("");
            $("#loginPwd").val("");
            $("#loginAct").focus();

            $("#loginBtn").click(function () {
                login();
            })
            $(window).keydown(function (event) {
                if (event.keyCode == 13) {
                    login();
                }
            })
        })

        function login() {
            var loginAct = $.trim($("#loginAct").val())
            var loginPwd = $.trim($("#loginPwd").val())

            if (loginAct == "" || loginPwd == "") {
                $("#msg").html("账号密码不能为空");
                //如果账号密码为空，则需要及时强制终止该方法
                return false;
            }
            $.ajax({

                url: "settings/user/login.do",
                data: {

                    "loginAct": loginAct,
                    "loginPwd": loginPwd
                },
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        window.location.href = "workbench/index.jsp";
                    } else {

                        $("#msg").html(data.msg);

                    }
                }
            })
        }

        $(function() {

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
                $("#createActivityModal").modal("show");

            })
        })

    </script>
</head>

<body background="image/IMG.JPG">

<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        STUMAG &nbsp;<span style="font-size: 12px;">&copy;高明峰少</span></div>
</div>

<div style="position: absolute; top: 120px; right: 450px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录 或 注册</h1>
        </div>
        <form action="workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>

                <button type="button" class="btn btn-primary btn-lg btn-block" style="width: 350px; position: relative;top: 45px;"id="addBtn">
                    注册
                </button>
            </div>
        </form>
    </div>
</div>

<!-- 注册信息的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">注册学生信息</h4>
            </div>
            <div class="modal-body">

                <form id="activityAddForm" class="form-horizontal" role="form">


                    <div class="form-group">

                        <label for="create-name" class="col-sm-2 control-label">学生姓名</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-gender">
                                <option value ="man">男</option>
                                <option value ="woman">女</option>
                            </select>
                        </div>
                        <br>
                        <br>
                        <br>
                        <label  class="col-sm-2 control-label">班级</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-grade">
                        </div>
                    </div>
                    <div class="form-group">

                        <label class="col-sm-2 control-label">学号</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-stunum">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">描述</label>
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




</body>
</html>