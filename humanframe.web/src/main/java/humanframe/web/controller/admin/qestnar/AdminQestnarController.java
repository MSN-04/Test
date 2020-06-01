package humanframe.web.controller.admin.qestnar;

import humanframe.backoffice.service.FileService;
import humanframe.backoffice.service.SiteService;
import humanframe.backoffice.session.MngrSession;
import humanframe.backoffice.vo.FileVO;
import humanframe.core.abst.HumanAbstractController;
import humanframe.core.util.HumanCommonUtil;
import humanframe.core.values.CRUDValues;
import humanframe.core.values.CodeMap;
import humanframe.core.view.JavaScript;
import humanframe.core.view.JavaScriptView;
import humanframe.core.vo.HumanListVO;
import humanframe.web.common.CommCodeMap;
import humanframe.web.service.QestnarService;
import humanframe.web.vo.QestnarQesitmVO;
import humanframe.web.vo.QestnarQestnVO;
import humanframe.web.vo.QestnarVO;

import java.io.Writer;
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

@Controller
@RequestMapping("/admin/fnct/qestnar")
public class AdminQestnarController extends HumanAbstractController {

	private static String progrmTy = "QESTNAR";

	@Resource(name="fileService")
	private FileService fileService;

	@Resource(name="qestnarService")
	private QestnarService qestnarService;

	@Resource(name="siteService")
	private SiteService siteService;

	@Autowired
	private MngrSession mngrSession;

	/**
	 * 기능프로그램>설문조사 리스트
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value={"index","list"})
	public String list(
			 HttpServletRequest request
			, Model model) throws Exception {

		HumanListVO listVO = new HumanListVO(request);
		listVO = qestnarService.qestnarListVO(listVO);

		model.addAttribute("listVO", listVO);
		return "/admin/fnct/qestnar/list";
	}

	/**
	 * 기능프로그램>설문조사 등록/수정 폼
	 * @param qestnarNo
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="form")
	public String form(@RequestParam(required = false, defaultValue = "0") int qestnarNo,
			Model model, HttpServletRequest request, HttpSession session) throws Exception {

		QestnarVO qestnarVO = null;
		List<FileVO> imgFileList = null;

		if(qestnarNo > 0){
			qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);
			qestnarVO.setCrud(CRUDValues.UPDATE);

			//썸네일
			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("upperNo", qestnarVO.getQestnarNo());
			paramMap.put("srvcId", progrmTy);
			paramMap.put("fileTy", "IMG");
			imgFileList = fileService.selectFileList(paramMap);
		}else{
			qestnarVO = new QestnarVO();
			qestnarVO.setCrud(CRUDValues.CREATE);

			qestnarVO.setUpdusrNm(mngrSession.getMngrNm());
			qestnarVO.setSiteNo(0);
			qestnarVO.setMenuNo(0);
			qestnarVO.setOthbcAt("Y");
		}

		// 사용중인 사이트 리스트
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("useAt", "Y");
		List<EgovMap> siteList = siteService.selectSiteListAll(paramMap);

		model.addAttribute("qestnarVO", qestnarVO);
		model.addAttribute("listImgFile", imgFileList);
		model.addAttribute("siteList", siteList);
		model.addAttribute("qustnrTrgetCode", CommCodeMap.RCRIT_TRGET);
		model.addAttribute("othbcAtList", CommCodeMap.OTHBC_AT);

		return "/admin/fnct/qestnar/form";
	}

	/**
	 * 기능프로그램>설문조사 등록/수정/삭제 처리
	 * @param qestnarVO
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/action")
	public View action(
			  QestnarVO qestnarVO
			, @RequestParam Map<String,Object> reqMap
			, MultipartHttpServletRequest request
			, HttpSession session) throws Exception {

		int qestnarNo = 0;

		JavaScript js = new JavaScript();

		//vo 체크
		if( qestnarVO==null ){
			js.setMessage(getMsg("error.default"));
			js.setLocation("list.do");
			return new JavaScriptView(js);
		}

		String bgnDttm = EgovStringUtil.null2void(qestnarVO.getBgnDttm());
		String endDttm = EgovStringUtil.null2void(qestnarVO.getEndDttm());
		bgnDttm = bgnDttm.replaceAll("-", "").replaceAll(":", "").replaceAll(" ","");
		endDttm = endDttm.replaceAll("-", "").replaceAll(":", "").replaceAll(" ","");

		qestnarVO.setBgnDttm(bgnDttm);
		qestnarVO.setEndDttm(endDttm);

		// 관리자 세팅
		qestnarVO.setCrtrUniqueId(mngrSession.getUniqueId());
		qestnarVO.setCrtrId(mngrSession.getMngrId());
		qestnarVO.setCrtrNm(mngrSession.getMngrNm());
		qestnarVO.setUpdusrUniqueId(mngrSession.getUniqueId());
		qestnarVO.setUpdusrId(mngrSession.getMngrId());
		qestnarVO.setUpdusrNm(mngrSession.getMngrNm());

		Map<String, MultipartFile> fileMap = request.getFileMap();
		switch(qestnarVO.getCrud()) {
		case CREATE :

			qestnarService.createQestnar(qestnarVO);
			qestnarNo = qestnarVO.getQestnarNo();

			//이미지 처리
			if(qestnarVO.getImgFile() != null){

				fileService.creatFileInfo(fileMap, qestnarNo, progrmTy, reqMap);
			}

			js.setMessage(getMsg("action.complete.insert"));

			break;
		case UPDATE :

			qestnarService.modifyQestnar(qestnarVO);
			qestnarNo = qestnarVO.getQestnarNo();

			//이미지 처리
			if(qestnarVO.getImgFile() != null){

				//기존 파일 삭제
				String delAttachFileNo = HumanCommonUtil.getSqlStr((String) reqMap.get("delAttachFileNo"));
				String[] arrDelAttachFile = delAttachFileNo.split(",");
				if(!EgovStringUtil.isEmpty(arrDelAttachFile[0]))
					fileService.deleteFilebyNo(arrDelAttachFile, qestnarNo, progrmTy, "IMG");

				//신규 파일 등록
				fileService.creatFileInfo(fileMap, qestnarNo, progrmTy, reqMap);
			}

			js.setMessage(getMsg("action.complete.update"));

			break;

		case DELETE :
			qestnarNo = qestnarVO.getQestnarNo();
			qestnarService.modifyQestnarNotUseByPk(qestnarNo, "N");

			fileService.deleteFileByUpperNo(qestnarNo, progrmTy);

			js.setMessage(getMsg("action.complete.delete"));
			break;

		default:
			break;
		}

		js.setLocation("./list");
		return new JavaScriptView(js);
	}

	@RequestMapping("useAtChg")
	public void useAtChg(
			@RequestParam(value="qestnarNo", required=true) int qestnarNo
			, @RequestParam(value="useAt", required=true) String useAt
			, Writer out) throws Exception {
		String rtnVal = "false";

		int resultCnt = qestnarService.modifyQestnarNotUseByPk(qestnarNo, useAt);
		if(resultCnt == 1){//update success 1 : fail 0
			rtnVal = "true";
		}
		out.write(rtnVal);
	}

	/**
	 * 기능프로그램>설문조사 질문 리스트
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="qestnList")
	public String qestnList(
			@RequestParam(required=true, defaultValue="0") int qestnarNo
			, HttpServletRequest request, Model model) throws Exception {

		QestnarVO qestnarVO = null;
		List<QestnarQestnVO> listQestn = null;
		QestnarQestnVO qestnVO = new QestnarQestnVO();
		qestnVO.setCrud(CRUDValues.CREATE);
		qestnVO.setQestnarNo(qestnarNo);

		if( qestnarNo>0 ){
			qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);		//설문조사 정보

			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("qestnarNo", qestnarNo);

			//질문 리스트
			listQestn = qestnarService.retrieveQestnList(paramMap);
		}

		model.addAttribute("qestnVO", qestnVO);
		model.addAttribute("listQestn", listQestn);
		model.addAttribute("qestnarVO", qestnarVO);
		return "/admin/fnct/qestnar/qestn_list";
	}

	/**
	 * 기능프로그램>설문조사 질문 등록/수정 폼
	 * @param qestnarNo
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("qestnForm")
	public String qestnForm(
			@RequestParam(required = false, defaultValue = "0") int qestnarNo
			, @RequestParam(required = false, defaultValue = "0") int qestnNo
			, @RequestParam(required = false) String progrsSttus
			, Model model, HttpServletRequest request, HttpSession session) throws Exception {

		QestnarQestnVO qestnVO = null;
		List<?> listQesitm = null;
		List<FileVO> imgFileListAll = new ArrayList<FileVO>();

		if(qestnarNo>0 && qestnNo>0){
			qestnVO = qestnarService.retrieveQestnByPk(qestnNo);
			qestnVO.setCrud(CRUDValues.UPDATE);

			//항목 리스트
			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("qestnarNo",qestnarNo);
			paramMap.put("qestnNo",qestnNo);
			listQesitm = qestnarService.retrieveQesitmList(paramMap);

			//썸네일
			for(int i=0; i<listQesitm.size(); i++){
				EgovMap record = (EgovMap) listQesitm.get(i);
				int t_qesitmNo = Integer.parseInt(String.valueOf(record.get("qesitmNo")));
				paramMap.put("upperNo", t_qesitmNo);
				paramMap.put("srvcId", "QESTNARTM");
				paramMap.put("fileTy", "IMG");
				List<FileVO>imgFileList = fileService.selectFileList(paramMap);
				if(imgFileList.size() > 0 ){
					imgFileListAll.addAll(imgFileList);
				}
			}

		}else{
			qestnVO = new QestnarQestnVO();
			qestnVO.setCrud(CRUDValues.CREATE);

			qestnVO.setQestnarNo(qestnarNo);
			qestnVO.setQestnTy("R");
			qestnVO.setEtcOpinionAt("Y");
			qestnVO.setQestnTi("A");
		}

		model.addAttribute("qestnarQestnVO", qestnVO);
		model.addAttribute("listQesitm", listQesitm);
		model.addAttribute("mapUseAt", CodeMap.USE_AT);
		model.addAttribute("mapQestTy", CommCodeMap.QESTN_TY);
		model.addAttribute("mapQestTi", CommCodeMap.QESTN_TI);
		model.addAttribute("mapEssentialTy", CommCodeMap.ESSENTIAL_TY);
		model.addAttribute("mapNextQestnTy", CommCodeMap.NEXTQESTN_TY);
		model.addAttribute("imgFileListAll", imgFileListAll);
		model.addAttribute("progrsSttus", progrsSttus);

		return "/admin/fnct/qestnar/popup/qestn_form";
	}

	/**
	 * 기능프로그램>설문조사 질문 등록/수정 처리
	 * @param qestnarQestnVO
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("qestnAction")
	public View qestnAction(
			QestnarQestnVO qestnarQestnVO
			, @RequestParam Map<String,Object> reqMap
			, @RequestParam(required=false) String[] qesitmNo
			, @RequestParam(required=false) String[] qesitmText
			, @RequestParam(required=false) String[] nextQestnAt
			, @RequestParam(required=false) String[] nextQestnNo
			, MultipartHttpServletRequest request
			, HttpSession session) throws Exception{

		JavaScript js = new JavaScript();

		int qestnarNo = 0;
		int qestnNo = 0;
		String qestnTy = "";
		int cntQesitm = 0;
		int imgCnt = 0;

		//vo 체크
		if( qestnarQestnVO==null ){
			js.setMessage(getMsg("error.default"));
			js.setMethod("window.close()");
			return new JavaScriptView(js);
		}

		qestnarNo = qestnarQestnVO.getQestnarNo();

		QestnarVO qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);

		if( qestnarNo <= 0 ) { //설문조사 번호 체크
			js.setMessage(getMsg("error.default"));
			js.setMethod("window.close()");
			return new JavaScriptView(js);
		}

		List<QestnarQesitmVO> listQesitm = new ArrayList<QestnarQesitmVO>();
		if( qesitmText!=null && qesitmText.length>0 ){

			for(int i=0;i<qesitmText.length;i++){
				int t_qesitmNo = EgovStringUtil.string2integer(qesitmNo[i],0);
				String t_qesitmText = EgovStringUtil.null2void(qesitmText[i]);
				String t_nextQestnAt = EgovStringUtil.null2void(nextQestnAt[i]);
				String t_nextQestnNo = "";
				if(nextQestnNo.length > 0){
					t_nextQestnNo = EgovStringUtil.null2void(nextQestnNo[i]);
				}
				if(!"Y".equals(t_nextQestnAt)){
					t_nextQestnNo = "";
				}
				QestnarQesitmVO tVO = new QestnarQesitmVO( qestnarNo, qestnarQestnVO.getQestnNo(), t_qesitmNo, t_qesitmText, qestnarQestnVO.getQestnTy(), (i+1), t_nextQestnAt, t_nextQestnNo );

				if("UPDATE".equals(String.valueOf(qestnarQestnVO.getCrud())) && "B".equals(qestnarQestnVO.getQestnTi())){
					if(t_qesitmNo == 0) listQesitm.add(tVO);
					else qestnarService.updateQesitmByQesitmOrdr(t_qesitmNo, qestnarNo, qestnarQestnVO.getQestnNo(), (i+1), t_nextQestnAt, t_nextQestnNo);
				}else{
					listQesitm.add(tVO);
				}

			}
		}

		switch(qestnarQestnVO.getCrud()) {
		case CREATE :
			//질문 등록
			qestnarService.createQestn(qestnarQestnVO);
			qestnNo = qestnarQestnVO.getQestnNo();
			qestnTy = qestnarQestnVO.getQestnTy();

			//항목 등록
			if( qestnNo > 0 && listQesitm != null ){
				for(QestnarQesitmVO tVO : listQesitm){
					tVO.setQestnNo(qestnNo);
					tVO.setQesitmTy(qestnTy);
					cntQesitm++;
				}
				if( "T".equals(qestnTy) || "Y".equals(qestnarQestnVO.getEtcOpinionAt()) ){
					QestnarQesitmVO tVO = new QestnarQesitmVO();
					tVO.setQestnarNo(qestnarNo);
					tVO.setQestnNo(qestnNo);
					tVO.setQesitmTy("T");
					tVO.setQesitmOrdr(cntQesitm+1);

					//이미지등록 갯수
					imgCnt = -1;
					if( "T".equals(qestnTy) ){
						tVO.setQesitmText("주관식");
					}else{
						// 언어별 (57 영문, 58 일문, 59 중문간체, 60 중문번체)
						if (qestnarVO.getSiteNo() == 57) {
							tVO.setQesitmText("Others (Please specify)");
						} else if (qestnarVO.getSiteNo() == 58) {
							tVO.setQesitmText("その他");
						} else if (qestnarVO.getSiteNo() == 59) {
							tVO.setQesitmText("其它");
						} else if (qestnarVO.getSiteNo() == 60) {
							tVO.setQesitmText("其它");
						} else {
							tVO.setQesitmText("기타의견");
						}

					}
					listQesitm.add(tVO);
				}

				if (listQesitm.size() > 0) {
					qestnarService.createQesitmList(listQesitm);

					//항목별 이미지 등록
					HashMap<String,Object> pararmMap = new HashMap<String, Object>();
					pararmMap.put("qestnarNo",qestnarNo);
					pararmMap.put("qestnNo",qestnNo);
					List<?> schQesitmList = qestnarService.retrieveQesitmList(pararmMap);

					for(int i=0; i<schQesitmList.size()+imgCnt; i++){
						List<MultipartFile> fileList = request.getFiles("imgFile" + (i+1));
						if (fileList.size() > 0) {
							EgovMap record = (EgovMap) schQesitmList.get(i);
							int t_qesitmNo = Integer.parseInt(String.valueOf(record.get("qesitmNo")));
							String t_qesitmText = String.valueOf(record.get("qesitmText"));

							if (fileList.get(0).getSize() > 0) {
								Map<String, MultipartFile> fileMap = new HashMap<String, MultipartFile>();
								fileMap.put("imgFile", fileList.get(0));

								Map<String, Object> fileDcMap = new HashMap<String, Object>();
								fileDcMap.put("imgFileDc" + (i+1), t_qesitmText);
								fileService.creatFileInfo(fileMap, t_qesitmNo, "QESTNARTM", fileDcMap);
							}
						}
					}
				}
			}

			js.setMessage(getMsg("action.complete.insert"));
			js.setMethods(new String[]{"window.opener.location.reload()","window.close()"});
			break;

		case UPDATE :
			//질문 등록
			qestnarService.modifyQestn(qestnarQestnVO);
			qestnNo = qestnarQestnVO.getQestnNo();
			qestnTy = qestnarQestnVO.getQestnTy();

			if("B".equals(qestnarQestnVO.getQestnTi()) && !"T".equals(qestnTy)){
				//삭제할 이미지
				String[] del_qesitmNo = request.getParameterValues("del_qesitmNo");
				if(del_qesitmNo != null){
					int[] del_qesitmNoInt = null;
					if(del_qesitmNo.length > 0){
						del_qesitmNoInt = new int[del_qesitmNo.length];
						for(int i=0; i<del_qesitmNo.length; i++){
							del_qesitmNoInt[i] = Integer.parseInt(del_qesitmNo[i]);
							fileService.deleteFileByUpperNo(del_qesitmNoInt[i] , "QESTNARTM");
						}
					}
				}
				//삭제할 이미지에 대한 항목
				int[] qesitmNoInt = null;
				if(qesitmNo != null && qesitmNo.length > 0){
					qesitmNoInt = new int[qesitmNo.length];
					for(int i=0; i<qesitmNo.length; i++){
						qesitmNoInt[i] = Integer.parseInt(qesitmNo[i]);
					}
				}
				if(null != qesitmNoInt && qesitmNoInt.length > 0)
					qestnarService.removeQesitmByQesitmNotin(qesitmNoInt, qestnarNo, qestnNo);

			}else{
				if("T".equals(qestnTy)){
					//삭제할 이미지
					int[] qesitmNoInt = null;
					if(qesitmNo != null && qesitmNo.length > 0){
						qesitmNoInt = new int[qesitmNo.length];
						for(int i=0; i<qesitmNo.length; i++){
							qesitmNoInt[i] = Integer.parseInt(qesitmNo[i]);
							fileService.deleteFileByUpperNo(qesitmNoInt[i] , "QESTNARTM");
						}
					}
				}
				//기존 항목 삭제 후 등록
				qestnarService.removeQesitmByQestnNo(qestnNo);
			}

			//항목 등록
			if( qestnNo>0 && listQesitm!=null ){

				HashMap<String,Object> pararmMap = new HashMap<String, Object>();
				List<?> schQesitmList = null;

				if("B".equals(qestnarQestnVO.getQestnTi())){
					pararmMap.put("qestnarNo",qestnarNo);
					pararmMap.put("qestnNo",qestnNo);
					schQesitmList = qestnarService.retrieveQesitmList(pararmMap);
					if(schQesitmList == null){
						cntQesitm = 1;
					}else{
						cntQesitm = schQesitmList.size()+listQesitm.size();
					}

				}else{
					for(QestnarQesitmVO tVO : listQesitm){
						tVO.setQestnNo(qestnNo);
						tVO.setQesitmTy(qestnTy);
						cntQesitm++;
					}
				}

				if( "T".equals(qestnTy) || "Y".equals(qestnarQestnVO.getEtcOpinionAt()) ){
					QestnarQesitmVO tVO = new QestnarQesitmVO();
					tVO.setQestnarNo(qestnarNo);
					tVO.setQestnNo(qestnNo);
					tVO.setQesitmTy("T");
					tVO.setQesitmOrdr(cntQesitm+1);
					//이미지등록 갯수
					imgCnt = -1;
					if( "T".equals(qestnTy) ){
						listQesitm.clear();
						tVO.setQestnarNo(qestnarNo);
						tVO.setQestnNo(qestnNo);
						tVO.setQesitmTy("T");
						tVO.setQesitmOrdr(1);
						tVO.setQesitmText("주관식");
					}else{
						// 언어별 (57 영문, 58 일문, 59 중문간체, 60 중문번체)
						if (qestnarVO.getSiteNo() == 57) {
							tVO.setQesitmText("Others (Please specify)");
						} else if (qestnarVO.getSiteNo() == 58) {
							tVO.setQesitmText("その他");
						} else if (qestnarVO.getSiteNo() == 59) {
							tVO.setQesitmText("其它");
						} else if (qestnarVO.getSiteNo() == 60) {
							tVO.setQesitmText("其它");
						} else {
							tVO.setQesitmText("기타의견");
						}
					}
					listQesitm.add(tVO);
				}

				if (listQesitm.size() > 0) {
					qestnarService.createQesitmList(listQesitm);

					//항목별 이미지 등록
					pararmMap.put("qestnarNo",qestnarNo);
					pararmMap.put("qestnNo",qestnNo);
					schQesitmList = qestnarService.retrieveQesitmList(pararmMap);

					for(int i=0; i<schQesitmList.size()+imgCnt; i++){
						List<MultipartFile> fileList = request.getFiles("imgFile" + (i+1));
						if (fileList.size() > 0) {
							EgovMap record = (EgovMap) schQesitmList.get(i);
							int t_qesitmNo = Integer.parseInt(String.valueOf(record.get("qesitmNo")));
							String t_qesitmText = String.valueOf(record.get("qesitmText"));

							if (fileList.get(0).getSize() > 0) {
								Map<String, MultipartFile> fileMap = new HashMap<String, MultipartFile>();
								fileMap.put("imgFile", fileList.get(0));

								Map<String, Object> fileDcMap = new HashMap<String, Object>();
								fileDcMap.put("imgFileDc" + (i+1), t_qesitmText);
								fileService.creatFileInfo(fileMap, t_qesitmNo, "QESTNARTM", fileDcMap);
							}
						}
					}
				}
			}

			js.setMessage(getMsg("action.complete.update"));
			js.setMethods(new String[]{"window.opener.location.reload()","window.close()"});
			break;

		case DELETE:
			qestnNo = qestnarQestnVO.getQestnNo();

			//항목별 이미지 삭제
			HashMap<String,Object> pararmMap = new HashMap<String, Object>();
			pararmMap.put("qestnarNo",qestnarNo);
			pararmMap.put("qestnNo",qestnNo);
			List<?> schQesitmList = qestnarService.retrieveQesitmList(pararmMap);
			for(int i=0; i<schQesitmList.size()+imgCnt; i++){
				EgovMap record = (EgovMap) schQesitmList.get(i);
				int t_qesitmNo = Integer.parseInt(String.valueOf(record.get("qesitmNo")));

				fileService.deleteFileByUpperNo(t_qesitmNo , "QESTNARTM");
			}

			// 항목,질문삭제
			qestnarService.removeQestn(qestnarNo, qestnNo);

			js.setMessage(getMsg("action.complete.delete"));
			js.setLocation("./qestnList?qestnarNo="+qestnarNo);
			break;

		default:
			break;
		}

		return new JavaScriptView(js);
	}

	/**
	 * 기능프로그램>설문조사 질문/항목 조회
	 * @param qestnarNo
	 * @param qestnNo
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getQestn.json")
	public @ResponseBody Map<String, Object> getQestn(
			@RequestParam(required = true, defaultValue = "0") int qestnarNo
			,@RequestParam(required = true, defaultValue = "0") int qestnNo
			,HttpServletRequest request, HttpSession session) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();

		if( qestnarNo>0 && qestnNo>0 ){
			QestnarQestnVO qestnVO = qestnarService.retrieveQestnByPk(qestnNo);

			HashMap<String,Object> pararmMap = new HashMap<String, Object>();
			pararmMap.put("qestnarNo",qestnarNo);
			pararmMap.put("qestnNo",qestnNo);
			List<QestnarQesitmVO> listQesitm = qestnarService.retrieveQesitmList(pararmMap);

			map.put("qestnVO", qestnVO);
			map.put("listQesitm", listQesitm);
		}

		return map;

	}

	/**
	 * 기능프로그램>설문조사 질문/항목 삭제
	 * @param qestnarNo
	 * @param qestnNo
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delQestn.json")
	public @ResponseBody int delQestn(
			@RequestParam(required = true, defaultValue = "0") int qestnarNo
			,@RequestParam(required = true, defaultValue = "0") int qestnNo
			,HttpServletRequest request, HttpSession session) throws Exception {

		int result = 0;

		if( qestnNo>0 ){
			result = qestnarService.removeQestn(qestnarNo, qestnNo);
		}

		return result;
	}

	@RequestMapping("qestnSortForm")
	public String qestnSortForm(
			@RequestParam(required = false, defaultValue = "0") int qestnarNo
			, Model model, HttpServletRequest request, HttpSession session) throws Exception {

		List<QestnarQestnVO> listQestn = null;

		if(qestnarNo>0){

			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("qestnarNo",qestnarNo);

			//질문 리스트
			listQestn = qestnarService.retrieveQestnList(paramMap);

		}

		model.addAttribute("listQestn", listQestn);

		return "/admin/fnct/qestnar/popup/qestn_sort_form";
	}

	/**
	 * 기능프로그램>설문조사 질문 순서 수정
	 * @param qestnNo
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("qestnSortAction")
	public View qestnSortAction(
			@RequestParam(required=true) String[] qestnNo
			,HttpServletRequest request ) throws Exception {

		JavaScript js = new JavaScript();

		if( qestnNo!=null && qestnNo.length>0 ){
//			qestnarService.modifyQestnSort(qestnNo);
			for(int i=0; i<qestnNo.length; i++){
				qestnarService.modifyQestnSortSingle(qestnNo[i], i);
			}
			js.setMessage(getMsg("action.complete.update"));
		}

		js.setMethods(new String[]{"window.opener.location.reload()","window.close()"});
		return new JavaScriptView(js);
	}

	/**
	 * 기능프로그램>설문조사>결과 리스트
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

		return "/admin/fnct/qestnar/result";
	}

	/**
	 * 기능프로그램>설문조사>결과 리스트 엑셀
	 * @param qestnarNo
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("resultExcel")
	public String resultExcel(@RequestParam(required = false, defaultValue = "0") int qestnarNo,
				Model model,
				HttpServletRequest request,
				HttpSession session) throws Exception {

		QestnarVO qestnarVO = null;
		List<EgovMap> listQesitm = null;

		if( qestnarNo>0 ){
			qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);		//설문조사 정보

			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("qestnarNo", qestnarNo);
			paramMap.put("srchSttus", qestnarVO.getProgrsSttus());
			listQesitm = qestnarService.retrieveQestnAllList(paramMap);	//질문,항목 리스트
		}

		model.addAttribute("qestnarVO", qestnarVO);
		model.addAttribute("listQesitm", listQesitm);

		return "/admin/fnct/qestnar/excel";
	}

	/**
	 * 기능프로그램>설문조사>개인별 리스트 엑셀
	 * @param qestnarNo
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("personalExcel")
	public String personalExcel(@RequestParam(required = false, defaultValue = "0") int qestnarNo,
			Model model,
			HttpServletRequest request,
			HttpSession session) throws Exception {


		HumanListVO listVO = new HumanListVO(request);
		QestnarVO qestnarVO = null;
		if( qestnarNo>0){

			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("qestnarNo", qestnarNo);

			listVO = qestnarService.retrievePersonalResultAllList(listVO);
			qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);

			qestnarVO.setCrud(CRUDValues.UPDATE);
		}

		model.addAttribute("qestnarVO", qestnarVO);
		model.addAttribute("listVO", listVO);

		return "/admin/fnct/qestnar/personalExcel";
	}

	/**
	 * 기능프로그램>설문조사>주관식 결과 리스트
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

		HumanListVO listVO = new HumanListVO(request);
		listVO = qestnarService.retrieveQestnarResultListVO(listVO);

		QestnarQestnVO qestnVO = qestnarService.retrieveQestnByPk(qestnNo);

		model.addAttribute("listVO", listVO);
		model.addAttribute("qestnVO", qestnVO);
		return "/admin/fnct/qestnar/popup/win_etc_answer_list";
	}


	/**
	 * 기능프로그램>설문조사>개인별 리스트
	 * @param qestnarNo
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("personal")
	public String personal(@RequestParam(required = false, defaultValue = "0") int qestnarNo,
				Model model, HttpServletRequest request, HttpSession session) throws Exception {

		HumanListVO listVO = new HumanListVO(request);
		QestnarVO qestnarVO = null;
		if( qestnarNo>0){
			listVO = qestnarService.retrievePersonalResultList(listVO);
			qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);
			qestnarVO.setCrud(CRUDValues.UPDATE);
		}

		model.addAttribute("qestnarVO", qestnarVO);
		model.addAttribute("listVO", listVO);

		return "/admin/fnct/qestnar/personal";
	}




	/**
	 * 기능프로그램>설문조사>개인별 리스트>개인정보 삭제
	 * @param qestnarNo
	 * @param out
	 * @throws Exception
	 */
	@RequestMapping("delprivacy")
	public void useAtChg(
			@RequestParam(value="qestnarNo", required=true, defaultValue = "0") int qestnarNo
			, Writer out) throws Exception {
		String rtnVal = "false";


		Integer resultCnt = qestnarService.delprivacy(qestnarNo);

		if(resultCnt > 0){//update success 1 : fail 0
			rtnVal = "true";
		}
		out.write(rtnVal);
	}

	/**
	 * 기능프로그램>설문조사>개인별 리스트>개인별 설문 답변 상세
	 * @param qestnarNo
	 * @param dplctCnfirmCode
	 * @param model
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("personalView")
	public String personalView(@RequestParam(required = false, defaultValue = "0") int qestnarNo,
				@RequestParam(required = true) String crtrUniqueId,
				Model model, HttpServletRequest request, HttpSession session) throws Exception {

		QestnarVO qestnarVO = null;
		List<EgovMap> listQesitm = null;

		if( qestnarNo>0 ){
			qestnarVO = qestnarService.retrieveQestnarByPk(qestnarNo);		//설문조사 정보
			qestnarVO.setCrud(CRUDValues.UPDATE);

			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("qestnarNo", qestnarNo);
			paramMap.put("srchSttus", qestnarVO.getProgrsSttus());
			paramMap.put("crtrUniqueId", crtrUniqueId);
			listQesitm = qestnarService.retrievePersonalQestnList(paramMap);	//개인 질문,항목 리스트
		}

		model.addAttribute("qestnarVO", qestnarVO);
		model.addAttribute("listQesitm", listQesitm);

		return "/admin/fnct/qestnar/personalView";
	}



}