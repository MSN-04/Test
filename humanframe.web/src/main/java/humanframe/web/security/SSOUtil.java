package humanframe.web.security;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import humanframe.core.util.HumanStringUtil;


public class SSOUtil {

	/**쿠키생성*/
	public static void setCookie(HttpServletResponse response, String name, String value) throws Exception {
		delCookie(response, name);
		Cookie cookie = new Cookie(name, HumanStringUtil.nvl(value));
		cookie.setDomain("yooncoms.com");
		cookie.setMaxAge(-1);
		cookie.setPath("/");
		response.addCookie(cookie);
	}

	/**쿠키읽기*/
    public static String getCookie(
    		HttpServletRequest request,
    		String name
    ) throws Exception {
    	Cookie[] cookies = request.getCookies();
    	String cookie = null;
    	if (cookies != null) {
    		for (int i=0;i<cookies.length;i++) {
    			if (cookies[i].getName().equals(name)) cookie = cookies[i].getValue();
    		}
    	}
    	return cookie;
    }

    /**쿠키삭제*/
    public static void delCookie(
    		HttpServletResponse response,
    		String name
    ) throws Exception {
    	Cookie cookie = new Cookie(name, "");
		cookie.setDomain("yooncoms.com");
		cookie.setMaxAge(-1);
		cookie.setPath("/");
		response.addCookie(cookie);
    }

    /**mber쿠키정보생성**/
    public static String makeMberCookie(String mberId, String uniqueId) throws Exception {
    	String time = String.valueOf((System.currentTimeMillis()/60000));
        String encodeID = AES256Util.AESEncode(uniqueId, HumanStringUtil.lpad(time, 16, "0"));
        String encodeTime = AES256Util.AESEncode(time, HumanStringUtil.lpad(mberId, 16, "0"));
        String SCSSO = mberId + "|" + AES256Util.AESEncode(encodeTime + "|" + encodeID, HumanStringUtil.lpad(mberId, 16, "0"));
        return SCSSO;
    }

    /**mber쿠키정보구하기**/
    public static Map<String, String> getMberCookie(String SCSSO) throws Exception {
    	String ARR_SCSSO[] = SCSSO.split("[|]");
		String ARR_SCDAT[] = AES256Util.AESDecode(ARR_SCSSO[1], HumanStringUtil.lpad(ARR_SCSSO[0], 16, "0")).split("[|]");

		Map<String, String> rtnMap= new HashMap<>();
		String decodeTime = AES256Util.AESDecode(ARR_SCDAT[0], HumanStringUtil.lpad(ARR_SCSSO[0], 16, "0"));
		String decodeUniqueID = AES256Util.AESDecode(ARR_SCDAT[1], HumanStringUtil.lpad(decodeTime, 16, "0"));

		rtnMap.put("decodeTime", decodeTime);
		rtnMap.put("decodeUniqueID", decodeUniqueID);

		return rtnMap;
    }


}
