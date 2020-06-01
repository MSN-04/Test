package humanframe.web.vo;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import humanframe.core.vo.HumanBaseVO;

public class QestnarVO  extends HumanBaseVO {

	private int siteNo=0;
	private int menuNo=0;
	private int qestnarNo=0;
	private String sj;
	private String cn;
	private String bgnDttm;
	private String endDttm;
	private String qustnrTrget = "A";
	private String othbcAt = "Y";
	private String useAt;
	private int mlg=0;
	private Date creatDttm;
	private String crtrUniqueId;
	private String crtrId;
	private String crtrNm;
	private Date updtDttm;
	private String updusrUniqueId;
	private String updusrId;
	private String updusrNm;

	/* 첨부 이미지 관련 */
	private MultipartFile imgFile; //이미지
	private String fileDc;	//파일 설명

	private String progrsSttus;
	private int resultCnt;	//설문 참여자 수

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
	public int getQestnarNo() {
		return qestnarNo;
	}
	public void setQestnarNo(int qestnarNo) {
		this.qestnarNo = qestnarNo;
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
	public String getBgnDttm() {
		return bgnDttm;
	}
	public void setBgnDttm(String bgnDttm) {
		this.bgnDttm = bgnDttm;
	}
	public String getEndDttm() {
		return endDttm;
	}
	public void setEndDttm(String endDttm) {
		this.endDttm = endDttm;
	}
	public String getQustnrTrget() {
		return qustnrTrget;
	}
	public void setQustnrTrget(String qustnrTrget) {
		this.qustnrTrget = qustnrTrget;
	}
	public String getOthbcAt() {
		return othbcAt;
	}
	public void setOthbcAt(String othbcAt) {
		this.othbcAt = othbcAt;
	}
	public String getUseAt() {
		return useAt;
	}
	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}
	public int getMlg() {
		return mlg;
	}
	public void setMlg(int mlg) {
		this.mlg = mlg;
	}
	public Date getCreatDttm() {
		return creatDttm;
	}
	public void setCreatDttm(Date creatDttm) {
		this.creatDttm = creatDttm;
	}
	public String getCrtrUniqueId() {
		return crtrUniqueId;
	}
	public void setCrtrUniqueId(String crtrUniqueId) {
		this.crtrUniqueId = crtrUniqueId;
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
	public String getUpdusrUniqueId() {
		return updusrUniqueId;
	}
	public void setUpdusrUniqueId(String updusrUniqueId) {
		this.updusrUniqueId = updusrUniqueId;
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
	public MultipartFile getImgFile() {
		return imgFile;
	}
	public void setImgFile(MultipartFile imgFile) {
		this.imgFile = imgFile;
	}
	public String getProgrsSttus() {
		return progrsSttus;
	}
	public void setProgrsSttus(String progrsSttus) {
		this.progrsSttus = progrsSttus;
	}
	public int getResultCnt() {
		return resultCnt;
	}
	public void setResultCnt(int resultCnt) {
		this.resultCnt = resultCnt;
	}
	public String getFileDc() {
		return fileDc;
	}
	public void setFileDc(String fileDc) {
		this.fileDc = fileDc;
	}

}