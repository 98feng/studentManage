package fun.gmfsf.studentManage.settings.web.controller;

import fun.gmfsf.studentManage.exception.LoginException;
import fun.gmfsf.studentManage.settings.domain.User;
import fun.gmfsf.studentManage.settings.service.UserService;
import fun.gmfsf.studentManage.settings.service.impl.UserServiceImpl;
import fun.gmfsf.studentManage.utils.MD5Util;
import fun.gmfsf.studentManage.utils.PrintJson;
import fun.gmfsf.studentManage.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @author feng
 * @date 2020/10/11 - 10:20
 * @Description
 */
public class UserController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入登录控制器");
        String path = request.getServletPath();
        if("/settings/user/login.do".equals(path)){
            login(request,response);
        }

    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws ServletException,IOException{
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        loginPwd = MD5Util.getMD5(loginPwd);
        String ip = request.getRemoteAddr();

        UserService us = (UserService)ServiceFactory.getService(new UserServiceImpl());
        try {
            User user = us.login(loginAct,loginPwd,ip);


            request.getSession().setAttribute("user",user);
            PrintJson.printJsonFlag(response,true);
        } catch (LoginException e) {
            e.printStackTrace();
            String msg = e.getMessage();

            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
    }
}
