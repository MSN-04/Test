package humanframe.web.dao;

import humanframe.core.abst.HumanAbstractMapper;
import humanframe.core.vo.HumanListVO;
import humanframe.web.vo.QestnarQesitmVO;
import humanframe.web.vo.QestnarQestnVO;
import humanframe.web.vo.QestnarVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
@Repository("qestnarDAO")
public class QestnarDAO extends HumanAbstractMapper {

	/**
	 * 설문조사 리스트
	 * @param listVO
	 * @return
	 * @throws Exception
	 */
	public HumanListVO selectQestnarListVO(HumanListVO listVO) throws Exception {
		return selectListVO(setDomain("fnct.qestnar.selectCount"), setDomain("fnct.qestnar.selectListVO"), listVO);
	}

	/**
	 * 설문조사 조회
	 * @param qestnarId
	 * @return
	 * @throws Exception
	 */
	public QestnarVO selectQestnarByPk(int qestnarNo) throws Exception {
		Map paramMap = new HashMap();
		paramMap.put("qestnarNo", qestnarNo);
		return (QestnarVO)selectOne(setDomain("fnct.qestnar.selectQestnar"), paramMap);
	}

	/**
	 * 설문조사 등록
	 * @param qestnarVO
	 * @throws Exception
	 */
	public int insertQestnar(QestnarVO qestnarVO) throws Exception {
		return insert(setDomain("fnct.qestnar.insertQestnar"), qestnarVO);
	}

	/**
	 * 설문조사 수정
	 * @param qestnarVO
	 * @throws Exception
	 */
	public void updateQestnar(QestnarVO qestnarVO) throws Exception {
		update(setDomain("fnct.qestnar.updateQestnar"), qestnarVO);
	}

	/**
	 * 설문조사 사용안함 처리
	 * @param qestnarNo
	 * @throws Exception
	 */
	public int updateQestnarNotUseByPk(int qestnarNo, String useAt) throws Exception {
		Map paramMap = new HashMap();
		paramMap.put("qestnarNo", qestnarNo);
		paramMap.put("useAt", useAt);
		return delete(setDomain("fnct.qestnar.updateQestnarNotUse"), paramMap);
	}

	/**
	 * 설문조사 질문 리스트
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<QestnarQestnVO> selectQestnList(HashMap<String,Object> paramMap) throws Exception {
		return (List<QestnarQestnVO>) list(setDomain("fnct.qestnarQestn.selectQestnList"), paramMap);
	}

	/**
	 * 설문조사 질문 조회
	 * @param qestnNo
	 * @return
	 * @throws Exception
	 */
	public QestnarQestnVO selectQestnarQestnByPk(int qestnNo) throws Exception {
		Map paramMap = new HashMap();
		paramMap.put("qestnNo", qestnNo);
		return (QestnarQestnVO)selectOne(setDomain("fnct.qestnarQestn.selectQestn"), paramMap);
	}

	/**
	 * 설문조사 질문 등록
	 * @param qestnVO
	 * @return
	 * @throws Exception
	 */
	public int insertQestn(QestnarQestnVO qestnarQestnVO) throws Exception {
		return insert(setDomain("fnct.qestnarQestn.insertQestn"), qestnarQestnVO);
	}

	/**
	 * 설문조사 질문 수정
	 * @param qestnVO
	 * @throws Exception
	 */
	public void updateQestn(QestnarQestnVO qestnarQestnVO) throws Exception {
		update(setDomain("fnct.qestnarQestn.updateQestn"), qestnarQestnVO);
	}

	/**
	 * 설문조사 질문 삭제
	 * @param qestnarNo
	 * @param qestnNo
	 * @return
	 * @throws Exception
	 */
	public int deleteQestn(int qestnarNo, int qestnNo) throws Exception {
		Map<String,Object> paramMap = new HashMap<String, Object>();
		paramMap.put("qestnarNo",qestnarNo);
		paramMap.put("qestnNo",qestnNo);
		return delete(setDomain("fnct.qestnarQestn.deleteQestn"), paramMap);
	}

	/**
	 * 설문조사 질문 순서 수정
	 * @param qestnNo
	 * @return
	 * @throws Exception
	 */
	public int updateQestnSort(String[] qestnNo) throws Exception {
		Map paramMap = new HashMap();
		paramMap.put("qestnNo", qestnNo);
		return update(setDomain("fnct.qestnarQestn.updateQestnSort"), paramMap);
	}

	/**
	 * 설문조사 질문 순서 수정 단일
	 * @param qestnNo
	 * @return
	 * @throws Exception
	 */
	public int updateQestnSortSingle(String qestnNo, int index) throws Exception {
		Map paramMap = new HashMap();
		paramMap.put("qestnNo", qestnNo);
		paramMap.put("index", index);
		return update(setDomain("fnct.qestnarQestn.updateQestnSortSingle"), paramMap);
	}

	/**
	 * 설문조사 항목 리스트
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<QestnarQesitmVO> selectQesitmList(HashMap<String,Object> paramMap) throws Exception {
		return (List<QestnarQesitmVO>) list(setDomain("fnct.qestnarQesitm.selectQesitmList"), paramMap);
	}

	/**
	 * 설문조사 항목 등록
	 * @param listQesitm
	 * @return
	 * @throws Exception
	 */
	public int insertQesitmList(List<QestnarQesitmVO> listQesitm) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("listQesitm", listQesitm);
		return insert(setDomain("fnct.qestnarQesitm.insertQesitmList"), map);
	}

	/**
	 * 설문조사 질문별 항목 전체 삭제
	 * @param qestnNo
	 * @throws Exception
	 */
	public void deleteQesitmByQestnNo(int qestnNo) throws Exception {
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("qestnNo", qestnNo);
		delete(setDomain("fnct.qestnarQesitm.deleteQesitmByQestnNo"), paramMap);
	}

	/**
	 * 설문조사 질문별 선택항목 제외 삭제
	 * @param qestnNo
	 * @throws Exception
	 */
	public void deleteQesitmByQesitmNotin(int[] qesitmNo, int qestnarNo, int qestnNo) throws Exception {
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("qesitmNo", qesitmNo);
		paramMap.put("qestnarNo", qestnarNo);
		paramMap.put("qestnNo", qestnNo);
		delete(setDomain("fnct.qestnarQesitm.deleteQesitmByQesitmNotin"), paramMap);
	}

	/**
	 * 설문조사 질문별 항목 순서 변경
	 * @param qestnNo
	 * @throws Exception
	 */
	public void updateQesitmByQesitmOrdr(int qesitmNo, int qestnarNo, int qestnNo, int qesitmOrdr, String nextQestnAt, String nextQestnNo) throws Exception {
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("qesitmNo", qesitmNo);
		paramMap.put("qestnarNo", qestnarNo);
		paramMap.put("qestnNo", qestnNo);
		paramMap.put("qesitmOrdr", qesitmOrdr);
		paramMap.put("nextQestnAt", nextQestnAt);
		paramMap.put("nextQestnNo", nextQestnNo);
		update(setDomain("fnct.qestnarQesitm.updateQesitmByQesitmOrdr"), paramMap);
	}


	/**
	 * 설문조사 투표용 질문 리스트
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> selectQestnAllList(HashMap<String,Object> paramMap) throws Exception {
		return (List<EgovMap>) list(setDomain("fnct.qestnarQestn.selectQestnAllList"), paramMap);
	}

	/**
	 * 설문조사 참여수 카운트
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int selectApplyCount(Map<String,Object> paramMap) throws Exception {
		return selectInt(setDomain("fnct.qestnarResult.selectApplyCount"), paramMap);
	}

	/**
	 * 설문조사 결과 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertQestnarResult(Map<String,Object> paramMap) throws Exception {
		return insert(setDomain("fnct.qestnarResult.insertQestnarResult"), paramMap);
	}

	/**
	 * 설문조사 결과 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int insertQestnarResultList(List listQestnarResult) throws Exception {
		Map paramMap = new HashMap();
		paramMap.put("listQestnarResult", listQestnarResult);
		return insert(setDomain("fnct.qestnarResult.insertQestnarResultList"), paramMap);
	}

	/**
	 * 설문조사 결과 삭제
	 * @param qestnarNo
	 * @param resultNo
	 * @throws Exception
	 */
	public void deleteQestnarResult(int qestnarNo, int resultNo) throws Exception {
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("qestnarNo", qestnarNo);
		if( resultNo>0 ){
		paramMap.put("resultNo", resultNo);
		}
		delete(setDomain("fnct.qestnarResult.deleteQestnarResult"), paramMap);
	}

	/**
	 * 설문조사 이전글 다음글
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> selectQestnarPrevNext(Map<String,Object> paramMap) throws Exception {
		return (List<EgovMap>) list(setDomain("fnct.qestnar.selectQestnarPrevNext"), paramMap);
	}

	/**
	 * 설문조사 주관식 결과 리스트
	 * @param listVO
	 * @return
	 * @throws Exception
	 */
	public HumanListVO selectQestnarResultListVO(HumanListVO listVO) throws Exception {
		return selectListVO(setDomain("fnct.qestnarResult.selectCount"), setDomain("fnct.qestnarResult.selectListVO"), listVO);
	}

	/**
	 * 개인별 리스트
	 * @param listVO
	 * @return
	 * @throws Exception
	 */
	public HumanListVO selectPersonalResultList(HumanListVO listVO) throws Exception {
		return selectListVO(setDomain("fnct.qestnarResult.selectPersonalResultListCount"), setDomain("fnct.qestnarResult.selectPersonalResultList"), listVO);
	}


	/**
	 * 개인별 전체 리스트
	 * @param listVO
	 * @return
	 * @throws Exception
	 */
	public HumanListVO selectPersonalResultAllList(HumanListVO listVO) throws Exception {
		return selectListVO(setDomain("fnct.qestnarResult.selectPersonalResultListCount"), setDomain("fnct.qestnarResult.selectPersonalResultAllList"), listVO);
	}

	/**
	 * 개인정보 삭제
	 * @param qestnarNo
	 * @return
	 * @throws Exception
	 */
	public Integer deletePrivacy(int qestnarNo) throws Exception {
		return update(setDomain("fnct.qestnarResult.deletePrivacy"), qestnarNo);
	}

	/**
	 * 개인별 설문 답변 상세
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> selectPersonalQestnList(HashMap<String, Object> paramMap) throws Exception {
		return (List<EgovMap>) list(setDomain("fnct.qestnarResult.selectPersonalQestnList"), paramMap);
	}

	/**
	 * 비회원&방문객 유니크아이디 생성
	 * @param paramMap
	 * @return
	 */
	public String selectMaxUniqueId(Map paramMap) throws Exception {
		return selectOne(setDomain("fnct.qestnarResult.selectMaxUniqueId"), paramMap);
	}

	public int selectEmailYn(Map<String,Object> reqMap) throws Exception {
		return selectInt(setDomain("fnct.qestnarResult.selectEmailYn"), reqMap);
	}
	/**
	 * 국가명
	 * @param paramMap
	 * @return
	 */
	public List<EgovMap> selectCountryList(Map<String,Object> reqMap) throws Exception {
		return selectList(setDomain("fnct.qestnar.selectCountryList"), reqMap);
	}
}
