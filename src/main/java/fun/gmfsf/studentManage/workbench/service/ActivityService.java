package fun.gmfsf.studentManage.workbench.service;

import fun.gmfsf.studentManage.workbench.domain.ActivityRemark;
import fun.gmfsf.studentManage.vo.PaginationVO;
import fun.gmfsf.studentManage.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * @author feng
 * @date 2020/10/12 - 20:06
 * @Description
 */
public interface ActivityService {


    boolean creatActivity(Activity activity);

    PaginationVO<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Map<String, Object> getUserListAndActivity(String id);

    boolean update(Activity a);

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    boolean deleteRemark(String id);

    boolean saveRemark(ActivityRemark ar);

    boolean updateRemark(ActivityRemark ar);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);

}
