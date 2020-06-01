package humanframe.web.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import humanframe.core.vo.HumanListVO;
import humanframe.web.dao.CrsDAO;
import humanframe.web.vo.CrsVO;

@SuppressWarnings("rawtypes")
@Service("crsService")
public class CrsService extends EgovAbstractServiceImpl {

	@Resource(name="crsDAO")
	private CrsDAO crsDAO;

	
	public HumanListVO crsListVO(HumanListVO listVO) throws Exception {
		return crsDAO.crsListVO(listVO);
	}

	
	public List crsListAll(Map paramMap) throws Exception {
		return crsDAO.crsListAll(paramMap);
	}

	
	public CrsVO retrieveCrs(int wordNo) throws Exception {
		return crsDAO.retrieveCrs(wordNo);
	}

	
	public Integer updateCrsUseAt(Map paramMap) throws Exception {
		return crsDAO.updateCrsUseAt(paramMap);
	}

	
	public void createCrs(CrsVO crsVO) throws Exception {
		crsDAO.createCrs(crsVO);
	}

	
	public void updateCrs(CrsVO crsVO) throws Exception {
		crsDAO.updateCrs(crsVO);
	}

	
	public void deleteCrs(int wordNo) throws Exception {
		crsDAO.deleteCrs(wordNo);
	}
}