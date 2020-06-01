package humanframe.web.common;

/**
 * 프로젝트 상수값
 * tc_code에서 하위 코드를 호출하기 위한 group_code_id 선언

 *
 * code service 사용법 참고
 *
 * filterKey에 따른 코드리스트를 반환한다.
 *
 * @param : Map형태의 key/value 검색
 * @param : paramMap.put("filterKey", key), filterKey : {codeGroupId:코드그룹, codeTy:코드타입},
 * @param : paramMap.put("filterVal", value), filterVal : CommonConstants 참고
 * @param : paramMap.put("filterLangCodeId", value), filterLangCodeId : 사이트언어 코드 아이디
 *
 * @return : 결과 List 를 리턴한다 (VO)
 * @throws Exception
 *
 * ex)
 * 	@Resource(name="codeService")
 *	private CodeService codeService;
 *
 *	Map<String, Object> paramMap = new HashMap<String, Object>();
 *	paramMap.put("filterKey", "codeGroupId");
 *	paramMap.put("filterVal", Constants.AREA_GROUP_ID);
 *	List<CodeVO> AreaCodeList = codeService.retrieveCodeList(paramMap);
 *
 */
public class CommConstants {

	public static String CRS_TY_GROUP_ID = "CRS_TY"; // CRS구분
	public static String TERM_TY_GROUP_ID = "TERM_TY";		//용어관리명


}
