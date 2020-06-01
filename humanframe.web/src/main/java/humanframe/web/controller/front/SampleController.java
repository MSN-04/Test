package humanframe.web.controller.front;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;

import egovframework.rte.fdl.string.EgovStringUtil;
import humanframe.backoffice.service.FileService;
import humanframe.backoffice.vo.SiteMenuVO;
import humanframe.backoffice.vo.SiteVO;
import humanframe.core.abst.HumanAbstractController;
import humanframe.core.util.HumanCommonUtil;
import humanframe.core.values.CRUDValues;
import humanframe.core.values.CodeMap;
import humanframe.core.view.JavaScript;
import humanframe.core.view.JavaScriptView;
import humanframe.core.vo.HumanListVO;
import humanframe.web.service.SampleService;
import humanframe.web.vo.SampleVO;

@Controller
@RequestMapping("/fnct/sample")
public class SampleController extends HumanAbstractController {

	@Resource(name="sampleService")
	private SampleService sampleService;

	@Resource(name="fileService")
	private FileService fileService;

	@RequestMapping(value={"index","list"})
	public String list(
			HttpSession session
			, HttpServletRequest request
			, Model model)  throws Exception {
		SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");

		HumanListVO listVO = new HumanListVO(request);
		listVO = sampleService.sampleListVO(listVO);

		model.addAttribute("useAtCode", CodeMap.USE_AT);
		model.addAttribute("listVO", listVO);

		return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/sample/list";
	}

	@RequestMapping(value={"form"})
	public String form(
			SampleVO sampleVO
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception{

		//log.debug("sampleVO: " + sampleVO.toString());
		SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");
		SiteMenuVO curMenuVO = (SiteMenuVO)request.getAttribute("curMenuVO");
		String currUri = curMenuVO.getMenuUri();

		int sampleNo = EgovStringUtil.string2integer((String) reqMap.get("sampleNo"));

		sampleVO.setSiteNo(curSiteVO.getSiteNo());
		sampleVO.setMenuNo(curMenuVO.getMenuNo());

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
		model.addAttribute("currUri", currUri);

		return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/sample/form";
	}

	@RequestMapping(value={"view"})
	public String view(
			@RequestParam(value="sampleNo", required=true) int sampleNo
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception{

		SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");
		SiteMenuVO curMenuVO = (SiteMenuVO)request.getAttribute("curMenuVO");
		String currUri = curMenuVO.getMenuUri();

		SampleVO sampleVO = sampleService.retrieveSample(sampleNo);

		//return value
		model.addAttribute("useAtCode", CodeMap.USE_AT);

		model.addAttribute("sampleVO", sampleVO);
		model.addAttribute("param", reqMap);
		model.addAttribute("currUri", currUri);

		return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/sample/view";
	}

	@RequestMapping(value="action")
	public View action(
				SampleVO sampleVO
				, MultipartHttpServletRequest request
				, @RequestParam(value="arrMenuNo", required=false) String[] arrMenuNo
				, @RequestParam Map<String,Object> reqMap
				, HttpSession session) throws Exception {

		JavaScript javaScript = new JavaScript();

		SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");
		SiteMenuVO curMenuVO = (SiteMenuVO)request.getAttribute("curMenuVO");
		//MberVO mberVO = (MberVO)session.getAttribute(getProperties("SESSION_MEMBER"));

		sampleVO.setSiteNo(curSiteVO.getSiteNo());
		sampleVO.setMenuNo(curMenuVO.getMenuNo());

		/*if(mberVO != null){
			sampleVO.setCrtrId(mberVO.getMberId());
			sampleVO.setCrtrNm(mberVO.getMberNm());
			sampleVO.setUpdusrId(mberVO.getMberId());
			sampleVO.setUpdusrNm(mberVO.getMberNm());

		}else{*/
			String wrter = (String)reqMap.get("wrter");

			sampleVO.setCrtrNm(wrter);
			sampleVO.setUpdusrNm(wrter);
		//}

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
				if(!EgovStringUtil.isEmpty(arrDelAttachFile[0])) fileService.deleteFilebyNo(arrDelAttachFile, sampleVO.getSampleNo(), "FNCTSAMPLE", "ATTACH");
				fileService.creatFileInfo(fileMap, sampleVO.getSampleNo(), "FNCTSAMPLE");

				javaScript.setMessage(getMsg("action.complete.update"));
				break;

			case DELETE:

				sampleService.deleteSample(sampleVO.getSampleNo());
				fileService.deleteFileByUpperNo(sampleVO.getSampleNo(), "FNCTSAMPLE");

				javaScript.setMessage(getMsg("action.complete.delete"));
				break;

			default:
				break;
		}

		javaScript.setLocation("./list");
		return new JavaScriptView(javaScript);
	}
}