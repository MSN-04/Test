<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<script>

	$(function(){

		$('input[name="processDt"]').datepicker();
		$("#frmPrjctInqry").validate({
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
		    	processCn : {required : true}
		    },
		    messages : {
		    	processCn : { required : "<spring:message arguments='" + $("#processCn").prop("title") + "' code='errors.required'/>"}
		    },
		    submitHandler: function (frm) {

		    	if(grecaptcha.getResponse() == ""){
		    		alert("<spring:message code='alert.author.captcha.check' />");
		    		return;
		    	}

		    	if(confirm("<spring:message code='action.confirm.save'/>")){
		    		frm.submit();
		    	}else{
		    		return false;
		    	}
		    }
		});

	});

	</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="프로그램 문의"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
            <f:form name="frmPrjctInqry" id="frmPrjctInqry" modelAttribute="prjctInqryVO" method="post"  enctype="multipart/form-data" action="./action">
			<f:hidden path="crud" />
			<f:hidden path="inqryNo" />
			<input type="hidden" id="pageParam" name="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}&amp;srchStatus=${param.srchStatus}" />

			<div class="row">
				<div class="col-sm-12">
					<section class="panel panel-featured panel-featured-primary">
						<header class="panel-heading">
							<h2 class="panel-title">프로젝트 문의 상세</h2>
						</header>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-bordered mb-none">
									<colgroup>
										<col style="width:150px"/>
										<col />
										<col style="width:150px"/>
										<col />
									</colgroup>
									<tbody>
									<tr>
										<th>제목</th>
										<td colspan="3">${prjctInqryVO.sj}</td>
									</tr>
									<tr>
										<th>사이트</th>
										<td>${prjctInqryVO.siteNm}</td>
										<th>등록일</th>
										<td>${prjctInqryVO.creatDttm}</td>
									</tr>
									<tr>
										<th>회사명</th>
										<td>${prjctInqryVO.cmpnyNm}</td>
										<th>URL</th>
										<td>${prjctInqryVO.url}</td>
									</tr>
									<tr>
										<th>담당자</th>
										<td>${prjctInqryVO.chargerNm}</td>
										<th>담당부서</th>
										<td>${prjctInqryVO.chargerDept}</td>
									</tr>
									<tr>
										<th>E-mail</th>
										<td>${prjctInqryVO.email}</td>
										<th>연락처</th>
										<td>${prjctInqryVO.tel}</td>
									</tr>
									<tr>
										<th>예산</th>
										<td>${bugetTy[prjctInqryVO.budget]}</td>
										<th>기타</th>
										<td>${prjctInqryVO.etc} 원</td>
									</tr>
									<tr>
										<th>파일첨부</th>
										<td colspan="3">
											<c:forEach var="fileList" items="${prjctInqryVO.fileList }" varStatus="status">
											<img src="/comm/getImage?thumbTy=S&amp;srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }"><br />
											<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)} , 다운로드 : ${fileList.dwldCo}회)</a><br />
											</c:forEach>
										</td>
									</tr>
									<tr>
										<th>문의내용<span class="required">*</span></th>
										<td colspan="3">${prjctInqryVO.cn}</td>
									</tr>
									</tbody>
								</table>
							</div>
						</div>
					</section>

					<section class="panel panel-featured panel-featured-primary">
						<header class="panel-heading">
							<h2 class="panel-title">프로젝트 문의 처리 등록/수정</h2>
						</header>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-bordered mb-none">
									<colgroup>
										<col style="width:120px"/>
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th>처리상태</th>
											<td>
											<f:select path="processSttus" cssClass="form-control">
											<f:options items="${statusCode }"/>
											</f:select>
											<th>처리일</th>
											<td><f:input path="processDt" cssClass="form-control" placeholder="처리일" title="처리일" /></td>
										</tr>
										<tr>
											<th>처리내용<span class="required">*</span></th>
											<td colspan="3"><f:textarea path="processCn" style="width:100%;height:200px;" placeholder="처리내용" title="처리내용"/></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<footer class="panel-footer">
							<div class="row">
								<div class="col-sm-6">
									<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}&amp;srchStatus=${param.srchStatus}" />
									<a href="./list?${pageParam}" class="btn btn-default">목록</a>
								</div>
								<div class="col-sm-6 text-right">
									<cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
								</div>
							</div>
						</footer>
					</section>

				</div>
			</div>
			</f:form>