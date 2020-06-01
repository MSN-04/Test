<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script type="text/javascript">
	$(document).ready(function(){

		$.validator.addMethod("mngrIdCheck", function (value, element, params) {
			var mngrIdCheck = $("#mngrIdCheck").val()
			if(mngrIdCheck == "Y"){
				return true;
			}else{
				return false;
			}
	    }, $.validator.format("{0}"));
		
		$.validator.addMethod("passwordCk",  function( value, element ) {
			return this.optional(element) ||  /^.*(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/.test(value);
		});

		//validator addon
		$("form[id=mngrVO]").validate({
			ignore: "input[type='text']:hidden",
			rules: {
				authorNo: { required: true},
				deptNm:{ required: true },				
				mngrId: { required: true},
				mngrIdCheck: { required: true,  mngrIdCheck : true},
				newPassword:{ required: false, passwordCk : true, minlength: 8, maxlength:20 },				
				newPassword1:{ required: false, equalTo: "#newPassword" },
				useAt:{ required: true },
			},
			messages: {
				authorNo: { required: "권한을 선택해 주십시요"},
				deptNm: { required: "담당자를 선택해 주십시요"},			
				mngrId: { required: "아이디를 입력해 주십시요"},
				mngrIdCheck: { required: "아이디 중복확인을해 주십시요",  mngrIdCheck : "아이디 중복확인을해 주십시요"},
				newPassword:{ required: "비밀번호를 입력해 주십시요", passwordCk : "비밀번호는 영문자, 숫자, 특수문자 조합을 입력해야 합니다.",
							  minlength: jQuery.validator.format("{0}자 이상 입력해 주십시요"), maxlength: jQuery.validator.format("{0}자 이하로 입력해 주십시요")},
				newPassword1:{ required: "비밀번호 확인을 입력해 주십시요", equalTo: "비밀번호가 일치하지 않습니다." },
				useAt:{ required: "사용여부를 선택해 주십시요" }
			},
			submitHandler: function (frm) {				
				frm.submit();				
			}
		});
	});

	//아이디 중복확인
	function f_mngrIdCheck(){
		if ($("#mngrId").val() != ""){
			if(f_checkId()){
				$.ajax({
					type : "post",
					url: '/admin/mng/mngr/mngrIdCheck',
					data: 'mngrId=' + $("#mngrId").val(),
					//data: $('form').serialize(),
					dataType: 'text', //전송받을 데이터의 타입
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					success: function(data) {
						if(data=="true"){
							$("#mngrIdCheck").val("Y");
							$("#mngrIdCheck-error").remove();
							alert("사용할수 있는 아이디 입니다.");
						}else{
							$("#mngrIdCheck").val("N");
							alert("이미 사용중인 아이디 입니다.");
						}
					},
					error: function(data, status, err) {
					}
				});
			}
		}else{
			alert("사용하실 아이디를 입력해 주십시요.");
		}
	}

	//직원검색>>부서코드|부서명|직원코드|직원명이 들어갈 id를 지정
	function f_empSrch(){
		var target ="deptCode|deptNm|empCode|mngrNm";
		window.open("/admin/mng/deptEmp/popup/empList?se=R&target="+target, "popEmp", "width=780, height=525");
	}

	function f_checkId(){
		 var RegEx = /([a-z0-9]){5,25}$/;

	     if(!RegEx.test( $("#mngrId").val())) {
	         alert("아이디는 5~20자의 영문소문자,숫자만 사용가능합니다.");
	         $("#mberId").focus();
	         return false;
	     }
	     return true;
	}
	</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="CMS관리자"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">

					<f:form name="frmMngr" modelAttribute="mngrVO"  method="post" action="./action" class="form-horizontal form-bordered mb-md">
					<f:hidden path="crud"				/>
					<f:hidden path="uniqueId" 			/>
					<f:hidden path="mngrPassword"		/>

					<header class="panel-heading">
						<h2 class="panel-title">관리자 등록/수정</h2>
					</header>
					<div class="panel-body">
						<table class="table table-bordered mb-none">
							<colgroup>
								<col style="width:130px"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>권한그룹 <span class="required">*</span></th>
									<td>
										<f:select path="authorNo" class="form-control">
											<option value="" selected="selected" >선택하세요</option>
											<c:forEach items="${authorList}" var="authorList">
											<f:option value="${authorList.authorNo}" label="${authorList.authorNm}" />
											</c:forEach>
										</f:select>
										<div></div>
									</td>
								</tr>
								<tr>
									<th>권한등급 <span class="required">*</span></th>
									<td>
										<div class="radio-group">
											<f:radiobuttons path="authorTy" items="${authorTyCode}" element="div class='radio-custom radio-inline radio-primary'"/>
										</div>
									</td>
								</tr>
								<tr>
									<th>아이디 <span class="required">*</span></th>
									<td>
									<div class="form-group">
										<div class="form-inline ml-md">
										<c:if test="${mngrVO.crud == 'CREATE' }">
											<f:input path="mngrId" cssClass="form-control" autocomplete="off"/>
											<button class="btn btn-default" id="mngrId_checker" onclick="f_mngrIdCheck(); return false;">중복확인</button>
											<input type="hidden" id="mngrIdCheck" name="mngrIdCheck" value="N"	/>
										</c:if>
										<c:if test="${mngrVO.crud == 'UPDATE' }">
											<f:hidden path="mngrId" /> ${mngrVO.mngrId}
										</c:if>
										</div>
									</div>
									</td>
								</tr>
								<tr>
									<th>부서 <span class="required">*</span></th>
									<td>
										<div class="form-group">
										<div class="form-inline ml-md">
											<f:hidden path="deptCode" />
											<input type="text" id="deptNm" name="deptNm" class="form-control" readonly="readonly" value="${mngrVO.deptNm }"/>
											<button class="btn btn-default" id="dept_checker" onclick="f_empSrch(); return false;">직원검색</button>
										</div>
										</div>
									</td>
								</tr>
								<tr>
									<th>이름 <span class="required">*</span></th>
									<td>
										<f:hidden path="empCode" />
										<f:input path="mngrNm" cssClass="form-control" readonly="true" autocomplete="off"/>
									</td>
								</tr>

								<tr>
									<th>비밀번호<c:if test="${mngrVO.crud == 'CREATE' }"> <span class="required">*</span></c:if></th>
									<td><f:password path="newPassword" cssClass="form-control" autocomplete="off"/></td>
								</tr>
								<tr>
									<th>비밀번호 확인 <c:if test="${mngrVO.crud == 'CREATE' }"> <span class="required">*</span></c:if></th>
									<td><input type="password" name="newPassword1" id="newPassword1" class="form-control" autocomplete="off"></td>
								</tr>
								<tr>
									<th rowspan="2">비밀번호 틀린횟수</th>
									<td>
										${passCk}						
									</td>									
								</tr>
								<tr>
									<td>
									* 비밀번호 변경시 초기화 됩니다.		
									</td>
								</tr>
								<tr>
									<th>승인여부 <span class="required">*</span></th>
									<td>
										<div class="radio-group">
											<f:radiobuttons path="confmTy" items="${confmTyCode}" element="div class='radio-custom radio-inline radio-primary'"/>
										</div>
									</td>
								</tr>
								<tr>
									<th>사용여부 <span class="required">*</span></th>
									<td>
										<div class="form-inline">
											<f:radiobuttons path="useAt" items="${useAtCode}" element="div class='radio-custom radio-inline radio-primary'"/>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}&amp;srchMediaCodeId=${param.srchMediaCodeId }&amp;targetId=${param.targetId}&amp;mode=${param.mode}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
                                <cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
							</div>
						</div>
					</footer>
					</f:form>
				</section>
				</div>

			</div>