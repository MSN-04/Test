package humanframe.web.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import humanframe.core.abst.HumanAbstractMapper;
import humanframe.core.vo.HumanListVO;
import humanframe.web.vo.PrjctInqryVO;

@Repository("prjctInqryDAO")
public class PrjctInqryDAO extends HumanAbstractMapper {

	public HumanListVO prjctInqryListVO(HumanListVO listVO) throws Exception {
		return selectListVO(setDomain("fnct.prjct.inqry.selectPrjctInqryCount"), setDomain("fnct.prjct.inqry.selectPrjctInqryListVO"), listVO);
	}

	public PrjctInqryVO retrievePrjctInqry(int inqryNo) throws Exception {
		return (PrjctInqryVO)selectOne(setDomain("fnct.prjct.inqry.selectPrjctInqry"), inqryNo);
	}

	public void insertPrjctInqry(PrjctInqryVO prjctInqryVO) throws Exception {
		insert(setDomain("fnct.prjct.inqry.insertPrjctInqry"), prjctInqryVO);
	}

	public int updatePrjctInqryUseAt(Map<String, Object> paramMap) throws Exception {
		return update(setDomain("fnct.prjct.inqry.updatePrjctInqryUseAt"), paramMap);
	}

	public void updatePrjctInqry(PrjctInqryVO prjctInqryVO) throws Exception {
		update(setDomain("fnct.prjct.inqry.updatePrjctInqry"), prjctInqryVO);
	}

	public void deletePrjctInqry(int inqryNo) throws Exception {
		update(setDomain("fnct.prjct.inqry.deletePrjctInqry"), inqryNo);
	}
}
