package humanframe.web.controller.admin.crs;

import java.io.Writer;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;

import egovframework.rte.fdl.string.EgovStringUtil;
import humanframe.backoffice.service.CodeService;
import humanframe.backoffice.service.FileService;
import humanframe.backoffice.service.MngrService;
import humanframe.backoffice.service.SiteMenuService;
import humanframe.backoffice.session.MngrSession;
import humanframe.core.abst.HumanAbstractController;
import humanframe.core.util.HumanCommonUtil;
import humanframe.core.util.HumanStringUtil;
import humanframe.core.values.CRUDValues;
import humanframe.core.values.CodeMap;
import humanframe.core.view.JavaScript;
import humanframe.core.view.JavaScriptView;
import humanframe.core.vo.HumanListVO;
import humanframe.web.common.CommCodeMap;
import humanframe.web.common.CommConstants;
import humanframe.web.service.CrsService;
import humanframe.web.vo.CrsVO;

@SuppressWarnings({ "unchecked", "rawtypes" })
@Controller
@RequestMapping(value="/admin/fnct/crs")
public class AdminCrsController extends HumanAbstractController {

	@Resource(name="crsService")
	private CrsService crsService;

	@Resource(name="fileService")
	private FileService fileService;

	@Resource(name="codeService")
	private CodeService codeService;

	@Resource(name="siteMenuService")
	private SiteMenuService siteMenuService;

	@Resource(name="mngrService")
	private MngrService mngrService;

	@Autowired
	private MngrSession mngrSession;

	@RequestMapping(value="list")
	public String list(
			HttpServletRequest request
			, Model model) throws Exception{

		HumanListVO listVO = new HumanListVO(request);
		listVO = crsService.crsListVO(listVO);

		model.addAttribute("useAtCode", CodeMap.USE_AT);
		model.addAttribute("listVO", listVO);
		//권한버튼관련
		String curPath = request.getServletPath();
		model.addAttribute("mngrSession", mngrSession);
		model.addAttribute("curPath", curPath);
		//코드
		model.addAttribute("crsPartCode", CommCodeMap.CRS_TY1);
		model.addAttribute("crsStatusCode", CommCodeMap.CRS_TY2);

		return "/admin/fnct/crs/list";
	}

	@RequestMapping("excelDownload")
	public String excelDownload(
			HttpServletRequest request
			, Model model) throws Exception{

		Map paramMap = new HashMap();
		paramMap.put("useAt", HumanStringUtil.nvl(request.getParameter("useAt"),""));
		paramMap.put("srchText", HumanStringUtil.nvl(request.getParameter("srchText"),""));
		paramMap.put("srchKey", HumanStringUtil.nvl(request.getParameter("srchKey"),""));
		paramMap.put("srchPart", HumanStringUtil.nvl(request.getParameter("srchPart"),""));
		paramMap.put("srchStatus", HumanStringUtil.nvl(request.getParameter("srchStatus"),""));
		paramMap.put("srchStartDt", HumanStringUtil.nvl(request.getParameter("srchStartDt"),""));
		paramMap.put("srchEndDt", HumanStringUtil.nvl(request.getParameter("srchEndDt"),""));
		List listVO = crsService.crsListAll(paramMap);

		model.addAttribute("useAtCode", CodeMap.USE_AT);
		model.addAttribute("listVO", listVO);
		//코드
		model.addAttribute("crsPartCode", CommCodeMap.CRS_TY1);
		model.addAttribute("crsStatusCode", CommCodeMap.CRS_TY2);
		model.addAttribute("urlPath",request.getRequestURL());

		return "/admin/fnct/crs/excel";
	}
	@RequestMapping(value="view")
	public String view(
			@RequestParam(value="crsNo", required=true) int crsNo
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception{

		CrsVO crsVO = crsService.retrieveCrs(crsNo);

		model.addAttribute("useAtCode", CodeMap.USE_AT);

		model.addAttribute("crsVO", crsVO);
		model.addAttribute("param", reqMap);

		//권한버튼관련
		String curPath = request.getServletPath();
		model.addAttribute("mngrSession", mngrSession);
		model.addAttribute("curPath", curPath);

		//코드
		model.addAttribute("crsPartCode", CommCodeMap.CRS_TY1);
		model.addAttribute("crsStatusCode", CommCodeMap.CRS_TY2);

		return "/admin/fnct/crs/view";
	}

	@RequestMapping(value={"form", "answerForm"})
	public String form(
			CrsVO crsVO
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception{

		int crsNo = EgovStringUtil.string2integer((String) reqMap.get("crsNo"));

		if(crsNo == 0){
			crsVO.setCrud(CRUDValues.CREATE);
		}else{
			crsVO = crsService.retrieveCrs(crsNo);
			crsVO.setCrud(CRUDValues.UPDATE);
		}

		//관리자 정보
		HumanListVO listVO = new HumanListVO(request);
		listVO = mngrService.mngrListVO(listVO);
		model.addAttribute("mngrListVO", listVO);

		Map<String, Object> paramMap = new HashMap<String, Object>();
	 	paramMap.put("filterKey", "codeGroupId");
	 	paramMap.put("filterVal", CommConstants.TERM_TY_GROUP_ID);//수정

		//return value
		model.addAttribute("useAtCode", CodeMap.USE_AT);

		model.addAttribute("crsVO", crsVO);
		model.addAttribute("param", reqMap);

		//권한버튼관련
		String curPath = request.getServletPath();
		model.addAttribute("mngrSession", mngrSession);
		model.addAttribute("curPath", curPath);

		model.addAttribute("crsPartCode", CommCodeMap.CRS_TY1);
		model.addAttribute("crsStatusCode", CommCodeMap.CRS_TY2);

		String rtnUrl = "/admin/fnct/crs/form";
		String URI_PATH = request.getRequestURI().substring(request.getContextPath().length());
		if (URI_PATH.contains("answerForm")) {
			rtnUrl = "/admin/fnct/crs/answerForm";
		}
		return rtnUrl;
	}

	@RequestMapping("useAtChg")
	public void useAtChg(
			@RequestParam(value="crsNo", required=true, defaultValue = "0") int crsNo
			, @RequestParam(value="useAt", required=true) String useAt
			, Writer out) throws Exception {
		String rtnVal = "false";

		Map paramMap = new HashMap();
		paramMap.put("crsNo", crsNo);
		paramMap.put("useAt", useAt);

		Integer resultCnt = crsService.updateCrsUseAt(paramMap);

		if(resultCnt == 1){//update success 1 : fail 0
			rtnVal = "true";
		}
		out.write(rtnVal);
	}

	@RequestMapping(value={"action", "answerAction"})
	public View action(
				CrsVO crsVO
				, MultipartHttpServletRequest request
				, @RequestParam Map<String,Object> reqMap
				, HttpSession session) throws Exception {

		JavaScript javaScript = new JavaScript();
		String URI_PATH = request.getRequestURI().substring(request.getContextPath().length());
		if (URI_PATH.contains("answerAction")) {

		}else{
			crsVO.setUpdusrId(mngrSession.getMngrId());
			crsVO.setUpdusrNm(mngrSession.getMngrNm());
			crsVO.setUpdusrUniqueId(mngrSession.getUniqueId());
		}
		crsVO.setCrtrId(mngrSession.getMngrId());
		crsVO.setCrtrNm(mngrSession.getMngrNm());
		crsVO.setCrtrUniqueId(mngrSession.getUniqueId());


		Map<String, MultipartFile> fileMap = request.getFileMap();

		switch (crsVO.getCrud()) {
			case CREATE:

				crsService.createCrs(crsVO);
				if (URI_PATH.contains("answerAction")) {
					fileService.creatFileInfo(fileMap, crsVO.getCrsNo(), "FNCTCRS1");
				}else{
					fileService.creatFileInfo(fileMap, crsVO.getCrsNo(), "FNCTCRS");
				}
				javaScript.setMessage(getMsg("action.complete.insert"));
				break;

			case UPDATE:

				crsService.updateCrs(crsVO);
				String delAttachFileNo = HumanCommonUtil.getSqlStr((String) reqMap.get("delAttachFileNo"));
				String[] arrDelAttachFile = delAttachFileNo.split(",");
				if (URI_PATH.contains("answerAction")) {
					if(!EgovStringUtil.isEmpty(arrDelAttachFile[0])) fileService.deleteFilebyNo(arrDelAttachFile, crsVO.getCrsNo(), "FNCTCRS1", "ATTACH");
					fileService.creatFileInfo(fileMap, crsVO.getCrsNo(), "FNCTCRS1");
				}else{
					if(!EgovStringUtil.isEmpty(arrDelAttachFile[0])) fileService.deleteFilebyNo(arrDelAttachFile, crsVO.getCrsNo(), "FNCTCRS", "ATTACH");
					fileService.creatFileInfo(fileMap, crsVO.getCrsNo(), "FNCTCRS");
				}
				javaScript.setMessage(getMsg("action.complete.update"));
				break;

			case DELETE:

				crsService.deleteCrs(crsVO.getCrsNo());
				fileService.deleteFileByUpperNo(crsVO.getCrsNo(), "FNCTCRS");
				fileService.deleteFileByUpperNo(crsVO.getCrsNo(), "FNCTCRS1");
				javaScript.setMessage(getMsg("action.complete.delete"));
				break;

			default:
				break;
		}

		String srchKey = (String) reqMap.get("srchKey");
		String srchText = (String) reqMap.get("srchText");
		String srchPart = (String) reqMap.get("srchPart");
		String srchStatus = (String) reqMap.get("srchStatus");
		String srchStartDt = (String) reqMap.get("srchStartDt");
		String srchEndDt = (String) reqMap.get("srchEndDt");
		String curPage = (String) reqMap.get("curPage");
		String useAt = (String) reqMap.get("searchUseAt");
		String param = "?srchKey="+srchKey+"&srchText="+srchText+"&srchPart="+srchPart+"&srchStatus="+srchStatus+"&srchStartDt="+srchStartDt+"&srchEndDt="+srchEndDt+"&curPage="+curPage+"&useAt="+useAt;

		javaScript.setLocation("./list"+param);

		return new JavaScriptView(javaScript);
	}
}
