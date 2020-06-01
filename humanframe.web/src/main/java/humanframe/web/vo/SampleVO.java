package humanframe.web.vo;

import java.util.Date;
import java.util.List;

import humanframe.backoffice.vo.FileVO;
import humanframe.core.vo.HumanBaseVO;

public class SampleVO extends HumanBaseVO {

	private int siteNo=0;
	private int menuNo=0;
	private int sampleNo=0;
	private String sj;
	private String cn;
	private String useAt = "Y";
	private Date creatDttm;
	private String crtrId;
	private String crtrNm;
	private Date updtDttm;
	private String updusrId;
	private String updusrNm;
	private List<FileVO> sampleFileList;

	public int getSiteNo() {
		return siteNo;
	}
	public void setSiteNo(int siteNo) {
		this.siteNo = siteNo;
	}
	public int getMenuNo() {
		return menuNo;
	}
	public void setMenuNo(int menuNo) {
		this.menuNo = menuNo;
	}
	public int getSampleNo() {
		return sampleNo;
	}
	public void setSampleNo(int sampleNo) {
		this.sampleNo = sampleNo;
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
	public String getUseAt() {
		return useAt;
	}
	public void setUseAt(String useAt) {
		this.useAt = useAt;
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
	public List<FileVO> getSampleFileList() {
		return sampleFileList;
	}
	public void setSampleFileList(List<FileVO> sampleFileList) {
		this.sampleFileList = sampleFileList;
	}

}