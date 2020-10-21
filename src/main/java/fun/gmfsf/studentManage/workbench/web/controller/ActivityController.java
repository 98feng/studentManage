package fun.gmfsf.studentManage.workbench.web.controller;

import fun.gmfsf.studentManage.workbench.domain.ActivityRemark;
import fun.gmfsf.studentManage.vo.PaginationVO;
import fun.gmfsf.studentManage.settings.domain.User;
import fun.gmfsf.studentManage.settings.service.UserService;
import fun.gmfsf.studentManage.settings.service.impl.UserServiceImpl;
import fun.gmfsf.studentManage.utils.DateTimeUtil;
import fun.gmfsf.studentManage.utils.PrintJson;
import fun.gmfsf.studentManage.utils.ServiceFactory;
import fun.gmfsf.studentManage.utils.UUIDUtil;
import fun.gmfsf.studentManage.workbench.domain.Activity;
import fun.gmfsf.studentManage.workbench.service.ActivityService;
import fun.gmfsf.studentManage.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author feng
 * @date 2020/10/13 - 11:46
 * @Description
 */
public class ActivityController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到学生信息活动控制器");

        String path = request.getServletPath();

        if ("/workbench/activity/getUserList.do".equals(path)) {

            getUserList(request, response);
        } else if ("/workbench/activity/creatActivity.do".equals(path)) {

            creatActivity(request, response);
        }else if ("/workbench/activity/pageList.do".equals(path)) {

            pageList(request, response);
        }else if("/workbench/activity/delete.do".equals(path)){

            delete(request,response);

        }else if("/workbench/activity/getUserListAndActivity.do".equals(path)){

            getUserListAndActivity(request,response);

        }else if("/workbench/activity/update.do".equals(path)){

            update(request,response);

        }else if("/workbench/activity/detail.do".equals(path)){

            detail(request,response);

        }else if("/workbench/activity/getRemarkListByAid.do".equals(path)){

            getRemarkListByAid(request,response);

        }else if("/workbench/activity/deleteRemark.do".equals(path)){

            deleteRemark(request,response);

        }else if("/workbench/activity/saveRemark.do".equals(path)){

            saveRemark(request,response);

        }else if("/workbench/activity/updateRemark.do".equals(path)){

            updateRemark(request,response);

        }


    }
    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行修改备注的操作");

        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";

        ActivityRemark ar = new ActivityRemark();

        ar.setId(id);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = as.updateRemark(ar);

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("ar", ar);

        PrintJson.printJsonObj(response, map);

    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行添加备注操作");

        String noteContent = request.getParameter("noteContent");
        String activityId = request.getParameter("activityId");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";

        ActivityRemark ar = new ActivityRemark();
        ar.setId(id);
        ar.setNoteContent(noteContent);
        ar.setActivityId(activityId);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setEditFlag(editFlag);

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = as.saveRemark(ar);

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("ar", ar);

        PrintJson.printJsonObj(response, map);


    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("删除备注操作");

        String id = request.getParameter("id");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = as.deleteRemark(id);

        PrintJson.printJsonFlag(response, flag);


    }

    private void getRemarkListByAid(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("根据学生信息id，取得备注信息列表");

        String activityId = request.getParameter("activityId");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        List<ActivityRemark> arList = as.getRemarkListByAid(activityId);

        PrintJson.printJsonObj(response, arList);



    }

    private void detail(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("进入到跳转到详细信息页的操作");

        String id = request.getParameter("id");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        Activity a = as.detail(id);

        request.setAttribute("a", a);

        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request, response);


    }

    private void update(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行学生信息修改操作");

        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String grade = request.getParameter("grade");
        String stunum = request.getParameter("stunum");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String description = request.getParameter("description");
        //修改时间：当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人：当前登录用户
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        Activity a = new Activity();
        a.setId(id);
        a.setStartDate(startDate);
        a.setOwner(owner);
        a.setName(name);
        a.setGender(gender);
        a.setGrade(grade);
        a.setStunum(stunum);
        a.setEndDate(endDate);
        a.setDescription(description);
        a.setEditBy(editBy);
        a.setEditTime(editTime);

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = as.update(a);

        PrintJson.printJsonFlag(response, flag);

    }

    private void getUserListAndActivity(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入到查询用户信息列表和根据学生信息id查询单条记录的操作");

        String id = request.getParameter("id");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        Map<String,Object> map = as.getUserListAndActivity(id);

        PrintJson.printJsonObj(response, map);


    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行学生信息活动的删除操作");

        String ids[] = request.getParameterValues("id");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = as.delete(ids);

        PrintJson.printJsonFlag(response, flag);


    }


    private void pageList(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入到学生信息活动列表的操作（结合条件查询+分页查询）");

        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String gender = request.getParameter("gender");
        String grade = request.getParameter("grade");
        String stunum = request.getParameter("stunum");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String pageNoStr = request.getParameter("pageNo");
        int pageNo = Integer.valueOf(pageNoStr);
        //每页展现的记录数
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizeStr);
        //计算出略过的记录数
        int skipCount = (pageNo-1)*pageSize;

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("gender", gender);
        map.put("grade", grade);
        map.put("stunum", stunum);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        PaginationVO<Activity> vo = as.pageList(map);

        //vo--> {"total":100,"dataList":[{学生信息1},{2},{3}]}
        PrintJson.printJsonObj(response, vo);




    }

    private void creatActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("创建学生信息活动");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String grade = request.getParameter("grade");
        String stunum = request.getParameter("stunum");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String describetion = request.getParameter("description");

        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setGender(gender);
        activity.setGrade(grade);
        activity.setStunum(stunum);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCreateBy(createBy);
        activity.setCreateTime(createTime);
        activity.setDescription(describetion);
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = as.creatActivity(activity);

        PrintJson.printJsonFlag(response, flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得用户信息列表");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = us.getUserList();
        PrintJson.printJsonObj(response, userList);
    }


}
