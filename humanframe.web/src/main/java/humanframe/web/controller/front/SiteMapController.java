package humanframe.web.controller.front;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
@RequestMapping("/fnct/siteMap")
public class SiteMapController extends HumanAbstractController {

	/**
	 * 
	 * @param session
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value={"index","list"})
	public String list(
			HttpSession session
			, HttpServletRequest request
			, Model model)  throws Exception {
		SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");
		List<SiteMenuVO> curSiteMenuList = curSiteVO.getSiteMenuList(); //(List)request.getAttribute("curSiteMenuList");
		
		List<SiteMenuVO> siteMapList = new ArrayList<SiteMenuVO>();
		Set passMenu = new HashSet<Integer>() ;
				
		for(SiteMenuVO menu : curSiteMenuList) {
			if(menu.getUpperMenuNo() == 0) continue;
			if("N".equals(menu.getSiteMapDspyAt()) || passMenu.contains(menu.getUpperMenuNo()) ) {
				passMenu.add(menu.getMenuNo());
			} else {
				siteMapList.add(menu);
			}
		}
		
		model.addAttribute("curSiteMenuList2", curSiteMenuList);
		model.addAttribute("siteMapList", siteMapList);

		/* TODO 
		 * GNB/LNB 구성 순서와 사이트맵의 메뉴 순서를 별도로 구성하고자 할 경우 관련된 admin등의 작업이 필요함 
		 */
		
		/* TODO 
		 * 동일테마에서 서로 다른 스타일의 사이트맵이 필요할 경우...
		 */
		String viewFile = "list"; 

		return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/siteMap/" + viewFile;
	}

}