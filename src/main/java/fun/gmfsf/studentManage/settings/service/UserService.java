package fun.gmfsf.studentManage.settings.service;

import fun.gmfsf.studentManage.exception.LoginException;
import fun.gmfsf.studentManage.settings.domain.User;

import java.util.List;

/**
 * @author feng
 * @date 2020/10/11 - 10:55
 * @Description
 */
public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
