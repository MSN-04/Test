package humanframe.web.vo;

import humanframe.core.vo.HumanBaseVO;

public class QestnarQestnVO  extends HumanBaseVO {

	private int qestnNo=0;
	private int qestnarNo=0;
	private String qestnText;
	private String qestnTy;
	private String etcOpinionAt;
	private int ordr;
	private String qestnTi;

	/*이미지*/
	private int fileNo = 0;
	private String flpth;
	private String orginlFileNm;
	private String streFileNm;
	private String fileExtsn;
	private int fileSize = 0;
	private String fileDc;
	private String dwldCo;
	private String useAt;

	//필수여부
	private String essentialTy = "N";
	private String nextQestnTy = "N";

	//private List<QestnarQesitmVO> qesitmList;

	public int getQestnNo() {
		return qestnNo;
	}
	public int getFileNo() {
		return fileNo;
	}
	public void setFileNo(int fileNo) {
		this.fileNo = fileNo;
	}
	public String getFlpth() {
		return flpth;
	}
	public void setFlpth(String flpth) {
		this.flpth = flpth;
	}
	public String getOrginlFileNm() {
		return orginlFileNm;
	}
	public void setOrginlFileNm(String orginlFileNm) {
		this.orginlFileNm = orginlFileNm;
	}
	public String getStreFileNm() {
		return streFileNm;
	}
	public void setStreFileNm(String streFileNm) {
		this.streFileNm = streFileNm;
	}
	public String getFileExtsn() {
		return fileExtsn;
	}
	public void setFileExtsn(String fileExtsn) {
		this.fileExtsn = fileExtsn;
	}
	public int getFileSize() {
		return fileSize;
	}
	public void setFileSize(int fileSize) {
		this.fileSize = fileSize;
	}
	public String getFileDc() {
		return fileDc;
	}
	public void setFileDc(String fileDc) {
		this.fileDc = fileDc;
	}
	public String getDwldCo() {
		return dwldCo;
	}
	public void setDwldCo(String dwldCo) {
		this.dwldCo = dwldCo;
	}
	public String getUseAt() {
		return useAt;
	}
	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}
	public void setQestnNo(int qestnNo) {
		this.qestnNo = qestnNo;
	}
	public int getQestnarNo() {
		return qestnarNo;
	}
	public void setQestnarNo(int qestnarNo) {
		this.qestnarNo = qestnarNo;
	}
	public String getQestnText() {
		return qestnText;
	}
	public void setQestnText(String qestnText) {
		this.qestnText = qestnText;
	}
	public String getQestnTy() {
		return qestnTy;
	}
	public void setQestnTy(String qestnTy) {
		this.qestnTy = qestnTy;
	}
	public String getEtcOpinionAt() {
		return etcOpinionAt;
	}
	public void setEtcOpinionAt(String etcOpinionAt) {
		this.etcOpinionAt = etcOpinionAt;
	}
	public int getOrdr() {
		return ordr;
	}
	public void setOrdr(int ordr) {
		this.ordr = ordr;
	}
	public String getQestnTi() {
		return qestnTi;
	}
	public void setQestnTi(String qestnTi) {
		this.qestnTi = qestnTi;
	}
	public String getEssentialTy() {
		return essentialTy;
	}
	public void setEssentialTy(String essentialTy) {
		this.essentialTy = essentialTy;
	}
	public String getNextQestnTy() {
		return nextQestnTy;
	}
	public void setNextQestnTy(String nextQestnTy) {
		this.nextQestnTy = nextQestnTy;
	}

	/*public List<QestnarQesitmVO> getQesitmList() {
		return qesitmList;
	}
	public void setQesitmList(List<QestnarQesitmVO> qesitmList) {
		this.qesitmList = qesitmList;
	}*/
}