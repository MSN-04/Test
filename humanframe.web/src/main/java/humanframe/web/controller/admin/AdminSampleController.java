package humanframe.web.controller.admin;

import java.io.Writer;
import java.util.HashMap;
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
import humanframe.backoffice.service.SiteMenuService;
import humanframe.backoffice.service.SiteService;
import humanframe.backoffice.session.MngrSession;
import humanframe.core.abst.HumanAbstractController;
import humanframe.core.util.HumanCommonUtil;
import humanframe.core.values.CRUDValues;
import humanframe.core.values.CodeMap;
import humanframe.core.view.JavaScript;
import humanframe.core.view.JavaScriptView;
import humanframe.core.vo.HumanListVO;
import humanframe.web.service.SampleService;
import humanframe.web.vo.SampleVO;

@SuppressWarnings({ "unchecked", "rawtypes" })
@Controller
@RequestMapping(value="/admin/fnct/sample")
public class AdminSampleController extends HumanAbstractController {

	@Resource(name="sampleService")
	private SampleService sampleService;

	@Resource(name="fileService")
	private FileService fileService;

	@Resource(name="siteService")
	private SiteService siteService;

	@Resource(name="codeService")
	private CodeService codeService;

	@Resource(name="siteMenuService")
	private SiteMenuService siteMenuService;

	@Autowired
	private MngrSession mngrSession;

	@RequestMapping(value="list")
	public String list(
			HttpServletRequest request
			, Model model) throws Exception{

		HumanListVO listVO = new HumanListVO(request);
		listVO = sampleService.sampleListVO(listVO);

		model.addAttribute("useAtCode", CodeMap.USE_AT);
		model.addAttribute("listVO", listVO);

		//권한버튼관련
		String curPath = request.getServletPath();
		model.addAttribute("mngrSession", mngrSession);
		model.addAttribute("curPath", curPath);

		return "/admin/fnct/sample/list";
	}

	@RequestMapping(value="view")
	public String view(
			@RequestParam(value="sampleNo", required=true) int sampleNo
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception{

		SampleVO sampleVO = sampleService.retrieveSample(sampleNo);

		model.addAttribute("linkTrgtTyCode", CodeMap.LINK_TRGT_TY);
		model.addAttribute("useAtCode", CodeMap.USE_AT);

		model.addAttribute("sampleVO", sampleVO);
		model.addAttribute("param", reqMap);

		//권한버튼관련
		String curPath = request.getServletPath();
		model.addAttribute("mngrSession", mngrSession);
		model.addAttribute("curPath", curPath);

		return "/admin/fnct/sample/view";
	}

	@RequestMapping(value="form")
	public String form(
			SampleVO sampleVO
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception{

		//log.debug("sampleVO: " + sampleVO.toString());

		int sampleNo = EgovStringUtil.string2integer((String) reqMap.get("sampleNo"));

		if(sampleNo == 0){
			sampleVO.setCrud(CRUDValues.CREATE);
		}else{
			sampleVO = sampleService.retrieveSample(sampleNo);
			sampleVO.setCrud(CRUDValues.UPDATE);
		}


		//return value
		model.addAttribute("useAtCode", CodeMap.USE_AT);

		model.addAttribute("sampleVO", sampleVO);
		model.addAttribute("param", reqMap);

		//권한버튼관련
		String curPath = request.getServletPath();
		model.addAttribute("mngrSession", mngrSession);
		model.addAttribute("curPath", curPath);

		return "/admin/fnct/sample/form";
	}

	@RequestMapping("useAtChg")
	public void useAtChg(
			@RequestParam(value="sampleNo", required=true, defaultValue = "0") int sampleNo
			, @RequestParam(value="useAt", required=true) String useAt
			, Writer out) throws Exception {
		String rtnVal = "false";

		Map paramMap = new HashMap();
		paramMap.put("sampleNo", sampleNo);
		paramMap.put("useAt", useAt);

		Integer resultCnt = sampleService.updateSampleUseAt(paramMap);

		if(resultCnt == 1){//update success 1 : fail 0
			rtnVal = "true";
		}
		out.write(rtnVal);
	}

	@RequestMapping(value="action")
	public View action(
				SampleVO sampleVO
				, MultipartHttpServletRequest request
				, @RequestParam(value="arrMenuNo", required=false) String[] arrMenuNo
				, @RequestParam Map<String,Object> reqMap
				, HttpSession session) throws Exception {

		JavaScript javaScript = new JavaScript();
		sampleVO.setCrtrId(mngrSession.getMngrId());
		sampleVO.setCrtrNm(mngrSession.getMngrNm());
		sampleVO.setUpdusrId(mngrSession.getMngrId());
		sampleVO.setUpdusrNm(mngrSession.getMngrNm());

		Map<String, MultipartFile> fileMap = request.getFileMap();
		switch (sampleVO.getCrud()) {
			case CREATE:

				sampleService.createSample(sampleVO);
				fileService.creatFileInfo(fileMap, sampleVO.getSampleNo(), "SAMPLE");

				javaScript.setMessage(getMsg("action.complete.insert"));
				break;

			case UPDATE:

				sampleService.updateSample(sampleVO);
				String delAttachFileNo = HumanCommonUtil.getSqlStr((String) reqMap.get("delAttachFileNo"));
				String[] arrDelAttachFile = delAttachFileNo.split(",");
				if(!EgovStringUtil.isEmpty(arrDelAttachFile[0])) fileService.deleteFilebyNo(arrDelAttachFile, sampleVO.getSampleNo(), "SAMPLE", "ATTACH");
				fileService.creatFileInfo(fileMap, sampleVO.getSampleNo(), "SAMPLE");

				javaScript.setMessage(getMsg("action.complete.update"));
				break;

			case DELETE:

				sampleService.deleteSample(sampleVO.getSampleNo());
				fileService.deleteFileByUpperNo(sampleVO.getSampleNo(), "SAMPLE");

				javaScript.setMessage(getMsg("action.complete.delete"));
				break;

			default:
				break;
		}

		javaScript.setLocation("./list");
		return new JavaScriptView(javaScript);
	}
}
