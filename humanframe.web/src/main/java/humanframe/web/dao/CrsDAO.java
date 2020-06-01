package humanframe.web.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import humanframe.core.abst.HumanAbstractMapper;
import humanframe.core.vo.HumanListVO;
import humanframe.web.vo.CrsVO;

@SuppressWarnings("rawtypes")
@Repository("crsDAO")
public class CrsDAO extends HumanAbstractMapper {

	public HumanListVO crsListVO(HumanListVO listVO) throws Exception {
		return selectListVO(setDomain("fnct.crs.selectCrsCount"), setDomain("fnct.crs.selectCrsListVO"), listVO);
	}

	public List crsListAll(Map paramMap) throws Exception {
		return selectList(setDomain("fnct.crs.selectCrsListAll"), paramMap);
	}

	public CrsVO retrieveCrs(int wordNo) throws Exception {
		return (CrsVO)selectOne(setDomain("fnct.crs.selectCrs"), wordNo);
	}

	public Integer updateCrsUseAt(Map paramMap) throws Exception {
		return update(setDomain("fnct.crs.updateCrsUseAt"), paramMap);
	}

	public void createCrs(CrsVO crsVO) throws Exception {
		insert(setDomain("fnct.crs.insertCrs"), crsVO);
	}

	public void updateCrs(CrsVO crsVO) throws Exception {
		update(setDomain("fnct.crs.updateCrs"), crsVO);
	}

	public void deleteCrs(int wordNo) throws Exception {
		update(setDomain("fnct.crs.deleteCrs"), wordNo);
	}
}
