package humanframe.web.service;

import humanframe.core.vo.HumanListVO;
import humanframe.web.dao.QestnarDAO;
import humanframe.web.vo.QestnarQesitmVO;
import humanframe.web.vo.QestnarQestnVO;
import humanframe.web.vo.QestnarVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@SuppressWarnings({ "rawtypes" , "unchecked"})
@Service("qestnarService")
public class QestnarService  extends EgovAbstractServiceImpl {

	@Resource(name="qestnarDAO")
	private QestnarDAO qestnarDAO;

	@Resource(name = "propertiesService")
	private EgovPropertyService properties;

	public HumanListVO qestnarListVO(HumanListVO listVO) throws Exception {
		return qestnarDAO.selectQestnarListVO(listVO);
	}

	public QestnarVO retrieveQestnarByPk(int qestnarNo) throws Exception {
		return qestnarDAO.selectQestnarByPk(qestnarNo);
	}

	public int createQestnar(QestnarVO qestnarVO) throws Exception {
		return qestnarDAO.insertQestnar(qestnarVO);
	}

	public void modifyQestnar(QestnarVO qestnarVO) throws Exception {
		qestnarDAO.updateQestnar(qestnarVO);
	}

	public int modifyQestnarNotUseByPk(int qestnarNo, String useAt) throws Exception {
		return qestnarDAO.updateQestnarNotUseByPk(qestnarNo, useAt);
	}

	public List<QestnarQestnVO> retrieveQestnList(HashMap<String,Object> paramMap) throws Exception {
		return qestnarDAO.selectQestnList(paramMap);
	}

	public QestnarQestnVO retrieveQestnByPk(int qestnNo) throws Exception {
		return qestnarDAO.selectQestnarQestnByPk(qestnNo);
	}

	public int createQestn(QestnarQestnVO qestnarQestnVO) throws Exception {
		return qestnarDAO.insertQestn(qestnarQestnVO);
	}

	public void modifyQestn(QestnarQestnVO qestnarQestnVO) throws Exception {
		qestnarDAO.updateQestn(qestnarQestnVO);
	}

	public int removeQestn(int qestnarNo, int qestnNo) throws Exception {
		int result = 0;
		if( qestnNo>0 ){
			qestnarDAO.deleteQesitmByQestnNo(qestnNo);
			result = qestnarDAO.deleteQestn(qestnarNo, qestnNo);
		}
		return result;
	}

	public List<QestnarQesitmVO> retrieveQesitmList(HashMap<String,Object> paramMap) throws Exception {
		return qestnarDAO.selectQesitmList(paramMap);
	}

	public int createQesitmList(List<QestnarQesitmVO> listQesitm) throws Exception {
		return qestnarDAO.insertQesitmList(listQesitm);
	}

	public void removeQesitmByQestnNo(int qestnNo) throws Exception {
		qestnarDAO.deleteQesitmByQestnNo(qestnNo);
	}

	public void removeQesitmByQesitmNotin(int[] qesitmNo, int qestnarNo, int qestnNo) throws Exception{
		qestnarDAO.deleteQesitmByQesitmNotin(qesitmNo, qestnarNo, qestnNo);
	}

	public void updateQesitmByQesitmOrdr(int qesitmNo, int qestnarNo, int qestnNo, int qesitmOrdr, String nextQestnAt, String nextQestnNo) throws Exception {
		qestnarDAO.updateQesitmByQesitmOrdr(qesitmNo, qestnarNo, qestnNo, qesitmOrdr, nextQestnAt, nextQestnNo);
	}

	public List<EgovMap> retrieveQestnAllList(int qestnarNo) throws Exception {
		HashMap<String,Object> paramMap = new HashMap<String, Object>();
		paramMap.put("qestnarNo",qestnarNo);
		return qestnarDAO.selectQestnAllList(paramMap);
	}

	public List<EgovMap> retrieveQestnAllList(HashMap<String,Object> paramMap) throws Exception {
		return qestnarDAO.selectQestnAllList(paramMap);
	}

	public int retrieveApplyCount(Map<String,Object> paramMap) throws Exception {
		return qestnarDAO.selectApplyCount(paramMap);
	}

	public int createQestnarResult(Map<String,Object> paramMap) throws Exception {
		return qestnarDAO.insertQestnarResult(paramMap);
	}

	//암호화
	public int createQestnarResultList(List listQestnarResult) throws Exception {
		if(("Y").equals(properties.getString("DATA_ENCRYPTION_YN"))){
			for(int i=0; i<listQestnarResult.size(); i++){
				Map temp = (HashMap)listQestnarResult.get(i);
				/*if (temp.get("address") != null) temp.put("address", SecurityUtil.encryptString((String)temp.get("address")));
				if (temp.get("email") != null) temp.put("email", SecurityUtil.encryptString((String)temp.get("email")));
				if (temp.get("telno") != null) temp.put("telno", SecurityUtil.encryptString((String)temp.get("telno")));*/

				listQestnarResult.set(i, temp);
			}
		}
		return qestnarDAO.insertQestnarResultList(listQestnarResult);
	}

	public List<EgovMap> retrieveQestnarPrevNext(Map<String,Object> paramMap) throws Exception {
		return qestnarDAO.selectQestnarPrevNext(paramMap);
	}

	public int modifyQestnSort(String[] qestnNo) throws Exception {
		return qestnarDAO.updateQestnSort(qestnNo);
	}

	public int modifyQestnSortSingle(String qestnNo, int index) throws Exception {
		return qestnarDAO.updateQestnSortSingle(qestnNo, index);
	}

	public HumanListVO retrieveQestnarResultListVO(HumanListVO listVO) throws Exception {
		return qestnarDAO.selectQestnarResultListVO(listVO);
	}

	//암호화
	public HumanListVO retrievePersonalResultList(HumanListVO listVO) throws Exception {
		HumanListVO humanListVO = qestnarDAO.selectPersonalResultList(listVO);

		if(("Y").equals(properties.getString("DATA_ENCRYPTION_YN"))){
			List listObject = new ArrayList();
			for(Object o : humanListVO.getListObject()){
				EgovMap temp = (EgovMap)o;
				/*temp.put("address",SecurityUtil.decryptString((String)temp.get("address")));
				temp.put("email",SecurityUtil.decryptString((String)temp.get("email")));
				temp.put("telno",SecurityUtil.decryptString((String)temp.get("telno")));*/
				listObject.add(temp);
			}
			humanListVO.setListObject(listObject);
		}
		return humanListVO;
	}

	//암호화
	public HumanListVO retrievePersonalResultAllList(HumanListVO listVO) throws Exception {
		HumanListVO humanListVO = qestnarDAO.selectPersonalResultAllList(listVO);

		if(("Y").equals(properties.getString("DATA_ENCRYPTION_YN"))){
			List listObject = new ArrayList();
			for(Object o : humanListVO.getListObject()){
				EgovMap temp = (EgovMap)o;
				/*temp.put("address",SecurityUtil.decryptString((String)temp.get("address")));
				temp.put("email",SecurityUtil.decryptString((String)temp.get("email")));
				temp.put("telno",SecurityUtil.decryptString((String)temp.get("telno")));*/
				listObject.add(temp);
			}
			humanListVO.setListObject(listObject);
		}
		return humanListVO;
	}

	public Integer delprivacy(int qestnarNo) throws Exception {
		return qestnarDAO.deletePrivacy(qestnarNo);
	}

	//암호화
	public List<EgovMap> retrievePersonalQestnList(HashMap<String, Object> paramMap) throws Exception {
		List<EgovMap> personalQestnList = qestnarDAO.selectPersonalQestnList(paramMap);

		if(("Y").equals(properties.getString("DATA_ENCRYPTION_YN"))){
			List listObject = new ArrayList();
			for(Object o : personalQestnList){
				EgovMap temp = (EgovMap)o;
				/*temp.put("address",SecurityUtil.decryptString((String)temp.get("address")));
				temp.put("email",SecurityUtil.decryptString((String)temp.get("email")));
				temp.put("telno",SecurityUtil.decryptString((String)temp.get("telno")));*/
//				temp.put("countryKo",SecurityUtil.decryptString((String)temp.get("countryKo")));
//				temp.put("country",SecurityUtil.decryptString((String)temp.get("country")));
//				temp.put("nationality",SecurityUtil.decryptString((String)temp.get("nationality")));
//				temp.put("nationalityKo",SecurityUtil.decryptString((String)temp.get("nationalityKo")));
//				temp.put("creatDttm",SecurityUtil.decryptString((String)temp.get("creatDttm")));
				listObject.add(temp);
			}
			personalQestnList = listObject;
		}
		return personalQestnList;
	}

	public String retrieveMaxUniqueId(Map paramMap) throws Exception {
		return qestnarDAO.selectMaxUniqueId(paramMap);
	}

	//암호화
	public int retrieveEmailYn(Map<String,Object> reqMap) throws Exception {
		if(("Y").equals(properties.getString("DATA_ENCRYPTION_YN"))){
			//reqMap.put("email", SecurityUtil.encryptString((String)reqMap.get("email")));
		}
		return qestnarDAO.selectEmailYn(reqMap);
	}

	public List<EgovMap> selectCountryList(Map paramMap) throws Exception {
		return qestnarDAO.selectCountryList(paramMap);
	}
}
