package humanframe.web.controller.front;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;

import humanframe.backoffice.service.FileService;
import humanframe.core.abst.HumanAbstractController;
import humanframe.core.view.JavaScript;
import humanframe.core.view.JavaScriptView;
import humanframe.web.service.PrjctInqryService;
import humanframe.web.vo.PrjctInqryVO;

@Controller
@RequestMapping("/fnct/prjctInqry")
public class PrjctInqryController extends HumanAbstractController {

	private static String SRVCID = "PRJCTINQRY";

	@Resource(name="prjctInqryService")
	private PrjctInqryService prjctInqryService;

	@Resource(name="fileService")
	private FileService fileService;

	@RequestMapping(value="action")
	public View action(
				PrjctInqryVO prjctInqryVO
				, MultipartHttpServletRequest request
				, @RequestParam Map<String,Object> reqMap
				, HttpSession session) throws Exception {

		JavaScript javaScript = new JavaScript();

		Map<String, MultipartFile> fileMap = request.getFileMap();

		prjctInqryService.insertPrjctInqry(prjctInqryVO);
		fileService.creatFileInfo(fileMap, prjctInqryVO.getInqryNo(), SRVCID);

		javaScript.setMessage(getMsg("action.complete.insert"));
		javaScript.setMethod("window.history.back()");
		return new JavaScriptView(javaScript);
	}
}