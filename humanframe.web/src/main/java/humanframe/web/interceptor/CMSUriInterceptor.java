package humanframe.web.interceptor;

import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.MessageSource;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.fdl.string.EgovStringUtil;
import humanframe.backoffice.service.SiteMenuService;
import humanframe.backoffice.service.SiteService;
import humanframe.backoffice.service.StatsMenuService;
import humanframe.backoffice.vo.SiteMenuVO;
import humanframe.backoffice.vo.SiteVO;
import humanframe.core.exception.CommonErrorException;
import humanframe.core.util.HumanStringUtil;
import humanframe.core.util.LangChangeUtil;
import humanframe.core.util.WebUtil;
import humanframe.web.security.AES256Util;
import humanframe.web.security.SSOUtil;


/**
 * @Project Name : humanframework-web
 * @Author : yooncoms
 * @Description : Humanframe Front(Web) Interceptor
 * @since 2015.08.12
 *
 * @Modification Information
 *
 */
@SuppressWarnings({"unchecked", "rawtypes"})
public class CMSUriInterceptor extends HandlerInterceptorAdapter {

	protected Log log = LogFactory.getLog(this.getClass());

	@Resource(name="propertiesService")
	private EgovPropertyService properties;

	@Resource(name="messageSource")
	private MessageSource messageSource;

	@Resource(name="siteService")
	private SiteService siteService;

	@Resource(name="siteMenuService")
	private SiteMenuService siteMenuService;

	@Resource(name="statsMenuService")
	private StatsMenuService statsMenuService;

/*	@Resource(name="mberService")
	private MberService mberService;*/

	private long start = 0;
	private boolean isValidateInpup;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		start = System.currentTimeMillis();
		isValidateInpup = true;

		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");

		log.debug("front preHandle URI : "+ request.getServletPath());
		Enumeration en = request.getParameterNames();
		while(en.hasMoreElements()){
			Object keyObj = en.nextElement();

			if(keyObj instanceof String){
				String key = (String)keyObj;
				if(request.getParameterValues(key).length != 1) {
					for(String value : request.getParameterValues(key)){
						log.debug("########### front parameter key = '" + key + "',Array value = '"+value+"'");
						if(! WebUtil.isValidateInput(value)){
							isValidateInpup = false;
							break;
						}
					}
				} else {
					log.debug("########### front parameter key = '" + key + "', value = '"+request.getParameter(key)+"'");
					if(! WebUtil.isValidateInput(request.getParameter(key))){
						isValidateInpup = false;
						break;
					}
				}
			} else {
				log.debug("parameter key is Object");
			}
		}

		String domain = request.getServerName();
		String uriPath = URLDecoder.decode(request.getRequestURI(), "UTF-8");

		String curSiteURL = HumanStringUtil.nvl(request.getRequestURL(), "");
		String curSiteURI = HumanStringUtil.nvl(request.getRequestURI(), "");

		curSiteURL = curSiteURL.replace(curSiteURI, "");

		HttpSession session = request.getSession();

		if (!uriPath.contains("humanframe-cms")) {

			request.setAttribute("uriPath", (domain + uriPath));

			//context path(중간URI) 확인
			if (uriPath.startsWith("/")){
				uriPath = uriPath.substring(1, uriPath.length());
			}

			if (uriPath.endsWith("/")){
				uriPath = uriPath.substring(0, uriPath.length() - 1);
			}

			String firstUri = "";
			if(uriPath.indexOf("/") > 0) {
				firstUri = uriPath.substring(0, uriPath.indexOf("/"));
			} else {
				firstUri = uriPath.substring(0, uriPath.length());
			}

			//사이트 체크
			//List<SiteVO> siteInfo = siteService.selectSiteMenuListAll(); //실시간
			//List<SiteVO> siteInfo = siteService.selectPblcateSiteMenuListAll(); //전체 캐시화
			//TO-DO
			Map<String, Object> siteMap = new HashMap<String, Object>();
			siteMap.put("domain", domain +"/"+ firstUri + "/");
			List<SiteVO> siteInfo = siteService.selectPblcateSiteMenuListAll(siteMap); //부분 캐시화

			SiteVO curSiteVO = null;
			for(SiteVO siteVO:siteInfo){
				String siteDomain = siteVO.getSiteUrl();
				if(siteVO.getFirstUriDivYn().equals("Y")){
					siteDomain = siteDomain + "/" + siteVO.getFirstUri();
				}
				if((domain+"/"+firstUri + "/").startsWith(siteDomain + "/")){
					curSiteVO = siteVO;
					break;
				}
			}

			if(curSiteVO == null){//등록된 사이트가 아님 error페이지로
				setRedirectError(request, "404", curSiteVO);
			}

			LangChangeUtil.setLanguage(request, curSiteVO.getLangCodeId());
			Locale locale = (Locale) session.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME);

			String uriSplit[] = uriPath.split("/");
			String baseUri = "";
			String menuUri = "";
			String targetUri = "";

			if(!isValidateInpup){
				PrintWriter out = response.getWriter();
				out.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">");
				out.println("<html>");
				out.println("<head>");
				out.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
				out.println("<script type=\"text/javascript\">");
				out.println("alert(\""+messageSource.getMessage("alert.author.common", null, locale)+"\");");
				out.println("history.back();");
				out.println("</script>");
				out.println("</head>");
				out.println("</html>");
				out.flush();
				out.close();
				return false;
			}

			if (curSiteVO.getFirstUriDivYn(
			).equals("Y")) {
				baseUri = "/" + curSiteVO.getFirstUri();
				if (uriSplit.length > 1){
					menuUri = uriSplit[1].trim();
				}
				if (uriSplit.length > 2) {
					targetUri = uriSplit[2].trim();
				}
				if (uriSplit.length > 3) {
					targetUri = uriSplit[2].trim() +"/" + uriSplit[3].trim();
				}
				if(EgovStringUtil.equals(menuUri, "")){
					response.sendRedirect(baseUri+"/index");
					return false;
				}
			}else{
				menuUri = uriSplit[0].trim();
				if (uriSplit.length > 1){
					targetUri = uriSplit[1].trim();
				}
				if (uriSplit.length > 2) {
					targetUri = uriSplit[1].trim() + "/" +uriSplit[2].trim();
				}
			}

			Boolean isRss = false;
			if(menuUri.lastIndexOf(".rss") > -1){
				isRss = true;
				menuUri = menuUri.replaceAll(".rss", "");
			}

			//GNB Menu set
			List<SiteMenuVO> curSiteMenuList = new ArrayList<SiteMenuVO>();
			SiteMenuVO curMenuVO = null;
			for (SiteMenuVO siteMenuVOs : curSiteVO.getSiteMenuList()) {

				String menuUriWrd;
				menuUriWrd = siteMenuVOs.getMenuUri();//.replace(baseUri+"/", "");
				if(EgovStringUtil.search(menuUriWrd, "?") > 0){
					String[] menuUriWrdSplit = menuUriWrd.split("\\?");
					menuUriWrd = menuUriWrdSplit[0];
				}

				if(EgovStringUtil.equals(menuUriWrd, menuUri)){
					curMenuVO = new SiteMenuVO();
					curMenuVO = siteMenuVOs;
				}
				if(EgovStringUtil.equals("Y", siteMenuVOs.getUseAt()) && EgovStringUtil.equals("Y", siteMenuVOs.getMnmnuDspyAt()) ){
					curSiteMenuList.add(siteMenuVOs);
				}
			}

			String redirectUrl = "";
			Map<String, String> metaInfoMap = new HashMap<String, String>();
			if (curMenuVO == null) {
				setRedirectError(request, "404", curSiteVO);
			} else {
				if(EgovStringUtil.equals("1", curMenuVO.getMenuTy())){//상위메뉴
					request.setAttribute("curPageType", "subindex");
					if(curMenuVO.getMenuUri().endsWith("index")){
						request.setAttribute("curPageType", "index");
						redirectUrl = "/humanframe-cms/index";
					}else if (EgovStringUtil.equals("Y", curMenuVO.getSubMainUseAt())){
						//redirectUrl = "/humanframe-cms/submain/"+curMenuVO.getSubMainNo();//서브메인을 프로그램화 할 경우
						redirectUrl = "/humanframe-cms/submain/"+curMenuVO.getMenuUri().replace(baseUri, "");
					}else{
						//서브메인 URL무한링크되는 오류 수정
						if(EgovStringUtil.isEmpty(curMenuVO.getLinkUrl())){

							if (curSiteVO.getFirstUriDivYn().equals("Y")) {
								baseUri = "/" + curSiteVO.getFirstUri();
							}
							redirectUrl = baseUri + "/index";
						}else{
							if(curMenuVO.getLinkUrl().startsWith("/")){
								redirectUrl = curMenuVO.getLinkUrl();
							}else{
								redirectUrl = "/" + curMenuVO.getLinkUrl();
							}
						}
					}
				}else if(EgovStringUtil.equals("2", curMenuVO.getMenuTy())){//콘텐츠
					request.setAttribute("curPageType", "cntnts");
					if(EgovStringUtil.equals(curMenuVO.getPostListTy(), "1")){
						redirectUrl = "/humanframe-cms/cntnts/single";
					}else{
						if (EgovStringUtil.isEmpty(targetUri)){
							redirectUrl = "/humanframe-cms/cntnts/listPage";
						}else {
							redirectUrl = "/humanframe-cms/cntnts/" + targetUri;
						}
					}
				}else if(EgovStringUtil.equals("3", curMenuVO.getMenuTy())){//게시판
					request.setAttribute("curPageType", "bbs");
					log.debug("BBSNO:" + curMenuVO.getBbsNo());
					if(curMenuVO.getBbsNo() == 0){
						redirectUrl = "/humanframe-cms/fnctProgrm/0";//not ready 사용
					}else{
						if(isRss){
							redirectUrl = "/humanframe-cms/bbs/" + curMenuVO.getBbsNo() + ".rss";
						}
						else{
							if (EgovStringUtil.isEmpty(targetUri)) {
								redirectUrl = "/humanframe-cms/bbs/" + curMenuVO.getBbsNo();
							}else{
								redirectUrl = "/humanframe-cms/bbs/" + curMenuVO.getBbsNo() + "/" + targetUri;
							}
						}
					}
				}else if(EgovStringUtil.equals("4", curMenuVO.getMenuTy())){//기능 프로그램
					request.setAttribute("curPageType", "fnct");
					if (EgovStringUtil.isEmpty(targetUri)) {
						redirectUrl = "/humanframe-cms/fnctProgrm/" + curMenuVO.getFnctNo();
					} else {
						redirectUrl = "/humanframe-cms/fnctProgrm/" + curMenuVO.getFnctNo() + "/" + targetUri;
					}
				}else{
					redirectUrl = "/humanframe-cms/jsp/"+curMenuVO.getMenuUri().replace(baseUri, "");
				}

				//SEO 정보 추출
				if (EgovStringUtil.isEmpty(targetUri)) { // 목록, 메인 등

				} else { // 게시글

				}

				// aside 설정에 따라 조정
				if(curMenuVO.getAsideOpt() != null){
					//submenu
					if(curMenuVO.getUpperMenuNo() > 0){
						String menuPath = curMenuVO.getMenuPath();
						String[] menuPathSplit = menuPath.split("/");
						int topMenuNo = EgovStringUtil.string2integer(menuPathSplit[2]);
						List<SiteMenuVO> subMenuList = siteMenuService.menuListByRootMenuNo(curSiteVO.getSiteNo(), topMenuNo);

						request.setAttribute("curSubMenuPath", menuPath);
						request.setAttribute("curSubMenuList", subMenuList);

						//LEFT메뉴에서 5depth까지 체크가능
						//6depth이하는 별도 display를 위해 추가 작업
						if(curMenuVO.getLevelNo() > 6){
							List<SiteMenuVO> addSubMenuList = siteMenuService.menuListByRootMenuNo(curSiteVO.getSiteNo(), curMenuVO.getUpperMenuNo());
							request.setAttribute("addSubMenuList", addSubMenuList);
						}
					}
				}
			}

			/////// 통계데이터(메뉴 uv/pv)
			log.debug("### insert for Stats ");
			statsMenuService.insertSetStatMenu(curSiteVO, curMenuVO, session);

			// member
			/*MberSession mberSession = new MberSession();
			String SCSSO = SSOUtil.getCookie(request, "SCSSO");
			String SCSSOAUTH = SSOUtil.getCookie(request, "SCSSOAUTH");
			if(session.getAttribute(properties.getString("SESSION_MEMBER")) != null){
				mberSession = (MberSession) session.getAttribute(properties.getString("SESSION_MEMBER"));
				log.debug("#################################");
				log.debug("## isLoginCheck : " + mberSession.isLoginCheck());
				log.debug("## uniqueId : " + mberSession.getUniqueId());
				log.debug("## mberId   : " + mberSession.getMberId());
				log.debug("## mberNm  : " + mberSession.getMberNm());
				log.debug("## mntrStaff  : " + mberSession.getMntrStaffGroupValue());
				log.debug("## dplctCnfirmCode  : " + mberSession.getDplctCnfirmCode());
				log.debug("## 권한코드  : " + mberSession.getMntrStaffGroupValue());
				log.debug("#################################");

				//세션이 있고 쿠키가 없을경우   : 쿠키 생성(x) --> 세션 종료(O)
				if(HumanStringUtil.nvl(SCSSO).equals("")){
					session.setAttribute(properties.getString("SESSION_MEMBER"), null);

				}

			} else {
				//세션이 없고 쿠키가 있을경우 로그인상태로 변경
				if (!HumanStringUtil.nvl(SCSSO).equals("")) {

				    //쿠키정보 디코드
					String ARR_SCSSO[] = SCSSO.split("[|]");
					String ARR_SCDAT[] = AES256Util.AESDecode(ARR_SCSSO[1], HumanStringUtil.lpad(ARR_SCSSO[0], 16, "0")).split("[|]");
					String decodeTime = AES256Util.AESDecode(ARR_SCDAT[0], HumanStringUtil.lpad(ARR_SCSSO[0], 16, "0"));
					String decodeUniqueID = AES256Util.AESDecode(ARR_SCDAT[1], HumanStringUtil.lpad(decodeTime, 16, "0"));

					MberVO mberVO = mberService.retrieveMberByUniqueId(decodeUniqueID);
					if(mberVO != null){
						mberSession.setUniqueId(mberVO.getUniqueId());
						mberSession.setMberId(mberVO.getMberId());
						mberSession.setMberNm(mberVO.getMberNm());
						mberSession.setDplctCnfirmCode(mberVO.getDplctCnfirmCode());
						mberSession.setTelno(mberVO.getTelno());
                        mberSession.setAdres(mberVO.getAdres());
                        mberSession.setEmail(mberVO.getEmail());
                        mberSession.setSexdstn(mberVO.getSexdstn());
                        mberSession.setMntrStaffGroupValue(mberVO.getMntrStaffGroupValue());
						mberSession.setLoginCheck(true);

						session.setAttribute(properties.getString("SESSION_MEMBER"), mberSession);
						session.setMaxInactiveInterval(60*60);
						log.debug("#################################");
						log.debug("##---------- SSO 로그인  ---------##");
						log.debug("## isLoginCheck : " + mberSession.isLoginCheck());
						log.debug("## uniqueId : " + mberSession.getUniqueId());
						log.debug("## mberId   : " + mberSession.getMberId());
						log.debug("## mberNm  : " + mberSession.getMberNm());
						log.debug("## dplctCnfirmCode  : " + mberSession.getDplctCnfirmCode());
						log.debug("#################################");

					} else {
						SSOUtil.delCookie(response, "SCSSO");
					}

				}

				//인증 로그인
				if(session.getAttribute(properties.getString("SESSION_AUTH")) != null){
	                Map sessionAuth = (Map) session.getAttribute(properties.getString("SESSION_AUTH"));
	                log.debug("#############--비회원 로그인 상태--################");
	                log.debug("## mberNm  : " + sessionAuth.get("userNm"));
	                log.debug("## dplctCnfirmCode  : " + sessionAuth.get("dupInfo"));
	                log.debug("############################################");

	                if(HumanStringUtil.nvl(SCSSOAUTH).equals("")){
						session.setAttribute(properties.getString("SESSION_AUTH"), null);
					}
				}else{
					if (!HumanStringUtil.nvl(SCSSOAUTH).equals("")) {
						//쿠키정보 디코드
						String ARR_SCDAT[] = AES256Util.AESDecode(SCSSOAUTH, HumanStringUtil.lpad("www0.busan.go.kr", 16, "0")).split("[|]");
						String decodeTime = AES256Util.AESDecode(ARR_SCDAT[0], HumanStringUtil.lpad("www0.busan.go.kr", 16, "0"));
						String decodeUniqueID = AES256Util.AESDecode(ARR_SCDAT[1], HumanStringUtil.lpad(decodeTime, 16, "0"));
						String decodeUserNm = AES256Util.AESDecode(ARR_SCDAT[2], HumanStringUtil.lpad(decodeTime, 16, "0"));

						Map<String, String> sessionMap = new HashMap<String,String>();
		            	sessionMap.put("dupInfo", decodeUniqueID);
		            	sessionMap.put("userNm", decodeUserNm);
		            	session.setAttribute(properties.getString("SESSION_AUTH"), sessionMap);
		            	session.setMaxInactiveInterval(60*30);

					} else {
						SSOUtil.delCookie(response, "SCSSOAUTH");
					}

				}

				request.setAttribute("sessMber", mberSession);
			}*/

			// web page informations
			request.setAttribute("curSiteVO", curSiteVO);
			request.setAttribute("curSiteMenuList", curSiteMenuList);
			request.setAttribute("curMenuVO", curMenuVO);
			request.setAttribute("domainSsl", properties.getBoolean("DOMAIN_SSL"));
			request.setAttribute("baseUri", baseUri);
			request.setAttribute("baseURL", curSiteURL);

			request.setAttribute("baseFormatDate", messageSource.getMessage("ui.format.date", null, locale));
			request.setAttribute("baseFormatDateTime", messageSource.getMessage("ui.format.datetime", null, locale));

			// web page meta informations
			request.setAttribute("metaInfo", metaInfoMap);

			// theme informations
			request.setAttribute("theme", curSiteVO.getSiteSkn());
			request.setAttribute("themeAssets", ("/humanframe/theme/" + curSiteVO.getSiteSkn() + "/assets"));

			// global assets)
			request.setAttribute("globalAssets", ("/humanframe/global/assets"));
			request.setAttribute("globalSiteDomain", properties.getString("GLOBAL_SITE_DOMAIN"));
			request.setAttribute("globalSSLDomain", properties.getString("GLOBAL_SITE_SSL_DOMAIN"));
			request.setAttribute("globalReserveDomain", properties.getString("GLOBAL_RESERVE_DOMAIN"));


			// Session for Common page
			session.setAttribute("sessSiteNo", curSiteVO.getSiteNo());
			session.setAttribute("sessMenuNo", curMenuVO.getMenuNo());

			// mobile or tablet or desktop
			Device currentDevice = DeviceUtils.getCurrentDevice(request);
			String deviceType = "unknown";
	        if (currentDevice.isNormal()) {
	            deviceType = "nomal";
	        } else if (currentDevice.isMobile()) {
	            deviceType = "mobile";
	        } else if (currentDevice.isTablet()) {
	            deviceType = "tablet";
	        }
			request.setAttribute("curDevice", deviceType);

			log.debug("::::::::::::::: deviceType : " + deviceType + " ::::::::::::::::::::");

			RequestDispatcher rd = request.getRequestDispatcher(redirectUrl);
			rd.forward(request, response);

			return false;
		} else {
			return super.preHandle(request, response, handler);
		}
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		long finish = System.currentTimeMillis();

		request.setAttribute("executeTime", (finish - start));

		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);

		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception{
		super.afterCompletion(request, response, handler, ex);
	}

	private void setRedirectError(HttpServletRequest httpservletrequest, String s, SiteVO siteVO) throws Exception  {
		if( siteVO!=null ){
			String baseUri = "";
			if (siteVO.getFirstUriDivYn().equals("Y")) {
				baseUri = "/" + siteVO.getFirstUri();
			}
			httpservletrequest.setAttribute("curSiteVO", siteVO);
			httpservletrequest.setAttribute("themeDir",  "/WEB-INF/jsp/theme/"+ EgovStringUtil.null2void(siteVO.getSiteSkn()));
			httpservletrequest.setAttribute("themeAssets", ("/humanframe/theme/" + siteVO.getSiteSkn() + "/assets"));
			httpservletrequest.setAttribute("errorPage",  s);
			httpservletrequest.setAttribute("baseUri",  baseUri);
		}
		
//		throw new Exception("Page not found {" + httpservletrequest.getRequestURL() + "}");
		throw new CommonErrorException("Page not found {" + httpservletrequest.getRequestURL() + "}");
	}
}