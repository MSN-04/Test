<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script type="text/javascript">
	var _checkboxNm = "chkPblcateNo";
	var checkedCnt = 0;

	$(document).ready(function(){
		var totalCnt = $(":checkbox[name='"+_checkboxNm+"']").length;

		//전체 선택 체크박스 클릭시
		$(":checkbox[name='chkAll']").click(function(){
			var isChecked = $(this).is(":checked");
			$(":checkbox[name='"+_checkboxNm+"']").prop("checked",isChecked);
			$(":checkbox[name='chkAll']").prop("checked",isChecked);
		});

		//리스트 체크박스 클릭시
		$(":checkbox[name='"+_checkboxNm+"']").click(function(){
			checkedCnt = $(":checkbox[name='"+_checkboxNm+"']:checked").length;

			if( totalCnt==checkedCnt ){
				$(":checkbox[name='chkAll']").prop("checked",true);
			}else{
				$(":checkbox[name='chkAll']").prop("checked",false);
			}
		});
	});

	//배포 체크
	function f_Action(){
		var checkedVar = $("input[name='chkPblcateNo']:checked").val();
		if(!checkedVar ) {
			alert("배포할 대상을 선택하여 주십시요");
			return;
		}

		document.frmPblcate.action = "./action";
		document.frmPblcate.submit();
	}

	</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="배포 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<h2 class="panel-title">배포 관리 목록</h2>
						<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
					</header>
					<div class="panel-body">

						<form name="frmListSearch" id="frmListSearch" class="form-horizontal form-bordered mb-md" method="get" action="./list">
							<div class="form-group">
	                    		<div class="form-inline ml-md">
								<select name="srchComptAt" id="srchComptAt" class="form-control">
								<option value=""><spring:message code='form.select.default' /></option>
									<c:forEach items="${comptAtMap}" var="mapComptAt">
									<option value="${mapComptAt.key}"<c:if test="${ mapComptAt.key eq param.srchComptAt }"> selected="selected"</c:if>>${mapComptAt.value}</option>
									</c:forEach>
								</select>
								<button type="submit" class="btn btn-default"><i class="fa fa-search"></i>검색</button>
								</div>
							</div>
						</form>

						<div class="table-responsive">
							<form name="frmPblcate" method="post">
								<input type="hidden" name="curPage" value="${listVO.curPage }"/>
								<input type="hidden" name="srchComptAt" value="${param.srchComptAt }"/>

								<table class="table table-bordered table-hover mb-none">
									<colgroup>
										<col style="width:60px" />
										<col style="width:60px" />
										<col style="width:150px" />
										<col />
										<col style="width:100px" />
										<col style="width:100px" />
										<col style="width:100px" />
										<col style="width:100px" />
									</colgroup>
									<thead>
									<tr>
										<th style="text-align: center;">
											<div class="checkbox-custom chekbox-primary ml-sm">
											<input type="checkbox" name="chkAll" id="chkAllTop" /><label></label>
											</div>
										</th>
										<th style="text-align: center;">번호</th>
										<th style="text-align: center;">사이트명</th>
										<th style="text-align: center;">메뉴명</th>
										<th style="text-align: center;">작업구분</th>
										<th style="text-align: center;">처리상태</th>
										<th style="text-align: center;">요청일</th>
										<th style="text-align: center;">요청자</th>
									</tr>
									</thead>
									<tbody>

										<c:forEach items="${listVO.listObject}" var="pblcate" varStatus="status">
										<tr>
											<td style="text-align: center;">

												<c:if test="${pblcate.comptAt == 'N' }">
												<div class="checkbox-custom chekbox-primary ml-sm">
												<input type="checkbox" name="chkPblcateNo" value="${pblcate.pblcateNo}"/>
												<label></label>
												</div>
												</c:if>
											</td>
											<td style="text-align: center;">${listVO.startNo - status.index }</td>
											<td>${pblcate.siteNm}</td>
											<td>
												<c:choose >
													<c:when test="${pblcate.trgetSeCode == 'M' }">${pblcate.menuNm}</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</td>
											<td style="text-align: center;">${opertSeMap[pblcate.opertSe] }</td>
											<td style="text-align: center;">${comptAtMap[pblcate.comptAt] }</td>
											<td style="text-align: center;"><fmt:formatDate pattern="yyyy-MM-dd" value="${pblcate.requstDttm}" /></td>
											<td style="text-align: center;">${pblcate.rqesterNm}</td>
										</tr>
										</c:forEach>
										<c:if test="${empty listVO.listObject}">
										<tr>
											<td colspan="8" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
										</tr>
										</c:if>
									</tbody>
								</table>
								</form>
							</div>

					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-7">
								<cms:paging listVO="${listVO}" />
							</div>
							<div class="col-sm-5 ">
								<div class="btns">
						    		<a href="#none" class="btn btn-primary" onclick="f_Action();return false;"><strong>처리</strong></a>
								</div>
							</div>
						</div>
					</footer>
				</section>
			</div>