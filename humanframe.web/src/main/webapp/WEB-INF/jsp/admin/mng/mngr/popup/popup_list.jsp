<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script type="text/javascript">
	/* function f_sendCharger(dept,nm,tel){
		opener.f_setCharger(dept,nm,tel);
		window.close();
	} */

	$(document).ready(function(){
		if (typeof opener.mngrCallBack != "function") {
			alert("mngrCallBack() 함수를 정의하세요.");
		}

		if(!$("#mngrHidden", opener.document).length > 0){
			alert("mngrHidden 객체가 없습니다.");
		}

		if(!$("#mngrNm", opener.document).length > 0){
			alert("mngrNm 객체가 없습니다.");
		}

		$("#table-check1").selectRow({
			classname : 'grey'
		});

		/*
		var authorUniqueIds = opener.uniqueIds.value;

		var arrAuthorUniqueIds = authorUniqueIds.split(",");

		for(var i=0; i <arrAuthorUniqueIds.length; i++){
			console.log(arrAuthorUniqueIds[i]);
			$("#arrUniqueId"+arrAuthorUniqueIds[i]).attr("checked",true);
			$("#arrUniqueId"+arrAuthorUniqueIds[i]).parent().attr("class","checked");
			$("#arrUniqueId"+arrAuthorUniqueIds[i]).parent().parent().parent().parent().attr("class","grey");
		}
		*/
	});

	function f_selectMngr(){
		var uniqueIds = "";
		var mngrNames = "";
		$("input[name=arrUniqueId]:checked").each(function() {
			var temp = $(this).val().split("||");
			if(uniqueIds == ""){
				uniqueIds = temp[0];
				mngrNames =  temp[1];
			}else{
				uniqueIds = uniqueIds+","+temp[0];
				mngrNames = mngrNames+","+temp[1];
			}
		});

		//$("#uniqueIds").val(uniqueIds);
		//$("#mngrNames").val(mngrNames);

		$("#mngrHidden",opener.document).val(uniqueIds);
		$("#mngrNm",opener.document).val(mngrNames);

		opener.mngrCallBack();
		self.close();

	}
	</script>

	<!-- Start Main Content -->
            <div style="padding:0 10px;">
                <!-- Start Main Content -->
                <div class="row-fluid">
                    <div class="span12">
						<div class="widget dark">
							<div class="widget-head">
								<span class="title">CMS관리자 리스트</span>
							</div>
							<c:if test="${deptCrud eq 'UPDATE' }">
							<div class="widget-panel">
                                <div class="widget-panel-inner">
                                	<p>이동이 가능한 메뉴만 출력됩니다</p>
                            	</div>
                            </div>
                            </c:if>
							<div class="widget-content no-padding">
								<div class="widget-content-inner">
									<div class="span12" style="padding:10px;">
		                                <form id="searchFrm" name="searchFrm" class="form-search" method="get" action="./mngrList">
											<select id="srchAuthTy" name="srchAuthTy" class="input-small">
		                                		<c:set var="isSelected" value="${ (empty param.srchAuthTy  or param.srchAuthTy eq '') ? ' selected=\"selected\"' : '' }" />
												<option value=""${isSelected}>권한</option>
												<c:forEach var="item" items="${authorTy}">
												<c:set var="isSelected" value="${ (item.key eq param.srchAuthTy) ? ' selected=\"selected\"' : '' }" />
												<option value="${item.key}"${isSelected}>${item.value}</option>
												</c:forEach>
		                                	</select>
		                                	<select id="srchType" name="srchType" class="input-small">
		                                		<option value="deptNm"<c:out value="${ param.srchType eq 'depthNM' ? ' selected=\"selected\"' : '' }" />>부서명</option>
												<option value="mngrNm"<c:out value="${ param.srchType eq 'mngrNm' ? ' selected=\"selected\"' : '' }" />>관리자명</option>
												<option value="mngrId"<c:out value="${ param.srchType eq 'mngrId' ? ' selected=\"selected\"' : '' }" />>아이디</option>
		                                	</select>
		                                    <input type="text" id="srchWord" name="srchWord" value="${param.srchWord}" class="input-medium search-query">
		                                    <button type="submit" class="btn">Search</button>
		                                </form>
		                            </div>

									<!-- Start Selectable Table Row -->
									<form id="listFrm" name="listFrm" method="post">
									<input type="hidden" id="listUseAt" name="listUseAt" value="" />
									<input type="" id="uniqueIds" name="uniqueIds"/>
									<input type="" id="mngrNames" name="mngrNames"/>
									<table class="table table-hover" id="table-check1">
										<colgroup>
											<col style="width:50px;" />
											<!-- <col style="width:60px;" />
											<col style="width:180px;" /> -->
											<col style="width:100px;" />
											<col />
											<col style="width:100px;" />
										</colgroup>
										<thead>
											<tr>
												<th></th>
												<!-- <th>순번</th>
												<th>부서명</th> -->
												<th>관리자명</th>
												<th>아이디</th>
												<th>권한</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${listVO}" var="resultList" varStatus="status">
											<%-- <c:set var="pageParam" value="uniqueId=${resultList.uniqueId}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" /> --%>
											<tr>
												<td><input type="checkbox" data-style="checkbox" id="arrUniqueId${resultList.uniqueId }" name="arrUniqueId" value="${resultList.uniqueId }||${resultList.mngrNm}" /></td>
												<%-- <td>${listVO.startNo - status.index }</td>
												<td>${resultList.deptNm}</td> --%>
												<td>${resultList.mngrNm}</td>
												<td>${resultList.mngrId}</td>
												<td>${authorTy[resultList.authorTy]}</td>
											</tr>
											</c:forEach>
											<c:if test="${empty listVO}">
											<tr>
												<td colspan="7" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
											</tr>
											</c:if>
										</tbody>
									</table>
									</form>
									<!-- End Selectable Table Row -->

									<div class="form-actions">

										<%-- <div class="pagination">
										<cms:paging listVO="${listVO}" />
										</div> --%>

										<div class="btns">
			                                <button onclick="f_selectMngr()" class="btn btn-primary">선택</button>
		                                </div>

	                                </div>
	                            </div>
							</div>
						</div>
                    </div>
                </div><!-- End -->
                <br />
            </div><!-- End Main Content -->

	<%-- <div class="col-md-6 padding-top-10">
		총 <strong>${listVO.totalCount}</strong>개
	</div>
	<div class="col-md-6 margin-bottom-10">
	<form name="frmListSearch" id="frmListSearch" method="get" action="./popup/mngrList">
		<div class="float-right">
			<select name="srchType" id="srchType" class="form-control input-small input-inline">
				<option value="deptNm"<c:out value="${ param.srchType eq 'depthNM' ? ' selected=\"selected\"' : '' }" />>부서명</option>
				<option value="mngrNm"<c:out value="${ param.srchType eq 'mngrNm' ? ' selected=\"selected\"' : '' }" />>관리자명</option>
				<option value="mngrId"<c:out value="${ param.srchType eq 'mngrId' ? ' selected=\"selected\"' : '' }" />>아이디</option>
			</select>
			<input type="text" name="srchWord" id="srchWord" value="${param.srchWord}" class="form-control placeholder-no-fix input-small input-inline"  placeholder="검색어" />
			<button type="submit" class="btn default">검색 <i class="fa fa-search"></i></button>
		</div>
	</form>
	</div>

	<table class="table table-striped table-hover table-bordered text-align-center">
		<colgroup>
			<col style="width:50" >
			<col style="width:100" >
			<col style="width:100" >
			<col style="width:100" >
			<col />
		</colgroup>
		<thead>
		<tr>
			<th class="text-align-center">번호</th>
			<th class="text-align-center">부서명</th>
			<th class="text-align-center">관리자명</th>
			<th class="text-align-center">전화번호</th>
			<th class="text-align-center">선택</th>
		</tr>
		</thead>
		<tbody>
		<c:forEach items="${listVO.listObject}" var="mngr" varStatus="status">
		<tr>
			<td>${listVO.startNo - status.index }</td>
			<td>${mngr.deptNm}</td>
			<td>${mngr.mngrNm}</a></td>
			<td>${mngr.telno}</td>
			<td><a href="#" onclick="f_sendCharger('${mngr.deptNm}','${mngr.mngrNm}','${mngr.telno}');return false;"><span class="label label-sm label-success">선택</span></a></td>
		</tr>
		</c:forEach>
		</tbody>
	</table>

	<!-- 페이징 영역 -->
	<div class="float-left">
		<cms:paging listVO="${listVO}" />
	</div>

	<!-- 버튼 영역 -->
	<div class="float-right">
		<a href="form" class="btn blue">등록</a>
	</div> --%>