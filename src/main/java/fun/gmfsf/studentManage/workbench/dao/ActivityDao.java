package fun.gmfsf.studentManage.workbench.dao;

import fun.gmfsf.studentManage.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * @author feng
 * @date 2020/10/12 - 20:02
 * @Description
 */
public interface ActivityDao {
    int creatActivity(Activity activity);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    int delete(String[] ids);

    Activity getById(String id);

    int update(Activity a);

    Activity detail(String id);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);
}

