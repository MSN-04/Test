<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
			<script>

			function f_OAuth() {
				window.open("/admin/oauth/google", "oauth", "width=500,height=500");
			}

			function f_duplicateCheck(){

				// domain validation check
				var urlCheckReg = /^([\d\w-]+\.){1,2}((net)|(com)|(go\.kr)|(co\.kr)|(kr)|(org)|(or\.kr))/igm;
				var siteUrlVal = $("#siteUrl").val();
				if(!urlCheckReg.test(siteUrlVal)) {
					var alertStr = '형식에 맞지 않는 URL입니다.\n\n';
					alertStr += '예) example.com 또는 example.example.com \n\n';
					alertStr += '도메인은 net/com/go.kr/co.kr/kr/org/or.kr만 가능합니다.\n';
					alert(alertStr);
					return false;
				}

				$.ajax({
					type : "post",
					url: './retrieveDupCo',
					data: 'siteUrl=' + $("#siteUrl").val() +"/"+ $("#firstUri").val(),
					dataType: 'text', //전송받을 데이터의 타입
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					success: function(data) {
						if(data=="true"){
							alert("사용가능한 URL 입니다.");
							$("#dataDupCheck").val(1);
						}else{
							alert("이미 사용중인 URL 입니다.\n\n도메인을 변경하거나 추가 PATH를 입력하세요.");
							$("#dataDupCheck").val(0);
						}
					},
					error: function(data, status, err) {
						console.log('error forward : ' + data);
					}
				});
			}

			$(function() {

				f_callbackAdminList("${siteVO.siteNo}", "");

				$("#siteUrl, #firstUri").on("keyup", function(){
					$("#dataDupCheck").val(0);
				});

				$("form[name='frmSite']").validate({
				    ignore: "input[type='text']:hidden",
				    rules : {
				    	siteNm		: { required : true }
				    	, siteUrl		: { required : true }
				    	, siteSkn	: { required : true }
				    	, langCodeId	: { required : true }
				    },
				    messages : {
				    	siteNm		: { required : "사이트명을 입력하세요"}
				    	, siteUrl		: { required : "사이트 URL을 입력하세요"}
				    	, siteSkn	: { required : "사이트 스킨을 선택하세요" }
				    	, langCodeId	: { required : "사이트 언어를 선택하세요" }
				    },
				    errorElement: 'span',
				    errorClass: 'help-block error',
				    errorPlacement: function(error, element) {
						error.insertAfter(element.parent().find(':last'));
					},
				    highlight:function(element, errorClass, validClass) {
				        $(element).addClass('error');
				    },
				    unhighlight: function(element, errorClass, validClass) {
				        $(element).removeClass('error');
				    },
				    submitHandler: function (frm) {
				    	if($("#dataDupCheck").val() == 0){
				    		alert("사이트 중복 확인을 해야 합니다.");
				    		return false;
				    	}

				    	if(confirm("입력하신 정보를 저장 하시겠습니까?")){
				    		frm.submit();
				    	}else{
				    		return false;
				    	}
				    }
				});
			});

			//관리자검색>>
			function f_mngrSearch(){
				var type ="S";
				window.open("/admin/mng/mngr/popup/mngrList2?type="+type, "popMngr", "width=780, height=525");
			}

			$(document).on("click", "#mngrMapngTable .delBtn", function(){
				$(this).parents("tr").fadeOut(300, function(){$(this).remove();});
			});

			function f_callbackAdminList(sn, mn){
				$("#mngrDiv").show();

				$("#mngrMapngTable tr").remove();

				$.ajax({//관리자 목록 호출
					type : "post",
					url: '/admin/mng/mngr/siteMngrList.json',
					dataType: 'json',
					data:{siteNo:sn, menuNo:mn, type:"S"},
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					success: function(data) {
						$.each(data, function (index, value) {
							var inputMngrId = "<input type=\"hidden\" name=\"arrMngrId\" value=\""+ value.mngrId +"\" />";
							var mngrNm = value.mngrNm;
							var mngrDept = value.deptNm;
							$("#mngrMapngTable tbody").append("<tr><td>"+inputMngrId+mngrNm+"</td><td>"+ mngrDept +"</td><td class=\"text-right\"><a href=\"#DEL\" class=\"btn btn-default btn-xs delBtn\"><i class=\"fa fa-trash text-danger\"></i> 해제</a></td></tr>");
		                });
						if(data.length < 1){
							$("#mngrMapngTable").append("<tr class=\"emptyTr\"><td>등록된 관리자가 없습니다.</td></tr>");
						}
					},
					error: function(data, status, err) {
					}
				});
			}

			</script>
			
			

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="사이트 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
			
			<f:form name="frmSite" id="frmSite" modelAttribute="siteVO" method="post" action="./action" class="form-horizontal">
               	<f:hidden path="crud" />
				<f:hidden path="siteNo" />
				<input type="hidden" id="curPage" name="curPage" value="${param.curPage }" />
				<input type="hidden" id="srchKey" name="srchKey" value="${param.srchKey }" />
				<input type="hidden" id="srchText" name="srchText" value="${param.srchText }" />
				<input type="hidden" id="srchClCodeId" name="srchClCodeId" value="${param.srchClCodeId }" />
				<input type="hidden" id="dataDupCheck" name="dataDupCheck" value="<c:out value='${siteVO.siteNo>0?1:0}'/>" />
			
				<div class="col-md-9 p-none">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">사이트 등록/수정</h2>
						<p class="panel-subtitle">
							
						</p>
					</header>
					
					
					<div class="panel-body">

					<table class="table">
						<colgroup>
							<col style="width:130px"/>
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th>사이트 분류</th>
								<td>
									<f:select path="clCodeId" class="form-control">
										<f:option value="" label="선택하세요" selected="selected" />
										<c:forEach items="${clCodeList}" var="clCodeList">
										<f:option value="${clCodeList.codeId}" label="${clCodeList.codeNm }" />
										</c:forEach>
									</f:select>
									<div></div>
								</td>
							</tr>
							<tr>
								<th>사이트명 <span class="required">*</span></th>
								<td>
									<f:input path="siteNm" class="form-control" placeholder="사이트명"/>
								</td>
							</tr>
							<tr>
								<th>사이트 URL <span class="required">*</span></th>
								<td>
									<div class="form-inline">
										<p class="form-control-static">http://</p>
										<f:input path="siteUrl" class="form-control" placeholder="domain"/>
										<p class="form-control-static">/</p>
										<f:input path="firstUri" class="form-control" cssStyle="width:100px;" placeholder="path"/>
										<button class="btn btn-info" style="margin-left:5px;" onclick="f_duplicateCheck(); return false;">중복확인</button>
									</div>
									<span class="help-block">* path입력으로 사이트 구분이 가능합니다.<br />ex) http://domain.com/<b>ko</b>/~ ko가 사이트 구분 URI입니다.</span>
								</td>
							</tr>
							<tr>
								<th>사이트 스킨<span class="required">*</span></th>
								<td>
									<f:select path="siteSkn" class="form-control">
										<f:option value="" label="선택하세요" selected="selected" />
										<c:forEach items="${themeList}" var="themeList">
										<f:option value="${themeList.folderName}" label="${themeList.folderName}" />
										</c:forEach>
									</f:select>
									<div></div>
								</td>
							</tr>
							<tr>
								<th>사이트 언어<span class="required">*</span></th>
								<td>
									<f:select path="langCodeId" class="form-control">
										<f:option value="" label="선택하세요" selected="selected" />
										<c:forEach items="${langCodeList}" var="langCodeList">
										<f:option value="${langCodeList.codeId}" label="${langCodeList.codeNm }" />
										</c:forEach>
									</f:select>
									<div></div>
								</td>
							</tr>
							<tr>
								<th>사이트 설명</th>
								<td>
									<f:textarea path="siteDc" class="form-control" rows="5" placeholder="사이트 설명(참고용)"/>
								</td>
							</tr>
							<tr style="display:none;">
								<th>GNB메뉴 <span class="required">*</span></th>
								<td>
									<f:radiobuttons path="mnmnuUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
								</td>
							</tr>
							<tr style="display:none;">
								<th>LNB메뉴 <span class="required">*</span></th>
								<td>
									<f:radiobuttons path="sbmnuUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
								</td>
							</tr>
							<tr>
								<th>Meta tag(공통)</th>
								<td>
									<f:textarea path="metaTag" class="form-control" rows="3" placeholder="meta tag" />
								</td>
							</tr>
							<tr>
								<th>구글 접속통계 KEY</th>
								<td>
									<f:hidden path="googleProfileId" />
									<f:hidden path="googleAccesTkn" />
									<f:hidden path="googleRefreshTkn" />
									<div class="form-inline">
									<f:input path="googleKey" class="form-control" />
									<button id="btnOAuth" class="btn btn-info" style="margin-left:5px;" onclick="f_OAuth(); return false;">인증받기</button>
									</div>
								</td>
							</tr>
							<tr>
								<th>네이버 접속통계 KEY</th>
								<td>
									<div class="form-inline">
									<f:input path="naverKey" class="form-control" />
									<p class="mb-none mt-xs">
										<i class="fa fa-info-circle"></i> 네이버 애널리틱스<code>http://analytics.naver.com</code>에 사이트 등록 후 발급된 ID를 입력한다.
									</p>
									</div>
								</td>
							</tr>
							<tr>
								<th>지도 API 선택</th>
								<td>
									<f:radiobuttons path="mapTy" items="${mapTyCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
								</td>
							</tr>
							<tr>
								<th>만족도 조사 사용여부</th>
								<td>
									<f:radiobuttons path="stsfdgUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
								</td>
							</tr>
							<tr>
								<th>코멘트 사용여부</th>
								<td>
									<f:radiobuttons path="cmUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
								</td>
							</tr>
							<tr>
								<th>담당자 사용여부</th>
								<td>
									<f:radiobuttons path="mnuChargerUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
								</td>
							</tr>
							<tr>
								<th>사용여부 <span class="required">*</span></th>
								<td>
									<f:radiobuttons path="useAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
								</td>
							</tr>
						</tbody>
					</table>


					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="curPage=${param.curPage }&amp;srchKey=${param.srchKey}&amp;srchText=${param.srchText}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
								<cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
							</div>
						</div>
					</footer>
					
				</section>
				</div>
				
				<div class="col-md-3 pr-none">

					<section class="panel panel-featured panel-featured-primary">
						<header class="panel-heading">
							<div class="panel-actions">
								<button type="button" class="btn btn-default btn-icon btn-sm" onclick="f_mngrSearch();" ><i class="fa fa-cogs"></i>선택</button>
							</div>
							<h2 class="panel-title">권한 설정</h2>
							<p class="panel-subtitle">
								
							</p>
						</header>
						<div class="panel-body">

							<table class="table table-hover mb-none" id="mngrMapngTable">
								<tbody>
									<c:if test="${empty siteMenuList }">
									<tr class="emptyTr">
										<td>등록된 관리자가 없습니다.</td>
									</tr>
									</c:if>
								</tbody>
							</table>

						</div>
					</section>

				</div>
				
				
				</f:form>
				

			</div>
