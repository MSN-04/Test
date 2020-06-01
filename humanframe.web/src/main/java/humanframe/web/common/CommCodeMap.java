package humanframe.web.common;

import java.util.HashMap;
import java.util.LinkedHashMap;

/**
 * HashMap type 고정 code값
 * @author yooncoms
 *	사용법 model.addAttribute("sexdstnTy", BusanCodeMap.SEXDSTN_TY);
 *
 */
public class CommCodeMap {

	/** 회원 - 성별 */
	public static final HashMap<String, String> SEXDSTN_TY = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("M", "남");
			put("F", "여");
		}
	};
	/** 진행 여부 */
	public static final HashMap<String, String> PROGRS_AT = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("Y", "진행");
			put("N", "완료");
		}
	};

	/** 공개 여부*/
	public static final HashMap<String, String> OTHBC_AT = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("Y", "공개");
			put("N", "비공개");
		}
	};

	/** 입주신청 여부*/
	public static final HashMap<String, String> MOVEPLAN_AT = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("Y", "가능");
			put("N", "불가능");
		}
	};

	/** 이메일 수신 여부 */
	public static final HashMap<String, String> EMAIL_RECPTN_AT = new LinkedHashMap<String, String>(){
		private static final long serialVersionUID = 1L;
		{
			put("Y", "허용");
			put("N", "허용안함");
		}
	};

	/** 승인 여부 */
	public static final HashMap<String, String> CONFM_AT = new LinkedHashMap<String, String>(){
		private static final long serialVersionUID = 1L;
		{
			put("Y", "승인");
			put("N", "미승인");
		}
	};

	/** 추진 여부 */
	public static final HashMap<String, String> PRTN_AT = new LinkedHashMap<String, String>(){
		private static final long serialVersionUID = 1L;
		{
			put("Y", "추진");
			put("N", "미추진");
		}
	};

	/** 결정 여부 */
	public static final HashMap<String, String> DECSN_AT = new LinkedHashMap<String, String>(){
		private static final long serialVersionUID = 1L;
		{
			put("Y", "확정");
			put("N", "미확정");
		}
	};

	/** 설문문항타입: R-단일선택/C-중복선택/T-주관식 */
	public static final HashMap<String, String> QESTN_TY = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("R", "단일선택");
			put("C", "중복선택");
			put("T", "주관식");
		}
	};

	/** 설문항목타입: A-텍스트/B-이미지 */
	public static final HashMap<String, String> QESTN_TI = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("A", "텍스트");
			put("B", "이미지");
		}
	};

	/** CRS 타입: 1-디자인/2-프로그램/3-디자인+프로그램/4-기타*/
	public static final HashMap<String, String> CRS_TY1 = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("1", "디자인");
			put("2", "프로그램");
			put("3", "디자인+프로그램");
			put("4", "기타");
		}
	};

	/** CRS 진행상태: 1-대기중/2-진행중/3-완료/4-보류*/
	public static final HashMap<String, String> CRS_TY2 = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("1", "대기중");
			put("2", "진행중");
			put("3", "완료");
			put("4", "보류");
		}
	};

	/** 게시판 필드타입: A-문자/B-문자열/C-라디오버튼/D-체크박스/E-셀렉트박스*/
	public static final HashMap<String, String> FIELD_TY = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("A", "문자");
			put("B", "문자열");
			put("C", "라디오버튼");
			put("D", "체크박스");
			put("E", "셀렉트박스");
		}
	};

	/** 게시판 문자타입: base-기본/integer-숫자/email-이메일/phone-전화번호/date-날짜/addss-주소*/
	public static final HashMap<String, String> CHRCTR_TY = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("base", "기본");
			put("integer", "숫자");
			put("email", "이메일");
			put("phone", "전화번호");
			put("date", "날짜");
			put("addss", "주소");
		}
	};

	/** 게시판 필드정렬타입: L-왼쪽/C-중앙/R-오른쪽 */
	public static final HashMap<String, String> FIELD_SORT = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("L", "왼쪽");
			put("C", "중앙");
			put("R", "오른쪽");
		}
	};

	/** 설문조사 필수여부 */
	public static final HashMap<String, String> ESSENTIAL_TY = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("Y", "예");
			put("N", "아니오");
		}
	};

	/** 설문조사 다음질문여부 */
	public static final HashMap<String, String> NEXTQESTN_TY = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("Y", "예");
			put("N", "아니오");
		}
	};

	/** 시민참여 대상타입: A-모두/Y-회원/N-회원+비회원 */
	public static final HashMap<String, String> RCRIT_TRGET = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("A", "모두");
			put("Y", "회원");
			put("N", "회원+비회원");
		}
	};

	/** 예산타입: ''-예산, 1-4천만원 미만/2-4천~6천만원/3-6천~8천만원/4-8천~1억만원/5-1억~2억이상/6-2억이상 */
	public static final HashMap<String, String> BUDGET_TY = new LinkedHashMap<String, String>() {
		private static final long serialVersionUID = 1L;
		{
			put("", "예산");
			put("1", "4천만원 미만");
			put("2", "4천~6천만원");
			put("3", "6천~8천만원");
			put("4", "8천~1억만원");
			put("5", "1억~2억이상");
			put("6", "2억이상");
		}
	};
}
