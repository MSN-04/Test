<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script type="text/javascript">
	$(document).ready(function(){

		//validator addon
		$("form[id=mngrVO]").validate({
			ignore: "input[type='text']:hidden",
			rules: {
				mngrNm: { required: true},
				deptNm:{ required: true },
				nowPassword:{ required: true, minlength: 4, maxlength:20 },
				newPassword1:{ required: false, equalTo: "#newPassword" },
				useAt:{ required: true },
			},
			messages: {
				mngrNm: { required: "이름을 입력해 주십시요"},
				deptNm: { required: "부서를 선택해 주십시요"},
				nowPassword:{ required: "현재 비밀번호를 입력해 주십시요", minlength: jQuery.validator.format("{0}자 이상 입력해 주십시요"), maxlength: jQuery.validator.format("{0}자 이하로 입력해 주십시요")},
				newPassword1:{ required: "비밀번호 확인을 입력해 주십시요", equalTo: "비밀번호가 일치하지 않습니다." },
				useAt:{ required: "사용여부를 선택해 주십시요" }
			},
			submitHandler: function (frm) {
				frm.submit();
			}
		});


		$('#dupInfoBtn').click(function(){
			var isRegi = $('#dupInfoBtn').attr('data-dp');
			console.log(isRegi);
			if(isRegi == 'N'){
				alert("GPKI연동시 사용 가능합니다.");
				//var pop = window.open("${globalsitedomain}/comm/gpki/request", "pop", "width=390,height=460, scrollbars=no, resizable=yes, location=no, toolbar=no");
			}else{

				$.ajax({
						url: "/admin/mngr/dp/deleteDpcode",
						type: "post",
						data: {
								"dplctCnfirmCode": ''
						},
						cache: false,
						success: function(e) {
								alert('삭제되었습니다.');
								$("#dupInfoBtn").text("인증서 등록");
								$('#dupInfoBtn').attr('data-dp','N');
						}
				});

			}
			return false;
		});

	});

	function f_empSrch(){
		var target ="deptCode|deptNm|empCode|mngrNm";
		window.open("/admin/mng/deptEmp/popup/empList?target="+target, "popEmp", "width=780, height=525");
	}

	function gpkiCallBack(dupInfo) {
	    $.ajax({
	        url: "/admin/mngr/dp/updateDpcode",
	        type: "post",
	        data: {
	            "dplctCnfirmCode": dupInfo
	        },
	        cache: false,
	        success: function(e) {
	            if (e == 1) {
	                alert('등록되었습니다.');
	                $("#dupInfoBtn").text("등록된 인증서 삭제");
					$('#dupInfoBtn').attr('data-dp','Y');
	            }
	        }
	    });

	    return false;
	}
	</script>


				<section class="panel panel-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 닫기</button>
						</div>
						<h2 class="panel-title">개인정보수정</h2>
					</header>
					<div class="panel-body">

	<f:form name="frmMngr" modelAttribute="mngrVO" method="post" action="action" class="form-horizontal">
	<f:hidden path="crud"				/>
	<f:hidden path="uniqueId" 			/>
	<f:hidden path="mngrPassword"		/>
	<f:hidden path="authorTy" />
	<f:hidden path="authorNo" />
	<f:hidden path="confmTy" />
	<f:hidden path="dplctCnfirmCode" />

	<table class="table table-bordered table-striped mb-none">
		<colgroup>
			<col style="width:150px" />
			<col style="width:250px" />
			<col style="width:150px" />
			<col />
		<col />
		<tr>
			<th>관리자구분</th>
			<td colspan="3">
				${authTyNm}
			</td>
		<tr>
		<tr>
			<th>아이디</th>
			<td colspan="3">
				<f:hidden path="mngrId" /> ${mngrVO.mngrId}
			</td>
		</tr>
		<tr>
			<th>이름</th>
			<td colspan="3">
				<div class="col-md-4 col-sm-4 form-group">
				<f:hidden path="empCode" />
				<f:input path="mngrNm" cssClass="form-control" readonly="true" />
				</div>
			</td>
		</tr>
		<tr>
			<th>부서 <span class="required">*</span></th>
			<td colspan="3">
				<div class="form-inline">
					<f:hidden path="deptCode" />
					<input type="text" id="deptNm" name="deptNm" class="form-control" readonly="readonly" value="${mngrVO.deptNm }"/>
					<button class="btn btn-default" id="dept_checker" onclick="f_empSrch(); return false;" >직원검색</button>
				</div>
			</td>
		</tr>
		<!-- 
		<tr>
			<th>인증서</th>
			<td colspan="3">
				<c:if test="${empty mngrVO.dplctCnfirmCode}">
				<button class="btn btn-info" id="dupInfoBtn" data-dp="N">인증서 등록</button>
				</c:if>
				<c:if test="${!empty mngrVO.dplctCnfirmCode}">
				<button class="btn btn-info" id="dupInfoBtn" data-dp="Y">등록된 인증서 삭제</button>
				</c:if>
			</td>
		</tr>
		 -->
		<tr>
			<th>현재 비밀번호</th>
			<td colspan="3">
				<div class="col-md-4 col-sm-4 form-group">
					<input id="nowPassword" name="nowPassword" type="password" autocomplete="off" maxlength="40" value="" class="form-control form-control">
				</div>
			</td>
		</tr>
		<tr>
			<th>비밀번호<c:if test="${mngrVO.crud == 'CREATE' }"> <span class="required">*</span></c:if></th>
			<td><f:password path="newPassword" cssClass="form-control form-control" autocomplete="off"/></td>
			<th>비밀번호 확인 <c:if test="${mngrVO.crud == 'CREATE' }"> <span class="required">*</span></c:if></th>
			<td><input type="password" name="newPassword1" id="newPassword1" class="form-control" autocomplete="off"></td>
		</tr>
	</table>

	<div class="form-actions">
		<div class="btns">
		<button type="submit" class="btn btn-primary">저장</button>
		</div>
	</div>
	</f:form>

					</div>
				</section>