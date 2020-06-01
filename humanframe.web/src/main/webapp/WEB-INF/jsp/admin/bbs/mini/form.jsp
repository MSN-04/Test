<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	$(document).ready(function(){
	});

	$(function(){
		$("#frmNtt").validate({
			onkeyup: false,
			onclick: false,
			onfocusout: false,
			showErrors:function(errorMap, errorList){
                if(!$.isEmptyObject(errorList)){
                    alert(errorList[0].message);
                    return;
                }
            },
		    rules : {

		    },
		    messages : {

		    },
		    submitHandler: function (frm) {
	    		//validator_numberOfInvalids 0으로 초기화를 해야 submit된다.
	    		validator_numberOfInvalids = 0;

				if($("#crud").val() != "DELETE"){
			    	if(confirm("<spring:message code='action.confirm.save'/>")){

			    		frm.submit();
			    	}else{
			    		return false;
			    	}
				}else{
					if( confirm("<spring:message code='action.confirm.delete' />") ) {
						frm.submit();;
					}else{
						return false;
					}
				}
		    },

		    //validate 에러 확인 callback
		    invalidHandler: function(event, validator) {
				//페이지에서 에러 개수를 저장한다.
				//이를 이용하여 웹필터의 서브밋을 제어하도록 한다.
				//webfilter.js파일에 추가하였으며, webfilterResult.html에서 확인하여 에러가 0이면 submit하고 아니면 하지 않도록 수정함.
				//중용한 변수임.
		    	validator_numberOfInvalids = validator.numberOfInvalids();
				//alert(validator_numberOfInvalids);
		      }
		});

		 $(".save").click(function(){
        	return f_save();
        });
		 $(".delete").click(function(){
	        	return f_delete();
	    });
	})

	function f_save(){

		return true;
	}

	function ntt_list(){
// 		document.frmNtt.action = "./list";
// 		document.frmNtt.submit();
		location.href = "./list?curPage=${curPage}";
	}

	function f_delete(){
			$("#crud").val("DELETE");
		return true;
	}

	</script>
			

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="미니게시판 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<f:form modelAttribute="bbsMiniVO" method="post" name="frmNtt" id="frmNtt" action="./action" enctype="multipart/form-data" cssClass="form-horizontal form-bordered mb-md">
				<f:hidden path="bbsListId" />
				<f:hidden path="crud" />
				<input type="hidden" name="curPage" id="curPage" value="${curPage}"/>

				<div class="col-md-12">

					<section class="panel panel-featured panel-featured-primary">
						<header class="panel-heading">
							<h2 class="panel-title">미니게시판 등록/수정</h2>
						</header>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-bordered table-hover mb-none">
									<colgroup>
										<col width="100"/>
										<col />
									</colgroup>
									<tbody>
									<tr>
										<th>게시판 <span class="required">*</span></th>
										<td><div class="form-inline ml-md">
											<select name="siteNo" class="form-control" onchange="getCtgryList();">
												<option value="0"  <c:if test="${empty bbsMiniVO.siteObject}">selected </c:if>>사이트 선택</option>
												<c:forEach var="site" items="${bbsMiniVO.siteObject}">
													<option value="${site.siteNo}"  <c:if test="${site.siteNo eq bbsMiniVO.siteNo}">selected </c:if>>${site.siteNm}</option>
												</c:forEach>
											</select>
											<select name="ctgryNo" class="form-control" onchange="getBbsList();">
												<option value="0"  <c:if test="${empty bbsMiniVO.ctgryObject}">selected </c:if>>카테고리 선택</option>
												<c:forEach var="ctgry" items="${bbsMiniVO.ctgryObject}">
													<option value="${ctgry.ctgryNo}"  <c:if test="${ctgry.ctgryNo eq bbsMiniVO.ctgryNo}">selected </c:if>>${ctgry.ctgryNm}</option>
												</c:forEach>
											</select>
											<select name="bbsNo" class="form-control">
												<option value="0">게시판 선택</option>
											</select>
											</div>
										</td>
									</tr>
									<tr>
										<th>리스트명 <span class="required">*</span></th>
										<td><div class="form-inline ml-md"><f:input path="name" class="form-control"  maxlength="70"/></div></td>
									</tr>
									<tr>
										<th>목록수 <span class="required">*</span></th>
										<td><div class="form-inline ml-md"><f:input path="listCount" maxlength="2" class="form-control" /></div></td>
									</tr>
									<tr>
										<th>정렬순서 <span class="required">*</span></th>
										<td><div class="form-inline ml-md">
											<select name="sorting1" class="form-control">
												<option value="CREAT_DTTM" <c:if test="${bbsMiniVO.sorting1 eq 'CREAT_DTTM'}">selected</c:if>>생성일</option>
												<option value="SJ" <c:if test="${bbsMiniVO.sorting1 eq 'SJ'}">selected</c:if>>제목</option>
												<option value="UPDT_DTTM" <c:if test="${bbsMiniVO.sorting1 eq 'UPDT_DTTM'}">selected</c:if>>수정일</option>
											</select>
											<select name="sorting2" class="form-control">
												<option value="DESC" <c:if test="${bbsMiniVO.sorting2 eq 'DESC'}">selected</c:if>>DESC</option>
												<option value="ASC" <c:if test="${bbsMiniVO.sorting2 eq 'ASC'}">selected</c:if>>ASC</option>
											</select>
											</div>
										</td>
									</tr>
									<c:if test="${ bbsMiniVO.bbsNo != '' && bbsMiniVO.bbsListId != null }">
									<tr>
										<th>배포경로</th>
										<td>
											/humanframe/global/bbs/json/${bbsMiniVO.bbsNo}_${bbsMiniVO.bbsListId}.json
										</td>
									</tr>
									<tr>
										<th>삽입코드</th>
										<td>
											<p class="text-success font-weight-bold">[minibbs bbsNo="${bbsMiniVO.bbsNo}" bbsListId="${bbsMiniVO.bbsListId}"]</p>
										</td>
									</tr>
									</c:if>
									</tbody>
								</table>
							</div>
						</div>
						<footer class="panel-footer">
							<div class="row">
								<div class="col-sm-6">
									<cmsBtn:list admin="true" cssClass="btn btn-default">목록</cmsBtn:list>
								</div>
								<div class="col-sm-6 text-right">
									<c:if test="${bbsMiniVO.crud eq 'UPDATE'}">
										<button class="btn btn-danger delete" >삭제</button>
									</c:if>
									<button class="btn btn-primary save">저장</button>
								</div>
							</div>
						</footer>
					</section>

				</div>
				</f:form>
			</div>

	<script type="text/javascript">
	$(window).on('load', function(){
		getBbsList();
	});

	function getBbsList(){
		if($("select[name=ctgryNo] option:selected").val() == ""){
			$("select[name=bbsNo]").html("<option value='0'>게시판 선택</option>");
			return false;
		}
		 $.ajax({
		  		dataType : "json",
		  	    type : "POST",
		  	    url : "/admin/bbs/mini/getBbsList.json",
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		  	    // data : "siteNo="+$("select[name=siteNo] option:selected").val()+"&ctgryNo="+$("select[name=ctgryNo] option:selected").val(),
		  	    data : { "siteNo": $("select[name=siteNo] option:selected").val(), "ctgryNo": $("select[name=ctgryNo] option:selected").val() },
		  	    success : function(data) {
		  	    	var html ="<option value='0'>게시판 선택</option>";
		  	    	for(var i = 0 ; i < data.mapList.length ; i++){
		  	    		if("${bbsMiniVO.bbsNo}" != "" && "${bbsMiniVO.bbsNo}" == data.mapList[i].bbsNo){
		  	    			html +="<option value='"+data.mapList[i].bbsNo+"' selected>"+data.mapList[i].bbsSj+"</option>";
		  	    		}else{
		  	    			html +="<option value='"+data.mapList[i].bbsNo+"'>"+data.mapList[i].bbsSj+"</option>";
		  	    		}
		  	    	}
		  	    	$("select[name=bbsNo]").html(html);
				},
				error: function(data, status, err) {
					console.log('error forward : ' + data);
				}
			});
	}

	function getCtgryList(){
		if($("select[name=siteNo] option:selected").val() == ""){
			$("select[name=ctgryNo]").html("<option value='0'>카테고리 선택</option>");
  	    	$("select[name=bbsNo]").html("<option value='0'>게시판 선택</option>");
			return false;
		}
		 $.ajax({
		  		dataType : "json",
		  	    type : "POST",
		  	    url : "/admin/bbs/mini/getCtgryList.json",
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		  	    // data : "siteNo="+$("select[name=siteNo] option:selected").val(),
		  	  	data : { "siteNo": $("select[name=siteNo] option:selected").val() },
		  	    success : function(data) {
		  	    	var html ="<option value='0'>카테고리 선택</option>";
		  	    	for(var i = 0 ; i < data.mapList.length ; i++){
		  	    		if("${bbsMiniVO.ctgryNo}" != "" && "${bbsMiniVO.ctgryNo}" == data.mapList[i].ctgryNo){
		  	    			html +="<option value='"+data.mapList[i].ctgryNo+"' selected>"+data.mapList[i].ctgryNm+"</option>";
		  	    		}else{
		  	    			html +="<option value='"+data.mapList[i].ctgryNo+"'>"+data.mapList[i].ctgryNm+"</option>";
		  	    		}
		  	    	}
		  	    	$("select[name=ctgryNo]").html(html);
		  	    	$("select[name=bbsNo]").html("<option value='0'>게시판 선택</option>");
				},
				error: function(data, status, err) {
					console.log('error forward : ' + data);
				}
			});
	}
	</script>