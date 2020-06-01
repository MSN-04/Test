package humanframe.web.vo;

import org.springframework.web.multipart.MultipartFile;

import humanframe.core.vo.HumanBaseVO;

public class QestnarQesitmVO  extends HumanBaseVO {

	private int qestnarNo=0;
	private int qestnNo=0;
	private int qesitmNo=0;
	private String qesitmText;
	private String qesitmTy;
	private int qesitmOrdr;
	private String nextQestnAt;
	private String nextQestnNo;

	/* 첨부 이미지 관련 */
	private MultipartFile[] imgFile; //이미지


	public MultipartFile[] getImgFile() {
		return imgFile;
	}
	public void setImgFile(MultipartFile[] imgFile) {
		this.imgFile = imgFile;
	}
	public int getQestnarNo() {
		return qestnarNo;
	}
	public void setQestnarNo(int qestnarNo) {
		this.qestnarNo = qestnarNo;
	}
	public int getQestnNo() {
		return qestnNo;
	}
	public void setQestnNo(int qestnNo) {
		this.qestnNo = qestnNo;
	}
	public int getQesitmNo() {
		return qesitmNo;
	}
	public void setQesitmNo(int qesitmNo) {
		this.qesitmNo = qesitmNo;
	}
	public String getQesitmText() {
		return qesitmText;
	}
	public void setQesitmText(String qesitmText) {
		this.qesitmText = qesitmText;
	}
	public String getQesitmTy() {
		return qesitmTy;
	}
	public void setQesitmTy(String qesitmTy) {
		this.qesitmTy = qesitmTy;
	}
	public int getQesitmOrdr() {
		return qesitmOrdr;
	}
	public void setQesitmOrdr(int qesitmOrdr) {
		this.qesitmOrdr = qesitmOrdr;
	}

	 public String getNextQestnAt() {
		return nextQestnAt;
	}
	public void setNextQestnAt(String nextQestnAt) {
		this.nextQestnAt = nextQestnAt;
	}
	public String getNextQestnNo() {
		return nextQestnNo;
	}
	public void setNextQestnNo(String nextQestnNo) {
		this.nextQestnNo = nextQestnNo;
	}
	public QestnarQesitmVO(){
	 }

	 public QestnarQesitmVO(int qestnarNo ,int qestnNo ,int qesitmNo ,String qesitmText, String qesitmTy, int qesitmOrdr, String nextQestnAt, String nextQestnNo) {
		 this.qestnarNo = qestnarNo;
		 this.qestnNo = qestnNo;
		 this.qesitmNo = qesitmNo;
		 this.qesitmText = qesitmText;
		 this.qesitmTy = qesitmTy;
		 this.qesitmOrdr = qesitmOrdr;
		 this.nextQestnAt = nextQestnAt;
		 this.nextQestnNo = nextQestnNo;
	}
}