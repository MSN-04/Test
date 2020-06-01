package humanframe.web.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.property.EgovPropertyService;
import humanframe.backoffice.service.MberService;
import humanframe.backoffice.session.MberSession;
import humanframe.backoffice.vo.MberVO;
import humanframe.core.util.HumanNetUtil;
import humanframe.core.util.HumanStringUtil;
import humanframe.web.security.SSOUtil;

@Service("MberLoginFilter")
public class MberLoginFilter implements Filter {
	private static Logger log = LoggerFactory.getLogger(MberLoginFilter.class);

	@SuppressWarnings("unused")
	private FilterConfig filterConfig;

	@Autowired
	private MberService mberService;

	@Autowired
	private EgovPropertyService properties;

	@Autowired
	MberSession mberSession;

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		try {
			String servletPath = ((HttpServletRequest) request).getServletPath();
			if (servletPath.indexOf("/admin") == -1) {
				log.debug("########### MberLoginFilter start ###########");
				HttpSession session = ((HttpServletRequest) request).getSession();

				String SCSSO = SSOUtil.getCookie((HttpServletRequest) request, properties.getString("COOKIE_MEMBER"));

				if(session.getAttribute(properties.getString("SESSION_MEMBER")) != null){
					mberSession =  (MberSession) session.getAttribute(properties.getString("SESSION_MEMBER"));

					log.debug("###### Mber session Exist ######");
					log.debug("## isLoginCheck : " + mberSession.isLoginCheck());
					log.debug("## uniqueId : " + mberSession.getUniqueId());
					log.debug("## mberId   : " + mberSession.getMberId());
					log.debug("#################################");

					//세션이 있고 쿠키가 없을경우   : 쿠키 생성(x) --> 세션 종료(O)
					if(HumanStringUtil.nvl(SCSSO).equals("")){
						log.debug("###### Mber cookie Not exist :: session delete");
						session.setAttribute(properties.getString("SESSION_MEMBER"), null);
					}

				} else {
					//세션이 없고 쿠키가 있을경우 로그인상태로 변경
					if (!HumanStringUtil.nvl(SCSSO).equals("")) {
					    //쿠키정보 디코드
						Map<String, String> map = SSOUtil.getMberCookie(SCSSO);
						String decodeUniqueID = map.get("decodeUniqueID");
						log.debug("###### Mber cookie Exist :: " + decodeUniqueID);

						Map<String, Object> paramMap = new HashMap<String, Object>();
						paramMap.put("uniqueId", decodeUniqueID);
						MberVO mberVO = mberService.selectMber(paramMap);

						String ip = HumanNetUtil.getIp((HttpServletRequest) request);

						if(mberVO != null){
							// 중복로그인경우
							if("Y".equals(mberVO.getDupLoginAt()) && !ip.equals(mberVO.getLastVisitIp())){
								log.debug("###### Mber Dup Login :: cookie delete");
								SSOUtil.delCookie((HttpServletResponse) response, properties.getString("COOKIE_MEMBER"));
							} else{
								//세션저장
								mberSession.setParms(mberVO, true);

								session.setAttribute(properties.getString("SESSION_MEMBER"), mberSession);
								session.setMaxInactiveInterval(60*60);
								log.debug("####### SSO Login #######");
								log.debug("## isLoginCheck : " + mberSession.isLoginCheck());
								log.debug("## uniqueId : " + mberSession.getUniqueId());
								log.debug("## mberId   : " + mberSession.getMberId());
								log.debug("#########################");
							}
						} else {
							log.debug("###### Mber data Not exist :: cookie delete");
							SSOUtil.delCookie((HttpServletResponse) response, properties.getString("COOKIE_MEMBER"));
						}
					}
					request.setAttribute("sessMber", mberSession);
				}
			}

			chain.doFilter(request, response);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}


	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		this.filterConfig = filterConfig;
	}


	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}
}
