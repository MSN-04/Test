package humanframe.web.vo;

import java.util.Date;
import java.util.List;

import humanframe.backoffice.vo.FileVO;
import humanframe.core.vo.HumanBaseVO;

public class CrsVO extends HumanBaseVO {

	private int crsNo;
	private String sj;
	private String linkUrl;
	private String part;
	private String cn;
	private String chargerUniqueId;
	private String chargerNm;
	private String aditChargerUniqueId;
	private String aditChargerNm;
	private String progrsSttus="1";
	private String processDt;
	private String processCn;
	private String crtrUniqueId;
	private Date creatDttm;
	private String crtrId;
	private String crtrNm;
	private String updusrUniqueId;
	private Date updtDttm;
	private String updusrId;
	private String updusrNm;
	private String useAt = "Y";
	private String telno;
	private String deptNm;
	private String allDeptNm;
	

	private List<FileVO> crsFileList;
	private List<FileVO> crsFileList1;

	public int getCrsNo() {
		return crsNo;
	}

	public void setCrsNo(int crsNo) {
		this.crsNo = crsNo;
	}
	

	public String getSj() {
		return sj;
	}

	public void setSj(String sj) {
		this.sj = sj;
	}

	public String getLinkUrl() {
		return linkUrl;
	}

	public void setLinkUrl(String linkUrl) {
		this.linkUrl = linkUrl;
	}

	public String getPart() {
		return part;
	}

	public void setPart(String part) {
		this.part = part;
	}

	public String getCn() {
		return cn;
	}

	public void setCn(String cn) {
		this.cn = cn;
	}

	public String getChargerUniqueId() {
		return chargerUniqueId;
	}

	public void setChargerUniqueId(String chargerUniqueId) {
		this.chargerUniqueId = chargerUniqueId;
	}

	public String getChargerNm() {
		return chargerNm;
	}

	public void setChargerNm(String chargerNm) {
		this.chargerNm = chargerNm;
	}

	public String getAditChargerUniqueId() {
		return aditChargerUniqueId;
	}

	public void setAditChargerUniqueId(String aditChargerUniqueId) {
		this.aditChargerUniqueId = aditChargerUniqueId;
	}

	public String getAditChargerNm() {
		return aditChargerNm;
	}

	public void setAditChargerNm(String aditChargerNm) {
		this.aditChargerNm = aditChargerNm;
	}

	public String getProgrsSttus() {
		return progrsSttus;
	}

	public void setProgrsSttus(String progrsSttus) {
		this.progrsSttus = progrsSttus;
	}

	public String getProcessDt() {
		return processDt;
	}

	public void setProcessDt(String processDt) {
		this.processDt = processDt;
	}

	public String getProcessCn() {
		return processCn;
	}

	public void setProcessCn(String processCn) {
		this.processCn = processCn;
	}

	public String getCrtrUniqueId() {
		return crtrUniqueId;
	}

	public void setCrtrUniqueId(String crtrUniqueId) {
		this.crtrUniqueId = crtrUniqueId;
	}

	public Date getCreatDttm() {
		return creatDttm;
	}

	public void setCreatDttm(Date creatDttm) {
		this.creatDttm = creatDttm;
	}

	public String getCrtrId() {
		return crtrId;
	}

	public void setCrtrId(String crtrId) {
		this.crtrId = crtrId;
	}

	public String getCrtrNm() {
		return crtrNm;
	}

	public void setCrtrNm(String crtrNm) {
		this.crtrNm = crtrNm;
	}

	public String getUpdusrUniqueId() {
		return updusrUniqueId;
	}

	public void setUpdusrUniqueId(String updusrUniqueId) {
		this.updusrUniqueId = updusrUniqueId;
	}

	public Date getUpdtDttm() {
		return updtDttm;
	}

	public void setUpdtDttm(Date updtDttm) {
		this.updtDttm = updtDttm;
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

	public String getUseAt() {
		return useAt;
	}

	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}

	public List<FileVO> getCrsFileList() {
		return crsFileList;
	}

	public void setCrsFileList(List<FileVO> crsFileList) {
		this.crsFileList = crsFileList;
	}

	public List<FileVO> getCrsFileList1() {
		return crsFileList1;
	}

	public void setCrsFileList1(List<FileVO> crsFileList1) {
		this.crsFileList1 = crsFileList1;
	}

	public String getTelno() {
		return telno;
	}

	public void setTelno(String telno) {
		this.telno = telno;
	}

	public String getDeptNm() {
		return deptNm;
	}

	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getAllDeptNm() {
		return allDeptNm;
	}

	public void setAllDeptNm(String allDeptNm) {
		this.allDeptNm = allDeptNm;
	}

	
	
}