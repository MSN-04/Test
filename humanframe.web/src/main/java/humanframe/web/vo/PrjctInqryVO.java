package humanframe.web.vo;

import java.util.List;

import humanframe.backoffice.vo.FileVO;
import humanframe.core.vo.HumanBaseVO;

public class PrjctInqryVO extends HumanBaseVO {

	private int inqryNo;
	private int siteNo;
	private String siteNm;
	private String sj;
	private String cn;
	private String cmpnyNm;
	private String url;
	private String chargerNm;
	private String chargerDept;
	private String email;
	private String tel;
	private String budget;
	private String etc;
	private String creatDttm;
	private String useAt;
	private String processSttus;
	private String processCn;
	private String processDt;
	private String updusrId;
	private String updusrNm;
	private String updtDttm;

	private List<FileVO> fileList;

	public int getInqryNo() {
		return inqryNo;
	}

	public void setInqryNo(int inqryNo) {
		this.inqryNo = inqryNo;
	}

	public int getSiteNo() {
		return siteNo;
	}

	public void setSiteNo(int siteNo) {
		this.siteNo = siteNo;
	}

	public String getSiteNm() {
		return siteNm;
	}

	public void setSiteNm(String siteNm) {
		this.siteNm = siteNm;
	}

	public String getSj() {
		return sj;
	}

	public void setSj(String sj) {
		this.sj = sj;
	}

	public String getCn() {
		return cn;
	}

	public void setCn(String cn) {
		this.cn = cn;
	}

	public String getCmpnyNm() {
		return cmpnyNm;
	}

	public void setCmpnyNm(String cmpnyNm) {
		this.cmpnyNm = cmpnyNm;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getChargerNm() {
		return chargerNm;
	}

	public void setChargerNm(String chargerNm) {
		this.chargerNm = chargerNm;
	}

	public String getChargerDept() {
		return chargerDept;
	}

	public void setChargerDept(String chargerDept) {
		this.chargerDept = chargerDept;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getBudget() {
		return budget;
	}

	public void setBudget(String budget) {
		this.budget = budget;
	}

	public String getEtc() {
		return etc;
	}

	public void setEtc(String etc) {
		this.etc = etc;
	}

	public String getCreatDttm() {
		return creatDttm;
	}

	public void setCreatDttm(String creatDttm) {
		this.creatDttm = creatDttm;
	}

	public String getUseAt() {
		return useAt;
	}

	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}

	public String getProcessSttus() {
		return processSttus;
	}

	public void setProcessSttus(String processSttus) {
		this.processSttus = processSttus;
	}

	public String getProcessCn() {
		return processCn;
	}

	public void setProcessCn(String processCn) {
		this.processCn = processCn;
	}

	public String getProcessDt() {
		return processDt;
	}

	public void setProcessDt(String processDt) {
		this.processDt = processDt;
	}

	public String getUpdusrId() {
		return updusrId;
	}

	public void setUpdusrId(String updusrId) {
		this.updusrId = updusrId;
	}

	public String getUpdusrNm() {
		return updusrNm;
	}

	public void setUpdusrNm(String updusrNm) {
		this.updusrNm = updusrNm;
	}

	public String getUpdtDttm() {
		return updtDttm;
	}

	public void setUpdtDttm(String updtDttm) {
		this.updtDttm = updtDttm;
	}

	public List<FileVO> getFileList() {
		return fileList;
	}

	public void setFileList(List<FileVO> fileList) {
		this.fileList = fileList;
	}

	@Override
	public String toString() {
		return "PrjctInqryVO [inqryNo=" + inqryNo + ", siteNo=" + siteNo + ", siteNm=" + siteNm + ", sj=" + sj + ", cn="
				+ cn + ", cmpnyNm=" + cmpnyNm + ", url=" + url + ", chargerNm=" + chargerNm + ", chargerDept="
				+ chargerDept + ", email=" + email + ", tel=" + tel + ", budget=" + budget + ", etc=" + etc
				+ ", creatDttm=" + creatDttm + ", useAt=" + useAt + ", processSttus=" + processSttus + ", processCn="
				+ processCn + ", processDt=" + processDt + ", updusrId=" + updusrId + ", updusrNm=" + updusrNm
				+ ", updtDttm=" + updtDttm + ", fileList=" + fileList + "]";
	}


}