package humanframe.web.service;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import humanframe.core.vo.HumanListVO;
import humanframe.web.dao.PrjctInqryDAO;
import humanframe.web.vo.PrjctInqryVO;

@Service("prjctInqryService")
public class PrjctInqryService extends EgovAbstractServiceImpl {

	@Resource(name="prjctInqryDAO")
	private PrjctInqryDAO prjctInqryDAO;


	public HumanListVO prjctInqryListVO(HumanListVO listVO) throws Exception {
		return prjctInqryDAO.prjctInqryListVO(listVO);
	}

	public PrjctInqryVO retrievePrjctInqry(int inqryNo) throws Exception {
		return prjctInqryDAO.retrievePrjctInqry(inqryNo);
	}

	public void insertPrjctInqry(PrjctInqryVO prjctInqryVO) throws Exception {
		prjctInqryDAO.insertPrjctInqry(prjctInqryVO);
	}

	public int updatePrjctInqryUseAt(Map<String, Object> paramMap) throws Exception {
		return prjctInqryDAO.updatePrjctInqryUseAt(paramMap);
	}

	public void updatePrjctInqry(PrjctInqryVO prjctInqryVO) throws Exception {
		prjctInqryDAO.updatePrjctInqry(prjctInqryVO);
	}

	public void deletePrjctInqry(int inqryNo) throws Exception {
		prjctInqryDAO.deletePrjctInqry(inqryNo);
	}
}