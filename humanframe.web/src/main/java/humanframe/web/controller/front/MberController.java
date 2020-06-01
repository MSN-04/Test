package humanframe.web.controller.front;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.map.HashedMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.View;

import egovframework.rte.fdl.string.EgovStringUtil;
import humanframe.backoffice.service.MberService;
import humanframe.backoffice.session.MberSession;
import humanframe.backoffice.util.HumanUriUtil;
import humanframe.backoffice.vo.MberVO;
import humanframe.backoffice.vo.SiteVO;
import humanframe.core.abst.HumanAbstractController;
import humanframe.core.service.HumanCryptoService;
import humanframe.core.util.HumanCommonUtil;
import humanframe.core.util.HumanHttpSessionBindingListener;
import humanframe.core.util.HumanMultiLoginPreventor;
import humanframe.core.util.HumanNetUtil;
import humanframe.core.util.HumanValidatorUtil;
import humanframe.core.values.CRUDValues;
import humanframe.core.view.JavaScript;
import humanframe.core.view.JavaScriptView;
import humanframe.web.security.SSOUtil;

@Controller
@RequestMapping("/fnct/mber")
public class MberController extends HumanAbstractController {

	private static final Logger logger = LoggerFactory.getLogger(MberController.class);

	@Resource(name="mberService")
	private MberService mberService;

	@Resource(name="humanCryptoService")
	private HumanCryptoService cryptoService;

	@Autowired
	private MberSession mberSession;

	/**
	 * 로그인 페이지
	 * @param session
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value={"index", "login"})
	public String login(
				HttpSession session
				, HttpServletRequest request
				, Model model)  throws Exception {

		logger.debug("---- 회원 login 페이지이동 ");
		if(loginCheck(session)){
			return "redirect:" + HumanUriUtil.getHomeUrl(request, "");
		}

		SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");
		return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/mber/login";
	}

	/**
	 * 등록페이지
	 * @param session
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value={"form", "register"})
	public String register(
				HttpSession session
				, HttpServletRequest request
				, Model model)  throws Exception {

		logger.debug("---- 회원 등록 페이지이동 ");
		if(loginCheck(session)){
			return  "redirect:" + HumanUriUtil.getHomeUrl(request, "");
		}

		model.addAttribute("crud", CRUDValues.CREATE);
		SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");

		return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/mber/register";
	}

	/**
	 * 회원정보페이지
	 * @param session
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value={"view", "mberInfo"})
	public String mberInfo(
				HttpSession session
				, HttpServletRequest request
				, Model model)  throws Exception {

		logger.debug("---- 회원 정보 페이지이동 ");
		SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");

		if(!loginCheck(session)){
			return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/mber/login";
		}

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("mberId", mberSession.getMberId());
		MberVO mberVO = mberService.selectMber(paramMap);

		mberVO.setCrud(CRUDValues.UPDATE);
		model.addAttribute("mberVO", mberVO);

		return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/mber/mberInfo";
	}

	/**
	 * 등록 action
	 * @param mberVO
	 * @param reqMap
	 * @param session
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value= {"action", "registerAction"}, method={ RequestMethod.POST })
	public View registerAction(
			 @ModelAttribute("mberVO")MberVO mberVO
			, @RequestParam Map<String,Object> reqMap
			, HttpSession session
			, HttpServletResponse response
			, HttpServletRequest request
			, Model model)  throws Exception {

		logger.debug("---- 회원 action ");
		JavaScript js = new JavaScript();

		MberSession mberSession = (MberSession) session.getAttribute(getProperties("SESSION_MEMBER"));
		String loginId = HumanCommonUtil.getSqlStr(mberVO.getMberId());
		String loginPassword = HumanCommonUtil.getSqlStr(mberVO.getPassword());
		String encryptStr;

		if(EgovStringUtil.isEmpty(loginId)){
			js.setMessage(getMsg("fail.save"));
			js.setMethod("window.history.back()");
			return new JavaScriptView(js);
		}

		try {

			switch (mberVO.getCrud()) {
				case CREATE:
					logger.debug("============ 회원가입 :: " + loginId);
					if (EgovStringUtil.isEmpty(loginPassword)
							 || !HumanValidatorUtil.isValidId(loginId)
						     || !HumanValidatorUtil.isValidPassword(loginPassword)){
						js.setMessage(getMsg("fail.save"));
						js.setMethod("window.history.back()");
						return new JavaScriptView(js);
					}
					encryptStr = cryptoService.encryptPassword(loginPassword, loginId);
					mberVO.setPassword(encryptStr);
					mberVO.setCrtrId(loginId);
					mberVO.setUpdusrId(loginId);

					//가입여부 판단
					Map<String, Object> parm = new HashedMap();
					parm.put("mberId", loginId);
					MberVO checkMberVO = mberService.selectMber(parm);
					if(null != checkMberVO){
						js.setMessage(getMsg("errors.duplicate.id"));
						js.setMethod("window.history.back()");
						return new JavaScriptView(js);
					}

					mberService.insertMber(mberVO);
					break;

				case UPDATE:
					logger.debug("============ 회원정보변경 :: " + loginId);
					//세션ID와 다른경우 실패
					if(null == mberSession || !loginId.equals(mberSession.getMberId())){
						js.setMessage(getMsg("fail.save"));
						js.setMethod("window.history.back()");
						return new JavaScriptView(js);
					}

					mberVO.setUpdusrId(loginId);
					mberService.updateAllMber(mberVO);

					break;

				case DELETE:
					logger.debug("============ 회원탈퇴 :: " + loginId);

					if(null == mberSession || !loginId.equals(mberSession.getMberId())){
						js.setMessage(getMsg("fail.save"));
						js.setMethod("window.history.back()");
						return new JavaScriptView(js);
					}

					Map<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("uniqueId", mberVO.getUniqueId());
					paramMap.put("mberId", loginId);
					paramMap.put("crtrId", loginId);
					mberService.deleteMber(paramMap);

					//세션제거
					session.setAttribute(getProperties("SESSION_MEMBER"), null);
					session.invalidate();

					//쿠키제거
					SSOUtil.delCookie(response, getProperties("COOKIE_MEMBER"));

					break;

				default:
					break;
			}

			// 완료시 메인페이지 이동
			js.setMessage(getMsg("action.complete.save"));
			js.setLocation(HumanUriUtil.getHomeUrl(request, ""));

		} catch (Exception e) {
			e.printStackTrace();
			js.setMessage(getMsg("fail.save"));
			js.setMethod("window.history.back()");
		}

		return new JavaScriptView(js);
	}

	/**
	 * 중복아이디체크
	 * @param mberId
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("mberIdCheck")
	public @ResponseBody String mberIdCheck(
			@RequestParam(required = true) String mberId
			, HttpServletRequest request
			, HttpServletResponse response
			, HttpSession session) throws Exception {

		String rtbResult = "false";

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("mberId", mberId);
		MberVO mberVO = mberService.selectMber(paramMap);

		if(mberVO == null){
			rtbResult = "true";
		}
		return rtbResult;
	}

	/**
	 * 로그인 action
	 * @param mberVO
	 * @param referUrl
	 * @param session
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="loginAction", method={ RequestMethod.POST })
	public View loginAction(
			    @ModelAttribute("mberVO")MberVO mberVO
			  , HttpSession session
			  , HttpServletRequest request
			  , HttpServletResponse response
			  , Model model) throws Exception {

		logger.debug("---- 회원 로그인 action ");
		JavaScript js = new JavaScript();
		boolean loginCheck = false;

		if(loginCheck(session)){
			js.setLocation(HumanUriUtil.getHomeUrl(request, ""));
			return new JavaScriptView(js);
		}

		try {
			String loginId = HumanCommonUtil.getSqlStr(mberVO.getMberId());
			String loginPassword = HumanCommonUtil.getSqlStr(mberVO.getPassword());
			String encryptStr = cryptoService.encryptPassword(loginPassword, loginId);

			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("mberId", loginId);
			paramMap.put("useAt", "Y");
			mberVO = mberService.selectMber(paramMap);

			if(mberVO!=null){
				if (mberVO.getPassword().equals(encryptStr)){
					//세션저장
			        loginCheck = true;
			        mberSession.setParms(mberVO, loginCheck);
			        session.setAttribute(getProperties("SESSION_MEMBER"), mberSession);
					session.setMaxInactiveInterval(60*60);

					//로그인정보 쿠키처리 (크로스도메인용)
			        String SCSSO = SSOUtil.makeMberCookie(mberVO.getMberId(), mberVO.getUniqueId());
			        SSOUtil.setCookie(response, getProperties("COOKIE_MEMBER"), SCSSO);

			        //중복로그인체크
			        MberVO temp = new MberVO();
			        String saveId = "mber_" + mberVO.getMberId();
			        if(HumanMultiLoginPreventor.findByLoginId(saveId)) {
			        	logger.debug("---- 회원 로그인 중복!!!! ");
			        	temp.setDupLoginAt("Y");
			        }
			        HumanHttpSessionBindingListener listener = new HumanHttpSessionBindingListener();
					session.setAttribute(saveId, listener);

			        //마지막 로그인시간/중복로그인여부 저장
			        temp.setUniqueId(mberVO.getUniqueId());
			        temp.setMberId(mberVO.getMberId());
			        temp.setUpdusrId(mberVO.getMberId());
			        temp.setLastVisitIp(HumanNetUtil.getIp(request));
			        temp.setLastVisitDttm("SYSDATETIME");
			        //마지막로그인IP
					mberService.updateExistMber(temp);
				}
			}
			//리턴 URL
			if(loginCheck){
				js.setLocation(HumanUriUtil.getHomeUrl(request, ""));
			} else{
				js.setMessage(getMsg("login.fail"));
				js.setMethod("window.history.back()");
			}

		} catch (Exception e) {
			e.printStackTrace();
			js.setMessage(getMsg("fail.common"));
			js.setMethod("window.history.back()");
		}

		return new JavaScriptView(js);
	}

	/**
	 * 비밀번호 변경
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("changePasswd")
	public View changePasswd(
			@ModelAttribute("mberVO")MberVO mberVO
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, HttpServletResponse response
			, HttpSession session) throws Exception {

		logger.debug("============ 회원패스워드변경 ");
		JavaScript js = new JavaScript();
		try {

			MberSession mberSession = (MberSession) session.getAttribute(getProperties("SESSION_MEMBER"));
			String loginId = HumanCommonUtil.getSqlStr(mberVO.getMberId());
			String loginPassword = HumanCommonUtil.getSqlStr(mberVO.getPassword());
			String nowloginPassword = HumanCommonUtil.getSqlStr((String) reqMap.get("nowPassword"));
			String encryptStr;

			// 아이디나 비번이 없는경우//세션ID와 다른경우 실패
			if(EgovStringUtil.isEmpty(loginId) || EgovStringUtil.isEmpty(loginPassword)
					|| null == mberSession || !loginId.equals(mberSession.getMberId())){
				js.setMessage(getMsg("fail.save"));
				js.setMethod("window.history.back()");
				return new JavaScriptView(js);
			}

			//현재비밀번호 다른경우 실패
			encryptStr = cryptoService.encryptPassword(nowloginPassword, loginId);
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("uniqueId", mberVO.getUniqueId());
			paramMap.put("mberId", loginId);
			MberVO checkMberVO = mberService.selectMber(paramMap);

			if(!checkMberVO.getPassword().equals(encryptStr)){
				js.setMessage(getMsg("login.fail.password"));
				js.setMethod("window.history.back()");
				return new JavaScriptView(js);
			}

			// 비밀번호 변경
			encryptStr = cryptoService.encryptPassword(loginPassword, loginId);

			MberVO passMberVO = new MberVO();
			passMberVO.setUniqueId(mberVO.getUniqueId());
			passMberVO.setMberId(loginId);
			passMberVO.setUpdusrId(loginId);
			passMberVO.setPassword(encryptStr);
			mberService.updatePasswdMber(passMberVO);

			js.setMessage(getMsg("action.complete.save"));
			js.setLocation(HumanUriUtil.getHomeUrl(request, ""));

		} catch (Exception e) {
			e.printStackTrace();
			js.setMessage(getMsg("fail.common"));
			js.setMethod("window.history.back()");
		}
		return new JavaScriptView(js);
	}

	/**
	 * 로그아웃
	 * @param request
	 * @param response
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("logout")
	public View logout(
			HttpServletRequest request
			, HttpServletResponse response
			, HttpSession session) throws Exception {
		logger.debug("---- 회원 로그아웃");
		JavaScript js = new JavaScript();
		//세션제거
		session.setAttribute(getProperties("SESSION_MEMBER"), null);
		session.invalidate();
		//쿠키제거
		SSOUtil.delCookie(response, getProperties("COOKIE_MEMBER"));

		js.setLocation(HumanUriUtil.getHomeUrl(request, ""));
		return new JavaScriptView(js);
	}

	/**
	 * 로그인 체크
	 */
	public boolean loginCheck(HttpSession session) throws Exception {
		MberSession mberSession = (MberSession) session
				.getAttribute(getProperties("SESSION_MEMBER"));
		if (mberSession != null) {
			return true;
		} else {
			return false;
		}
	}

}