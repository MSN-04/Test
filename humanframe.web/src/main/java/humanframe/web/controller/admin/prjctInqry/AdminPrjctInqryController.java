package humanframe.web.controller.admin.prjctInqry;

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
import humanframe.backoffice.service.FileService;
import humanframe.backoffice.service.MngrService;
import humanframe.backoffice.session.MngrSession;
import humanframe.core.abst.HumanAbstractController;
import humanframe.core.values.CRUDValues;
import humanframe.core.view.JavaScript;
import humanframe.core.view.JavaScriptView;
import humanframe.core.vo.HumanListVO;
import humanframe.web.common.CommCodeMap;
import humanframe.web.service.PrjctInqryService;
import humanframe.web.vo.PrjctInqryVO;

@SuppressWarnings({ "unchecked", "rawtypes" })
@Controller
@RequestMapping(value="/admin/fnct/prjctInqry")
public class AdminPrjctInqryController extends HumanAbstractController {

	private static String SRVCID = "PRJCTINQRY";

	@Resource(name="prjctInqryService")
	private PrjctInqryService prjctInqryService;

	@Resource(name="fileService")
	private FileService fileService;

	@Resource(name="mngrService")
	private MngrService mngrService;

	@Autowired
	private MngrSession mngrSession;

	@RequestMapping(value="list")
	public String list(
			HttpServletRequest request
			, Model model) throws Exception{

		HumanListVO listVO = new HumanListVO(request);
		listVO = prjctInqryService.prjctInqryListVO(listVO);

		/*model.addAttribute("useAt", CodeMap.USE_AT);*/
		model.addAttribute("statusCode", CommCodeMap.CRS_TY2);
		model.addAttribute("bugetTy", CommCodeMap.BUDGET_TY);
		model.addAttribute("listVO", listVO);
		//권한버튼관련
		String curPath = request.getServletPath();
		model.addAttribute("mngrSession", mngrSession);
		model.addAttribute("curPath", curPath);

		return "/admin/fnct/prjctInqry/list";
	}

	@RequestMapping(value="view")
	public String view(
			@RequestParam(value="inqryNo", required=true) int inqryNo
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception{

		PrjctInqryVO prjctInqryVO = prjctInqryService.retrievePrjctInqry(inqryNo);

		model.addAttribute("prjctInqryVO", prjctInqryVO);
		model.addAttribute("param", reqMap);
		model.addAttribute("statusCode", CommCodeMap.CRS_TY2);
		model.addAttribute("bugetTy", CommCodeMap.BUDGET_TY);

		//권한버튼관련
		String curPath = request.getServletPath();
		model.addAttribute("mngrSession", mngrSession);
		model.addAttribute("curPath", curPath);

		return "/admin/fnct/prjctInqry/view";
	}

	@RequestMapping(value={"form"})
	public String form(
			PrjctInqryVO prjctInqryVO
			, @RequestParam Map<String,Object> reqMap
			, HttpServletRequest request
			, Model model) throws Exception{

		int inqryNo = EgovStringUtil.string2integer((String) reqMap.get("inqryNo"));

		if(inqryNo == 0){
			prjctInqryVO.setCrud(CRUDValues.CREATE);
		}else{
			prjctInqryVO = prjctInqryService.retrievePrjctInqry(inqryNo);
			prjctInqryVO.setCrud(CRUDValues.UPDATE);
		}

		model.addAttribute("prjctInqryVO", prjctInqryVO);
		model.addAttribute("param", reqMap);
		model.addAttribute("statusCode", CommCodeMap.CRS_TY2);
		model.addAttribute("bugetTy", CommCodeMap.BUDGET_TY);

		//권한버튼관련
		String curPath = request.getServletPath();
		model.addAttribute("mngrSession", mngrSession);
		model.addAttribute("curPath", curPath);

		return "/admin/fnct/prjctInqry/form";
	}

	@RequestMapping("useAtChg")
	public void useAtChg(
			@RequestParam(value="inqryNo", required=true, defaultValue = "0") int inqryNo
			, @RequestParam(value="useAt", required=true) String useAt
			, Writer out) throws Exception {
		String rtnVal = "false";

		Map paramMap = new HashMap();
		paramMap.put("inqryNo", inqryNo);
		paramMap.put("useAt", useAt);

		Integer resultCnt = prjctInqryService.updatePrjctInqryUseAt(paramMap);;

		if(resultCnt == 1){//update success 1 : fail 0
			rtnVal = "true";
		}
		out.write(rtnVal);
	}

	@RequestMapping(value={"action"})
	public View action(
				PrjctInqryVO prjctInqryVO
				, MultipartHttpServletRequest request
				, @RequestParam Map<String,Object> reqMap
				, HttpSession session) throws Exception {

		JavaScript javaScript = new JavaScript();

		Map<String, MultipartFile> fileMap = request.getFileMap();

		prjctInqryVO.setUpdusrId(mngrSession.getMngrId());
		prjctInqryVO.setUpdusrNm(mngrSession.getMngrNm());

		switch (prjctInqryVO.getCrud()) {
			case CREATE:
				prjctInqryService.insertPrjctInqry(prjctInqryVO);
				fileService.creatFileInfo(fileMap, prjctInqryVO.getInqryNo(), SRVCID);
				javaScript.setMessage(getMsg("action.complete.insert"));
				break;

			case UPDATE:
				prjctInqryService.updatePrjctInqry(prjctInqryVO);
				javaScript.setMessage(getMsg("action.complete.update"));
				break;

			case DELETE:
				prjctInqryService.deletePrjctInqry(prjctInqryVO.getInqryNo());
				fileService.deleteFileByUpperNo(prjctInqryVO.getInqryNo(), SRVCID);
				javaScript.setMessage(getMsg("action.complete.delete"));
				break;

			default:
				break;
		}

		String pageParam = (String) reqMap.get("pageParam");
		javaScript.setLocation("./list?"+pageParam);

		return new JavaScriptView(javaScript);
	}
}
