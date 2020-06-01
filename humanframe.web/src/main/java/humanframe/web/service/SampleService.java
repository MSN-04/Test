package humanframe.web.service;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import humanframe.core.vo.HumanListVO;
import humanframe.web.dao.SampleDAO;
import humanframe.web.vo.SampleVO;

@SuppressWarnings("rawtypes")
@Service("sampleService")
public class SampleService extends EgovAbstractServiceImpl {

	@Resource(name="sampleDAO")
	private SampleDAO sampleDAO;

	public HumanListVO sampleListVO(HumanListVO listVO) throws Exception {
		return sampleDAO.sampleListVO(listVO);
	}

	public SampleVO retrieveSample(int sampleNo) throws Exception {
		return sampleDAO.retrieveSample(sampleNo);
	}

	public Integer updateSampleUseAt(Map paramMap) throws Exception {
		return sampleDAO.updateSampleUseAt(paramMap);
	}

	public void createSample(SampleVO sampleVO) throws Exception {
		sampleDAO.createSample(sampleVO);
	}

	public void updateSample(SampleVO sampleVO) throws Exception {
		sampleDAO.updateSample(sampleVO);
	}

	public void deleteSample(int sampleNo) throws Exception {
		sampleDAO.deleteSample(sampleNo);
	}
}