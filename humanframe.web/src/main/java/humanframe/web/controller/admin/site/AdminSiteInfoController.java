package humanframe.web.controller.admin.site;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;

import egovframework.rte.fdl.string.EgovStringUtil;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import humanframe.backoffice.service.BannerService;
import humanframe.backoffice.service.BbsSettingService;
import humanframe.backoffice.service.BbsTypeService;
import humanframe.backoffice.service.CntntsService;
import humanframe.backoffice.service.CodeService;
import humanframe.backoffice.service.FileService;
import humanframe.backoffice.service.SiteMainService;
import humanframe.backoffice.service.SiteMenuService;
import humanframe.backoffice.service.SiteService;
import humanframe.backoffice.session.MngrSession;
import humanframe.backoffice.vo.BbsSettingVO;
import humanframe.backoffice.vo.CodeVO;
import humanframe.backoffice.vo.SiteMainVO;
import humanframe.backoffice.vo.SiteMenuVO;
import humanframe.backoffice.vo.SiteVO;
import humanframe.core.abst.HumanAbstractController;
import humanframe.core.util.HumanCommonUtil;
import humanframe.core.util.HumanStringUtil;
import humanframe.core.values.CRUDValues;
import humanframe.core.values.CodeMap;
import humanframe.core.values.StaticValues;
import humanframe.core.view.JavaScript;
import humanframe.core.view.JavaScriptView;
import humanframe.core.vo.DataTableObject;
import humanframe.core.vo.HumanListVO;

/**
 *
 * @Project Name : humanframework-core
 * @Class Name : AdminSiteMainController.java
 * @Description :  사이트 메인페이지 관리
 * @Author : yooncoms
 *
 * @Modification Information
 *
 */
@Controller
@RequestMapping("/admin/siteMain")
public class AdminSiteInfoController extends HumanAbstractController {

	@Resource(name="siteService")
	private SiteService siteService;
	@Resource(name="bannerService")
	private BannerService bannerService;
	@Autowired
	private SiteMainService siteMainService;
	@Autowired
	private FileService fileService;
	@Autowired
	private SiteMenuService siteMenuService;
	@Autowired
	private CntntsService cntntsService;
	@Autowired
	private BbsTypeService bbsTypeService;
	@Autowired
	private BbsSettingService bbsSettingService;
	@Autowired
	private CodeService codeService;
	@Autowired
	private MngrSession mngrSession;

	/**
	 * 사이트 리스트
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "siteList")
	public String list(
			HttpServletRequest request
			, Model model) throws Exception {

		HumanListVO listVO = new HumanListVO(request);
		if(mngrSession.getAuthorTy().equals("2") || mngrSession.getAuthorTy().equals("3")){//관리자
			listVO.setParam("siteNos", mngrSession.getSiteNos());
		}
		listVO = siteService.siteListVO(listVO);
		model.addAttribute("listVO", listVO);
		return "/admin/fnct/site/site_list";
	}

	/**사이트 메인페이지 관리 목록
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="list")
	public String mainList(
			HttpServletRequest request
			, Model model) throws Exception{
		HumanListVO listVO = new HumanListVO(request);
		listVO = siteMainService.siteMainListVO(listVO);

		// 사이트 메인 구분 코드
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("filterKey", "codeGroupId");
		paramMap.put("filterVal", StaticValues.SITE_MAIN_TY_CODE_GROUP_ID);
		List<CodeVO> siteMainCodeTy = codeService.retrieveCodeList(paramMap);
		model.addAttribute("siteMainCodeTy", siteMainCodeTy);
		model.addAttribute("listVO", listVO);

		return "/admin/fnct/site/list";
	}


	/**사이트 메인페이지 관리 등록/수정
	 * @param siteNo
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("form")
	public String form(
			SiteMainVO siteMainVO
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception {

		int siteMainNo = EgovStringUtil.string2integer((String) reqMap.get("siteMainNo"));

		if(siteMainNo == 0){
			siteMainVO.setCrud(CRUDValues.CREATE);
		}else{
			siteMainVO = siteMainService.retrieveSiteMain(siteMainNo);
			siteMainVO.setCrud(CRUDValues.UPDATE);
		}

		// 사이트 메인 구분 코드
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("filterKey", "codeGroupId");
		paramMap.put("filterVal", StaticValues.SITE_MAIN_TY_CODE_GROUP_ID);
		List<CodeVO> siteMainCodeTy = codeService.retrieveCodeList(paramMap);

		model.addAttribute("useAtCode", CodeMap.USE_AT);
		model.addAttribute("siteMainCodeTy", siteMainCodeTy);
		model.addAttribute("linkTrgtTyCode", CodeMap.LINK_TRGT_TY);
		model.addAttribute("siteMainVO", siteMainVO);
		return "/admin/fnct/site/form";
	}

	/**사이트 메인페이지 관리 등록/수정
	 * @param siteNo
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("view")
	public String view(
			SiteMainVO siteMainVO
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception {

		int siteMainNo = EgovStringUtil.string2integer((String) reqMap.get("siteMainNo"));
		siteMainVO = siteMainService.retrieveSiteMain(siteMainNo);

		// 사이트 메인 구분 코드
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("filterKey", "codeGroupId");
		paramMap.put("filterVal", StaticValues.SITE_MAIN_TY_CODE_GROUP_ID);
		List<CodeVO> siteMainCodeTy = codeService.retrieveCodeList(paramMap);

		model.addAttribute("useAtCode", CodeMap.USE_AT);
		model.addAttribute("siteMainCodeTy", siteMainCodeTy);
		model.addAttribute("linkTrgtTyCode", CodeMap.LINK_TRGT_TY);
		model.addAttribute("siteMainVO", siteMainVO);
		return "/admin/fnct/site/view";
	}


	/**사이트 메인페이지 관리 저장
	 * @param siteMainVO
	 * @param multiReq
	 * @param reqMap
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="action")
	public View action(
			SiteMainVO siteMainVO
			, MultipartHttpServletRequest multiReq
			, @RequestParam Map<String,Object> reqMap
			, HttpSession session) throws Exception {

		JavaScript javaScript = new JavaScript();

		// 사용자 정보 설정
		siteMainVO.setCrtrNm(mngrSession.getMngrNm());
		siteMainVO.setUpdusrNm(mngrSession.getMngrNm());
		siteMainVO.setCrtrId(mngrSession.getMngrId());
		siteMainVO.setUpdusrId(mngrSession.getMngrId());

		Map<String, MultipartFile> fileMap = multiReq.getFileMap();

		switch (siteMainVO.getCrud()) {
		case CREATE:
			siteMainService.createSiteMain(siteMainVO);
			fileService.creatFileInfo(fileMap, siteMainVO.getSiteMainNo(), "SITEMAIN", reqMap);
			if(siteMainVO.getSiteSeq() > 0) {
				siteMainService.createSiteMainSeq(siteMainVO);
			}			
			javaScript.setMessage(getMsg("action.complete.insert"));
			break;

		case UPDATE:
			String delAttachFileNo = HumanCommonUtil.getSqlStr((String) reqMap.get("delAttachFileNo"));
			String[] arrDelAttachFile = delAttachFileNo.split(",");
			if(!EgovStringUtil.isEmpty(arrDelAttachFile[0])) fileService.deleteFilebyNo(arrDelAttachFile, siteMainVO.getSiteMainNo(), "SITEMAIN", "ATTACH");

			//file upload & data insert
			fileService.creatFileInfo(fileMap, siteMainVO.getSiteMainNo(), "SITEMAIN", reqMap);
			siteMainService.modifySiteMain(siteMainVO);
			
			if(siteMainVO.getSiteSeq() > 0) {
				siteMainService.modifySiteMainSeq(siteMainVO);
			}
			
			//file description update 
			String updtImgFileDc = HumanCommonUtil.getSqlStr((String) reqMap.get("updtImgFileDc"));
			if(!"".equals(updtImgFileDc)){
				String[] arrUptImgFileDc = updtImgFileDc.split(",");
				for(String uptImgFileDcNm : arrUptImgFileDc) {
					String[] uptImgFileElm = uptImgFileDcNm.split("FileDc");
					fileService.updateFileDc("SITEMAIN", siteMainVO.getSiteMainNo(), HumanStringUtil.nullToInt(uptImgFileElm[1], 0), "ATTACH", (String) reqMap.get(uptImgFileDcNm));
				}
			}
			
			javaScript.setMessage(getMsg("action.complete.update"));
			break;

		case DELETE:
			siteMainService.modifySiteMainUseAt(siteMainVO);
			javaScript.setMessage(getMsg("action.complete.update"));
			break;

		default:
			break;
		}

		javaScript.setLocation("./list?siteNo=" + siteMainVO.getSiteNo());
		return new JavaScriptView(javaScript);
	}

	@RequestMapping(value="nttAjaxList")
	public @ResponseBody DataTableObject<?> nttAjaxList(
			@RequestParam(value="sEcho", required=true) String sEcho
			, HttpServletRequest request) throws Exception{

		String menuTy = request.getParameter("srchMenuTy");
		int bbsNo = EgovStringUtil.string2integer(EgovStringUtil.null2string(request.getParameter("srchBbsNo"), "0"));
		HumanListVO listVO = new HumanListVO(request);

		//컨텐츠 조회
		if(EgovStringUtil.equals(menuTy, "2")){
			listVO.setParam("srchNttMode", "CNTNTS");
			listVO = siteMainService.selectMainNttList(listVO);
		}
		else if(EgovStringUtil.equals(menuTy, "3") && bbsNo != 0){//게시판 조회
			listVO.setParam("srchNttMode", "BBS");
			BbsSettingVO bbsSettingVO = bbsSettingService.retrieveBoardSetting(bbsNo);
			listVO.setParam("bbsNo", String.valueOf(bbsNo));
			listVO.setParam("bbsTy", bbsSettingVO.getBbsTy());
			listVO.setParam(StaticValues.BOARD_TABLE_NM, bbsSettingVO.getTrgtTable());
			listVO.setParam("unityBbsUseAt", EgovStringUtil.null2string(bbsSettingVO.getUnityBbsUseAt(), "N"));//통합게시판 사용 여부
			listVO.setParam("siteNtceNo", request.getParameter("srchSiteNo"));//사이트 번호
			listVO.setParam("unityBbsSiteTy", bbsSettingVO.getUnityBbsSiteTy());//통합게시판 사이트 유형
			listVO = siteMainService.selectMainNttList(listVO);
		}

		//DataTable
		DataTableObject<EgovMap> dataTableObject = new DataTableObject<EgovMap>();
		dataTableObject.setsEcho(sEcho);
		dataTableObject.setiTotalRecords(listVO.getTotalCount());
		dataTableObject.setiTotalDisplayRecords(listVO.getTotalCount());
		dataTableObject.setsColumns("");

		if (listVO.getTotalCount()> 0) {
			dataTableObject.setAaData(listVO.getListObject());
		} else {
			dataTableObject.setAaData(new ArrayList<EgovMap>());
		}

		return dataTableObject;
	}


	/**사이트 메인페이지 - 게시물(컨텐츠, 게시판) 목록
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "nttList")
	public String winNttList(
			@RequestParam(required = true, value="siteNo") int siteNo
			, Model model) throws Exception {

		SiteVO siteVO = siteService.retrieveSite(siteNo);

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("siteNo", siteNo);
		paramMap.put("searchTy", "SITEMAIN");
		List<SiteMenuVO> siteMenuList = siteMenuService.selectPblcateSiteMenuList(paramMap);
		model.addAttribute("siteMenuList",  siteMenuList);
		model.addAttribute("siteVO",  siteVO);
		return "/admin/fnct/site/popup/ntt_list";
	}


	//메인 컨텐츠 연결
	//list
	@RequestMapping(value = "cntntsList")
	public String mainCntntslist(
			@RequestParam(value="siteNo", required=true) int siteNo
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception {

		HumanListVO listVO = new HumanListVO(request);
		//listVO = siteService.siteListVO(listVO);

		model.addAttribute("listVO", listVO);

		return "/admin/fnct/site/cntntsList";
	}
	//form
	//action


	//팝업관리
	//list
	//form
	//action


	//배너관리
	//list
	@RequestMapping(value="bannerList")
	public String bannerList(
			HttpServletRequest request
			, Model model) throws Exception{

		HumanListVO listVO = new HumanListVO(request);
		listVO = bannerService.bannerListVO(listVO);

		//site list
		Map paramMap = new HashMap();
		List siteListAll = siteService.selectSiteListAll(paramMap);

		model.addAttribute("siteListAll", siteListAll);

		model.addAttribute("useAtCode", CodeMap.USE_AT);
		model.addAttribute("listVO", listVO);

		//권한버튼관련
		String curPath = request.getServletPath();
		model.addAttribute("mngrSession", mngrSession);
		model.addAttribute("curPath", curPath);

		return "/admin/banner/list";
	}
	//form


	//action



}
