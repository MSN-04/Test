package humanframe.web.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import humanframe.core.abst.HumanAbstractMapper;
import humanframe.core.vo.HumanListVO;
import humanframe.web.vo.SampleVO;

@SuppressWarnings("rawtypes")
@Repository("sampleDAO")
public class SampleDAO extends HumanAbstractMapper {

	public HumanListVO sampleListVO(HumanListVO listVO) throws Exception {
		return selectListVO(setDomain("fnct.sample.selectSampleCount"), setDomain("fnct.sample.selectSampleListVO"), listVO);
	}

	public SampleVO retrieveSample(int sampleNo) throws Exception {
		return (SampleVO)selectOne(setDomain("fnct.sample.selectSample"), sampleNo);
	}

	public Integer updateSampleUseAt(Map paramMap) throws Exception {
		return update(setDomain("fnct.sample.updateSampleUseAt"), paramMap);
	}

	public void createSample(SampleVO sampleVO) throws Exception {
		insert(setDomain("fnct.sample.insertSample"), sampleVO);
	}

	public void updateSample(SampleVO sampleVO) throws Exception {
		update(setDomain("fnct.sample.updateSample"), sampleVO);
	}

	public void deleteSample(int sampleNo) throws Exception {
		delete(setDomain("fnct.sample.deleteSample"), sampleNo);
	}

}