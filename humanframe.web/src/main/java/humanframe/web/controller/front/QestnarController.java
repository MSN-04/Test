package humanframe.web.controller.front;

import humanframe.backoffice.service.FileService;
import humanframe.backoffice.service.FileUploadService;
import humanframe.backoffice.service.MberService;
import humanframe.backoffice.session.MberSession;
import humanframe.backoffice.vo.FileVO;
import humanframe.backoffice.vo.MberVO;
import humanframe.backoffice.vo.SiteMenuVO;
import humanframe.backoffice.vo.SiteVO;
import humanframe.core.abst.HumanAbstractController;
import humanframe.core.util.HumanDateUtil;
import humanframe.core.util.HumanHtmlUtil;
import humanframe.core.values.CRUDValues;
import humanframe.core.view.JavaScript;
import humanframe.core.view.JavaScriptView;
import humanframe.core.vo.HumanListVO;
import humanframe.web.service.QestnarService;
import humanframe.web.vo.QestnarQestnVO;
import humanframe.web.vo.QestnarVO;

import java.net.InetAddress;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.View;

import egovframework.rte.fdl.string.EgovStringUtil;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@SuppressWarnings({"rawtypes","unchecked"})
@Controller
@RequestMapping("/fnct/qestnar")
public class QestnarController extends HumanAbstractController {

    private static String progrmTy = "QESTNAR";

    @Resource(name = "fileUploadService")
    private FileUploadService fileUploadService;

    @Resource(name="mberService")
    MberService mberService;

    @Resource(name="fileService")
    private FileService fileService;

    @Resource(name="qestnarService")
    private QestnarService qestnarService;

    @Autowired
    private MberSession mberSession;

    /**
     * 기능프로그램>설문조사 리스트
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value={"index","list"})
    public String list(
            @RequestParam(required=false, defaultValue="ING") String srchSttus
            ,HttpServletRequest request, Model model) throws Exception {

        if( !"ING".equals(srchSttus) && !"END".equals(srchSttus) ){ srchSttus = "ING"; }

        SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");
        SiteMenuVO curMenuVO = (SiteMenuVO)request.getAttribute("curMenuVO");

        String baseUri = (String) request.getAttribute("baseUri");
        String menuUri = curMenuVO.getMenuUri();
        if (EgovStringUtil.search(menuUri, "?") > 0) {
            String[] menuUriSplit = menuUri.split("\\?");
            menuUri = menuUriSplit[0];
        }
        String curUri = baseUri + "/" + menuUri;

        HumanListVO listVO = new HumanListVO(request);
        listVO.setParam("srchUseAt", "Y");
        listVO.setParam("srchOthbcAt", "Y");
        listVO.setParam("srchSttus", srchSttus);
        listVO.setParam("siteNo", curSiteVO.getSiteNo());

        listVO = qestnarService.qestnarListVO(listVO);

        model.addAttribute("listVO", listVO);
        model.addAttribute("curUri", curUri);

        return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/qestnar/list";
    }

    /**
     * 기능프로그램>설문조사 조회
     * @param qestnarNo
     * @param model
     * @param request
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping("view")
    public String view(@RequestParam(required = true, defaultValue = "0") int qestnarNo
            ,@RequestParam(required=false, defaultValue="ING") String srchSttus
            ,Model model, HttpServletRequest request, HttpSession session) throws Exception {

        QestnarVO qestnarVO = null;
        List<FileVO> imgFileList = null;
        SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");

        String srchWord = EgovStringUtil.null2void(request.getParameter("srchWord"));
        List<EgovMap> listQesitm = null;
        List<EgovMap> listPrevNext = null;

        mberSession = (MberSession) session.getAttribute(getProperties("SESSION_MEMBER"));
        HashMap<String, Object> mapAuth = getAuth(session);
        String dplctCnfirmCode = "";
        int result = 0;

        //참여 여부 체크
        if(mberSession != null || mapAuth != null){
        	if(mberSession != null){
        		//dplctCnfirmCode = mberSession.getDplctCnfirmCode();
        	}else{
        		dplctCnfirmCode = (String)mapAuth.get("dupInfo");
        	}
        	Map<String,Object> duplParamMap = new HashMap<String, Object>();
    		duplParamMap.put("qestnarNo", qestnarNo);
    		duplParamMap.put("dplctCnfirmCode", dplctCnfirmCode);
    		result = qestnarService.retrieveApplyCount(duplParamMap);
    		if (result > 0) {
    			model.addAttribute("complete","OK");
    		}
        }

        if(qestnarNo > 0){
            qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);
            qestnarVO.setCrud(CRUDValues.UPDATE);
            qestnarVO.setCn(HumanHtmlUtil.enterToBr(qestnarVO.getCn()));

            //썸네일
            HashMap<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("upperNo", qestnarVO.getQestnarNo());
            paramMap.put("srvcId", progrmTy);
            paramMap.put("fileTy", "IMG");
            imgFileList = fileService.selectFileList(paramMap);

            //이전글 다음글 리스트
            paramMap = new HashMap<String, Object>();
            paramMap.put("srchUsgAt", "Y");
            paramMap.put("srchOthbcAt", "Y");
            paramMap.put("srchWord", srchWord);
            paramMap.put("qestnarNo", qestnarNo);
            paramMap.put("srchSttus", EgovStringUtil.null2string(srchSttus,"ING"));
            paramMap.put("siteNo", curSiteVO.getSiteNo());
            listPrevNext = qestnarService.retrieveQestnarPrevNext(paramMap);

            //질문,항목 리스트
            if( "ING".equals(qestnarVO.getProgrsSttus()) || "END".equals(qestnarVO.getProgrsSttus()) ){
                listQesitm = qestnarService.retrieveQestnAllList(paramMap);
            }

        }

        Device currentDevice = DeviceUtils.getCurrentDevice(request);
        String mobileAt = "";
        if(currentDevice.isMobile()){
            mobileAt = "Mobile";
        }

        model.addAttribute("qestnarVO", qestnarVO);
        model.addAttribute("imgFileList", imgFileList);
        model.addAttribute("mobileAt", mobileAt);
        model.addAttribute("listQesitm", listQesitm);
        model.addAttribute("listPrevNext", listPrevNext);

        return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/qestnar/view";
    }

    @RequestMapping("privacy")
    public String privacy(@RequestParam(required = true, defaultValue = "0") int qestnarNo
            ,Model model, HttpServletRequest request, HttpSession session) throws Exception {

        mberSession = (MberSession) session.getAttribute(getProperties("SESSION_MEMBER"));
        QestnarVO qestnarVO = null;
        SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");

        String crtrUniqueId = "";
        String dplctCnfirmCode = "";
        int result = 0;
        HashMap<String, Object> paramMap = new HashMap<String, Object>();
        if ( mberSession != null ) { // 회원인증
            crtrUniqueId = mberSession.getUniqueId();
           // dplctCnfirmCode = mberSession.getDplctCnfirmCode();

        } else { //회원&비회원 UniqueId 설정
            HashMap<String, Object> mapAuth = getAuth(session);
            if ( mapAuth != null ) {

                paramMap.put("qestnarNo", qestnarNo);
                paramMap.put("uniqueId", "GSTINFO_");
               // String maxGSTINFOCode = qestnarService.retrieveMaxUniqueId(paramMap);
                SecureRandom random = new SecureRandom();
                String maxGSTINFOCode = "Q_" + HumanDateUtil.getCurrentYmdHms() + random.nextInt(1000000);
                crtrUniqueId = maxGSTINFOCode;
                dplctCnfirmCode = (String)mapAuth.get("dupInfo");
            }
        }
        //방문객 UniqueId 설정
        if ( EgovStringUtil.isEmpty(dplctCnfirmCode) ) {
            paramMap.put("qestnarNo", qestnarNo);
            paramMap.put("uniqueId", "TMPINFO_");
            //String maxTMPINFOCode = qestnarService.retrieveMaxUniqueId(paramMap);
            SecureRandom random = new SecureRandom();
            String maxTMPINFOCode = "Q_" + HumanDateUtil.getCurrentYmdHms() + random.nextInt(1000000);
            crtrUniqueId = maxTMPINFOCode;
            dplctCnfirmCode = maxTMPINFOCode;
        }

      	//참여 여부 체크
    		Map<String,Object> duplParamMap = new HashMap<String, Object>();
    		duplParamMap.put("qestnarNo", qestnarNo);
    		duplParamMap.put("dplctCnfirmCode", dplctCnfirmCode);
    		result = qestnarService.retrieveApplyCount(duplParamMap);
    		if (result > 0) {
    			model.addAttribute("alertMsg","이미 참여하셨습니다.");
                model.addAttribute("goUrl","/minwon/survey");
                return "/common/msg";
    		}


        paramMap.put("langCode", "en");
        List<EgovMap> countryList =  qestnarService.selectCountryList(paramMap);	// 일문 데이터없음

        MberVO mberVO = null;
        if(qestnarNo > 0){
            qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);
            // 설문대상확인
            if ("Y".equals(qestnarVO.getQustnrTrget())) {
    			if (mberSession == null) {
    				return "redirect:"+getProperties("GLOBAL_SITE_DOMAIN")+"/member/login";
    			}
    		} else if ("N".equals(qestnarVO.getQustnrTrget())) {
    			if (mberSession == null && getAuth(session) == null) {
    				return "redirect:"+getProperties("GLOBAL_SITE_DOMAIN")+"/member/login";
    			}
    		}

            if(mberSession != null){
            	Map<String, Object> parmMap = new HashMap<String, Object>();
            	parmMap.put("mberId", mberSession.getMberId());
            	parmMap.put("uniqueId", mberSession.getUniqueId());
                mberVO = mberService.selectMber(parmMap);
            }
            if(getAuth(session) != null){
            	mberVO = new MberVO();
                HashMap<String, Object> mapAuth = getAuth(session);
        //        String dplctCnfirmCode = String.valueOf(mapAuth.get("dupInfo"));
                String userNm = String.valueOf(mapAuth.get("userNm"));

                mberVO.setMberNm(userNm);
              //  mberVO.setDplctCnfirmCode(dplctCnfirmCode);
            }
        }

        Device currentDevice = DeviceUtils.getCurrentDevice(request);
        String mobileAt = "";
        if(currentDevice.isMobile()){
            mobileAt = "Mobile";
        }

        model.addAttribute("qestnarVO", qestnarVO);
        model.addAttribute("mobileAt", mobileAt);
        model.addAttribute("mberVO", mberVO);
        model.addAttribute("countryList", countryList);

        return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/qestnar/privacy";
    }

    /**
     * 기능프로그램>설문조사 등록 폼
     * @param qestnarNo
     * @param model
     * @param request
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping("apply")
    public String apply(
            @RequestParam(required = true, defaultValue = "0") int qestnarNo
            , HttpServletRequest request
            , Model model
            , HttpSession session) throws Exception {

        SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");

        //세션확인
        mberSession = (MberSession) session.getAttribute(getProperties("SESSION_MEMBER"));
        String nm = request.getParameter("nm");
        String email = request.getParameter("email");
        String telno = request.getParameter("telno");
        String country = request.getParameter("country");
        String nationality = request.getParameter("nationality");
        String address = request.getParameter("address");
        String crtrUniqueId = "";
        String dplctCnfirmCode = "";
        String qustnrTrget = request.getParameter("qustnrTrget");
        int result = 0;
        HashMap<String, Object> paramMap = new HashMap<String, Object>();
        if ( mberSession != null ) { // 회원인증
            crtrUniqueId = mberSession.getUniqueId();
           // dplctCnfirmCode = mberSession.getDplctCnfirmCode();

        } else { //회원&비회원 UniqueId 설정
            HashMap<String, Object> mapAuth = getAuth(session);
            if ( mapAuth != null ) {

                paramMap.put("qestnarNo", qestnarNo);
                paramMap.put("uniqueId", "GSTINFO_");
               // String maxGSTINFOCode = qestnarService.retrieveMaxUniqueId(paramMap);
                SecureRandom random = new SecureRandom();
                String maxGSTINFOCode = "Q_" + HumanDateUtil.getCurrentYmdHms() + random.nextInt(1000000);

                crtrUniqueId = maxGSTINFOCode;
                dplctCnfirmCode = (String)mapAuth.get("dupInfo");
            }
        }
        //방문객 UniqueId 설정
        if ( EgovStringUtil.isEmpty(dplctCnfirmCode) ) {
            paramMap.put("qestnarNo", qestnarNo);
            paramMap.put("uniqueId", "TMPINFO_");
            //String maxTMPINFOCode = qestnarService.retrieveMaxUniqueId(paramMap);
            SecureRandom random = new SecureRandom();
            String maxTMPINFOCode = "Q_" + HumanDateUtil.getCurrentYmdHms() + random.nextInt(1000000);
            crtrUniqueId = maxTMPINFOCode;
            dplctCnfirmCode = maxTMPINFOCode;
        }

     // 모집대상: 회원(Y) , 회원+비회원(N)
		if (!"A".equals(qustnrTrget)) {
			if (EgovStringUtil.isEmpty(dplctCnfirmCode)) return "redirect:"+getProperties("GLOBAL_SITE_DOMAIN")+"/member/login";

			// 모집대상이 회원일때 비회원이 접근한 경우
			if("Y".equals(qustnrTrget) && crtrUniqueId.startsWith("GSTINFO_")) {
				return "redirect:"+getProperties("GLOBAL_SITE_DOMAIN")+"/member/login";
			}
		}

      //[Step-20] : 필수 파라미터 검사
      		if ( qestnarNo <= 0 ) {
      			model.addAttribute("alertMsg","정보가 정확하지 않습니다. 잠시 후 다시 시도해 주세요.");
                model.addAttribute("goUrl","/minwon/survey");
                return "/common/msg";
      		}

      	//참여 여부 체크
    		Map<String,Object> duplParamMap = new HashMap<String, Object>();
    		duplParamMap.put("qestnarNo", qestnarNo);
    		duplParamMap.put("dplctCnfirmCode", dplctCnfirmCode);
    		result = qestnarService.retrieveApplyCount(duplParamMap);
    		if (result > 0) {
    			model.addAttribute("alertMsg","이미 참여하셨습니다.");
                model.addAttribute("goUrl","/minwon/survey");
                return "/common/msg";
    		}
        QestnarVO qestnarVO = null;
        List<FileVO> imgFileList = null;
        List<EgovMap> listQesitm = null;

        //설문조사 정보 조회
        if(qestnarNo > 0){
            qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);
            qestnarVO.setCrud(CRUDValues.UPDATE);
            qestnarVO.setCn(HumanHtmlUtil.enterToBr(qestnarVO.getCn()));

            //썸네일
            HashMap<String, Object> ImgparamMap = new HashMap<String, Object>();
            paramMap.put("upperNo", qestnarVO.getQestnarNo());
            paramMap.put("srvcId", progrmTy);
            paramMap.put("fileTy", "IMG");
            imgFileList = fileService.selectFileList(ImgparamMap);

            //질문,항목 리스트
            listQesitm = qestnarService.retrieveQestnAllList(qestnarNo);
        }

        if( qestnarVO==null ){
        	model.addAttribute("alertMsg","정보가 정확하지 않습니다. 다시 확인해주세요.");
            model.addAttribute("goUrl","/minwon/survey");
            return "/common/msg";
        }

        Map<String,Object> mapInput = new HashMap<String, Object>();
        mapInput.put("qestnarNo",qestnarNo);
           mapInput.put("nm",nm);
           mapInput.put("email",email);
           mapInput.put("telno",telno);
           mapInput.put("country",country);
           mapInput.put("nationality",nationality);
           mapInput.put("address",address);
           mapInput.put("crtrUniqueId",crtrUniqueId);
           mapInput.put("dplctCnfirmCode",dplctCnfirmCode);

        model.addAttribute("qestnarVO", qestnarVO);
        model.addAttribute("imgFileList", imgFileList);
        model.addAttribute("listQesitm", listQesitm);
        model.addAttribute("mapInput", mapInput);
        return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/qestnar/apply";
    }

    /**
     * 기능프로그램>설문조사 등록 처리
     * @param model
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/action")
    public View action(Model model, HttpServletRequest request, HttpSession session) throws Exception {

    	SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");

        String retMsg = getMsg("error.default");
        int result = 0;
        int i=0;

        int qestnarNo = EgovStringUtil.string2integer(request.getParameter("qestnarNo"),0);
        String sj = EgovStringUtil.null2string(request.getParameter("sj"), "");
        String retUrl = EgovStringUtil.null2string(request.getParameter("retUrl"),"/");
        String ip = InetAddress.getLocalHost().getHostAddress();

        JavaScript js = new JavaScript();
        js.setMessage(retMsg);
        js.setLocation(retUrl);

        //본인 인증 체크

        String nm = request.getParameter("nm");
        String email = request.getParameter("email");
        String telno = request.getParameter("telno");
        String country = request.getParameter("country");
        String nationality = request.getParameter("nationality");
        String address = request.getParameter("address");
        String crtrNm = nm;
        String crtrUniqueId = request.getParameter("crtrUniqueId");
        String dplctCnfirmCode = request.getParameter("dplctCnfirmCode");

        if( qestnarNo>0 ){	//설문정보 확인
            QestnarVO qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);

            if( qestnarVO!=null){		//설문이 진행중일때

                //참여 여부 체크
                Map<String,Object> paramMap = new HashMap<String, Object>();
                paramMap.put("qestnarNo", qestnarNo);
                paramMap.put("dplctCnfirmCode", dplctCnfirmCode);
                result = qestnarService.retrieveApplyCount(paramMap);

                if(result>0){
                    retMsg = getMsg("error.duplicate.qestnar");

                }else{	//설문 등록 처리

                    //insert할 데이터를 가져옴
                    Enumeration enuParameter = request.getParameterNames();

                    List<Map<String,Object>> listInput = new ArrayList<Map<String,Object>>();
                    List<Map<String,Object>> listEtc = new ArrayList<Map<String,Object>>();
                    while(enuParameter.hasMoreElements()){
                        String paramName = EgovStringUtil.null2void((String)enuParameter.nextElement());
                        String[] paramValue = request.getParameterValues(paramName);

                        //질문/문항만 정리
                        if( paramName.substring(0,2).equals("i_") || paramName.substring(0,2).equals("e_") || paramName.substring(0,2).equals("t_") ){

                            if (paramValue!=null && paramValue.length > 0) {
                                for (i = 0; i < paramValue.length; i++) {

                                    Map<String,Object> mapInput = new HashMap<String, Object>();
                                    mapInput.put(paramName, paramValue[i]);

                                    if( paramName.substring(0,2).equals("e_") ){
                                        listEtc.add(mapInput);
                                    }else{
                                        listInput.add(mapInput);
                                    }
                                }
                            }
                        }
                    }

                    //응답 등록
                    if( listInput!=null && listInput.size()>0 ){

                        List<Map<String,Object>> listResult = new ArrayList<Map<String,Object>>();

                        for(Map tMap : listInput){
                        	boolean isCheckBox = false;
                            String tName="", tValue="";
                            String tQestnNo="0", tQesitmNo="0", tEtcAnswer="";

                            Iterator it = tMap.entrySet().iterator();
                            while (it.hasNext()) {
                                Map.Entry et = (Map.Entry)it.next();

                                tName = (String) et.getKey();
                                tValue = (String) et.getValue();
                                if (tValue.indexOf(",") > - 1 && tName.indexOf("t_") == -1) { // 체크박스(주간식형일때 , 있을때 걸리므로 조건추가)
                                	String[] tValues = tValue.split(",");
                                	if (tValues != null) {
                                		for (int t=0; t<tValues.length; t++) {
                                			if (tValues[t] != null) {
                                				Map<String,Object> mapInput = new HashMap<String, Object>();
                	                            mapInput.put("qestnarNo",qestnarNo);
                	                            mapInput.put("qestnNo",tName.replaceAll("i\\_", ""));
                	                            mapInput.put("qesitmNo",tValues[t].trim());
                	                            mapInput.put("etcAnswer",tEtcAnswer);
                	                            mapInput.put("nm",nm);
                	                            mapInput.put("email",email);
                	                            mapInput.put("telno",telno);
                	                            mapInput.put("country",country);
                	                            mapInput.put("nationality",nationality);
                	                            mapInput.put("address",address);
                	                            mapInput.put("crtrUniqueId",crtrUniqueId);
                	                            mapInput.put("dplctCnfirmCode",dplctCnfirmCode);
                	                            mapInput.put("crtrNm",crtrNm);
                	                            mapInput.put("ip",ip);
                	                            listResult.add(mapInput);
                	                            isCheckBox = true;
                                			}
                                		}
                                	}
                                } else if( tName.substring(0,2).equals("i_") ){		//객관식
                                    tQestnNo = tName.replaceAll("i\\_", "");
                                    tQesitmNo = tValue;
                                    isCheckBox = false;
                                }else{		//주관식
                                    String[] tAr = tName.replaceAll("t\\_", "").split("\\|");
                                    tQestnNo = EgovStringUtil.null2string(tAr[0],"0");
                                    tQesitmNo = EgovStringUtil.null2string(tAr[1],"0");
                                    tEtcAnswer = tValue;
                                    isCheckBox = false;
                                }
                            }

                            if (!isCheckBox) {
                            	// 체크박스 일땐 윗단에서 Input 처리
	                            Map<String,Object> mapInput = new HashMap<String, Object>();
	                            mapInput.put("qestnarNo",qestnarNo);
	                            mapInput.put("qestnNo",tQestnNo);
	                            mapInput.put("qesitmNo",tQesitmNo);
	                            mapInput.put("etcAnswer",tEtcAnswer);
	                            mapInput.put("nm",nm);
	                            mapInput.put("email",email);
	                            mapInput.put("telno",telno);
	                            mapInput.put("country",country);
	                            mapInput.put("nationality",nationality);
	                            mapInput.put("address",address);
	                            mapInput.put("crtrUniqueId",crtrUniqueId);
	                            mapInput.put("dplctCnfirmCode",dplctCnfirmCode);
	                            mapInput.put("crtrNm",crtrNm);
	                            mapInput.put("ip",ip);
	                            listResult.add(mapInput);
                            }
                        }

                        //기타 문항 응답 결과 반영
                        if( (listEtc!=null && listEtc.size()>0) && (listResult!=null && listResult.size()>0 )){
                            for(Map tMap : listEtc){
                                String tName="", tValue="";
                                String tQestnNo="0", tQesitmNo="0", tEtcAnswer="";

                                Iterator it = tMap.entrySet().iterator();
                                while (it.hasNext()) {
                                    Map.Entry et = (Map.Entry)it.next();

                                    tName = (String) et.getKey();
                                    tValue = (String) et.getValue();

                                    String[] tAr = tName.replaceAll("e\\_", "").split("\\|");
                                    tQestnNo = EgovStringUtil.null2string(tAr[0],"0");
                                    tQesitmNo = EgovStringUtil.null2string(tAr[1],"0");
                                    tEtcAnswer = tValue;
                                }

                                if( !"0".equals(tQestnNo) && !"0".equals(tQesitmNo) && !"".equals(tEtcAnswer) ){
                                    for(Map rMap : listResult){
                                        if( tQestnNo.equals(rMap.get("qestnNo")) && tQesitmNo.equals(rMap.get("qesitmNo")) ){
                                            rMap.put("etcAnswer",tEtcAnswer);
                                        }
                                    }
                                }

                            }
                        }

                        //설문 결과 등록
                        if( listResult!=null && listResult.size()>0 ){
                            result = qestnarService.createQestnarResultList(listResult);

                            retMsg = getMsg("action.complete.save");

                            mberSession = (MberSession) session.getAttribute(getProperties("SESSION_MEMBER"));

                        }
                    }
                }
            }else{		//설문 종료시
                retMsg = getMsg("error.default");
            }
        }

        js.setMessage(retMsg);
        return new JavaScriptView(js);
    }

    @RequestMapping(value="chkEmailYn")
	public @ResponseBody Map<String, Object> chkMberAuthAjax(
				@RequestParam(required=true) String email
				, @RequestParam(required=true) String qestnarNo
				, @RequestParam(required=true) String qustnrTrget
				, @RequestParam Map<String,Object> reqMap
				, HttpServletRequest request
				, Model model
				, HttpSession session) throws Exception {


    	int result = qestnarService.retrieveEmailYn(reqMap);

		Map<String, Object> returnMap = new HashMap<String, Object>();
		if (result > 0) {
			returnMap.put("emailYn", "Y");
		}else{
			returnMap.put("emailYn", "N");
		}

		return returnMap;
	}

    /**
	 * 설문결과보기
	 * @param qestnarNo
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("result")
	public String reuslt(@RequestParam(required = false, defaultValue = "0") int qestnarNo,
				Model model, HttpServletRequest request, HttpSession session) throws Exception {

		SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");

		QestnarVO qestnarVO = null;
		List<EgovMap> listQesitm = null;

		if( qestnarNo>0 ){
			qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);		//설문조사 정보
			qestnarVO.setCrud(CRUDValues.UPDATE);

			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("qestnarNo", qestnarNo);
			paramMap.put("srchSttus", qestnarVO.getProgrsSttus());
			listQesitm = qestnarService.retrieveQestnAllList(paramMap);	//질문,항목 리스트
		}

		model.addAttribute("qestnarVO", qestnarVO);
		model.addAttribute("listQesitm", listQesitm);

		return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/qestnar/result";
	}

	/**
	 * 설문조사>주관식 결과 리스트
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("winEtcAnswer")
	public String winPrtcpntList(
			@RequestParam(required=true, defaultValue="0") int qestnarNo
			,@RequestParam(required=true, defaultValue="0") int qestnNo
			,HttpServletRequest request, Model model) throws Exception {

		SiteVO curSiteVO = (SiteVO)request.getAttribute("curSiteVO");

		HumanListVO listVO = new HumanListVO(request);
		listVO = qestnarService.retrieveQestnarResultListVO(listVO);

		QestnarQestnVO qestnVO = qestnarService.retrieveQestnByPk(qestnNo);

		model.addAttribute("listVO", listVO);
		model.addAttribute("qestnVO", qestnVO);
		return "/front/"+ curSiteVO.getSiteSkn() + "/fnct/qestnar/popup/qestnar_answer_list";
	}
}
