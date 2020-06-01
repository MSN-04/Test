<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script type="text/javascript">
	$(function() {
		//$("#table-check1").selectRow({
		//	classname : 'grey'
		//});

		$("#srchKey").on("change", function(){
			if(this.value == "writngDe"){
				$("#srchText").val('').hide();
				$("#srchBeginDt, #srchEndDt").show().datepicker();
			}
			else{
				$("#srchText").show();
				$("#srchBeginDt, #srchEndDt").val('').hide().datepicker('destroy');
			}
		});

		$("#cntPerPage").on("change", function() {
			$("#searchFrm").submit();
		});

		$('#searchFrm').submit(function() {
			if( $("#srchKey").val() == "writngDe" ){
				if($("#srchBeginDt").val() == "" || $("#srchEndDt").val() == ""){
					alert("검색일을 입력하세요.");
					return false;
				}
			}
		});
	});

	$(document).ready(function(){
		if("${param.srchKey}" == "writngDe"){
			$("#srchText").hide();
			$("#srchBeginDt, #srchEndDt").show().datepicker();
		}
		else{
			$("#srchText").show();
			$("#srchBeginDt, #srchEndDt").hide();
		}
	});

	function fnSearchConfmAt(at){
		$("#searchMode").val("CONFM");
		$("#confmAt").val(at);
		$("#searchFrm").submit();
	}

	function fnSearchDeleteAt(at){
		$("#searchMode").val("DELETE");
		$("#deleteAt").val(at);
		$("#searchFrm").submit();
	}

	function f_nttChg(mode, at){
		if($("input:checkbox[name='arrNttNo']:checked").length > 0){

			var deleteTrue = true;
			if(mode == "delete"){
				deleteTrue = confirm("완전 삭제할 경우 복구할 수 없습니다\n삭제하시겠습니까?");
			}

			if(deleteTrue){
				$("#updateMode").val(mode);
				$("#updateAt").val(at);
				$("#searchFrm").attr("action", "./listAction");
				$("#searchFrm").submit();
			}
		}
		else{
			alert("체크박스를 선택해 1개이상 선택해주세요.");
		}
	}
	</script>

		<!-- Start Breadcrumb -->
		<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
			<jsp:param name="pageName" value="게시판 관리"/>
		</jsp:include>
		<!-- End Breadcrumb -->

           <!-- start: page -->
		<div class="row">
			<div class="col-md-12">
			<section class="panel panel-featured panel-featured-primary media-gallery">
				<header class="panel-heading">
					<div class="panel-actions">
						<div class="btn-group">
							<button class="btn btn-default" data-toggle="dropdown">With Selected <span class="caret"></span></button>
							<ul class="dropdown-menu pull-right" role="menu" aria-labelledby="dLabel">
								<c:if test="${listVO.paramMap.searchMode eq 'CONFM' and (empty param.confmAt or param.confmAt eq 'Y')}">
								<li><a tabindex="-1" href="#listUpdate" onclick="f_nttChg('deleteUpdate', 'Y'); return false;"><i class="icon-trash"></i> 게시물 삭제</a></li>
								</c:if>
								<c:if test="${listVO.paramMap.searchMode eq 'CONFM' and param.confmAt eq 'N'}">
								<li><a tabindex="-1" href="#listUpdate" onclick="f_nttChg('confm', 'Y'); return false;"><i class="iconelusive-ok"></i> 게시물 승인</a></li>
								<li><a tabindex="-1" href="#listUpdate" onclick="f_nttChg('deleteUpdate', 'Y'); return false;"><i class="icon-trash"></i> 게시물 삭제</a></li>
								</c:if>
								<c:if test="${listVO.paramMap.searchMode eq 'DELETE'}">
								<li><a tabindex="-1" href="#listUpdate" onclick="f_nttChg('deleteUpdate', 'N'); return false;"><i class="fa fa-repeat"></i> 삭제복구</a></li>
								</c:if>
								<li><a tabindex="-1" href="#listUpdate" onclick="f_nttChg('delete', 'Y'); return false;"><i class="fa fa-trash"></i> 완전 삭제</a></li>
							</ul>
						</div>
					</div>
					<h2 class="panel-title">[${bbsSettingVO.bbsSj}] 게시판 목록</h2>
					<p class="panel-subtitle">
						총 ${listVO.totalCount}건
					</p>
				</header>
				<div class="panel-body">

					<ul id="myTab" class="nav nav-tabs">
						<li <c:if test="${empty param.deleteAt or param.deleteAt eq 'N'}">class="active"</c:if>><a href="#" onclick="fnSearchDeleteAt('N'); return false;" data-toggle="tab">일반 게시물(${bbsSattusMap.deleteN}건)</a></li>
						<li <c:if test="${param.deleteAt eq 'Y'}">class="active"</c:if>><a href="#" onclick="fnSearchDeleteAt('Y'); return false;" data-toggle="tab">비공개 게시물(${bbsSattusMap.deleteY}건)</a></li>
					</ul>
					<div class="panel-body">
						<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
							<input type="hidden" name="bbsTy" id="bbsTy" value="${bbsSettingVO.bbsTy}" />
							<input type="hidden" name="bbsNo" id="bbsNo" value="${bbsSettingVO.bbsNo}" />
							<input type="hidden" id="searchMode" name="searchMode" value="${param.searchMode}" />
							<input type="hidden" id="confmAt" name="confmAt" value="${param.confmAt}" />
							<input type="hidden" id="deleteAt" name="deleteAt" value="${param.deleteAt}" />
							<input type="hidden" id="updateMode" name="updateMode" />
							<input type="hidden" id="updateAt" name="updateAt" />

							<div class="form-group">
	                    		<div class="form-inline ml-md">
	                    			<c:if test="${bbsSettingVO.ctgryUseAt eq 'Y'}">
										<select id="srchCtgry" name="srchCtgry" class="form-control">
											<option value="">카테고리</option>
											<c:forEach items="${bbsSettingVO.ctgryList}" var="ctgry">
											<option value="${ctgry.ctgryNo}" <c:if test="${ctgry.ctgryNo == param.srchCtgry }">selected</c:if>>${ctgry.ctgryNm}</option>
											</c:forEach>
										</select>
	                                </c:if>
	                                	<select id="cntPerPage" name="cntPerPage" class="form-control">
											<c:forEach begin="6" end="30" step="6" var="value">
												<option value="${value}" <c:if test="${param.cntPerPage eq value || (empty param.cntPerPage && bbsSettingVO.nttListOutptCo eq value)}">selected="selected"</c:if>>${value}</option>
											</c:forEach>
	                                	</select>
										<select id="srchKey" name="srchKey" class="form-control">
	                                		<option value="sj" <c:if test="${param.srchKey eq 'sj' || param.srchKey eq ''}">selected="selected"</c:if>>제목</option>
	                                		<option value="cn" <c:if test="${param.srchKey eq 'cn'}">selected="selected"</c:if>>내용</option>
	                                		<option value="ctrtNm" <c:if test="${param.srchKey eq 'ctrtNm'}">selected="selected"</c:if>>작성자</option>
	                                		<option value="writngDe" <c:if test="${param.srchKey eq 'writngDe'}">selected="selected"</c:if>>작성일</option>
	                                	</select>
	                                    <input type="text" id="srchText" name="srchText" value="${param.srchText}" class="form-control">
	                                    <button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
	                        	</div>
	                        </div>

							<div class="row mg-files" >
								<c:forEach items="${listVO.listObject}" var="movList" varStatus="status">
								<c:set var="imgList" value="${cmsFn:getImageSrcs(movList.cn)}"/>
									<div class="col-sm-6 col-md-4 col-lg-3">
										<div class="thumbnail">
											<div class="thumb-preview">												
												<cmsBtn:view bbsSettingVO="${bbsSettingVO}" detailMap="${listVO.listObject[status.index]}" admin="true" cssClass="thumb-image">
												<c:choose>
						                        	<c:when test="${imgList.size() > 0 }">
						                          		<img src="${imgList[0]}" alt="썸네일이미지" style="width: 240px;height: 160px;"/>
						                        	</c:when>
						                        	<c:otherwise>
						                        		<img src="/comm/getImage?srvcId=BBSTY4&amp;upperNo=${movList.nttNo}&amp;fileTy=ATTACH&amp;fileNo=${movList.thumbFileNo}&amp;thumbTy=M" class="img-responsive" alt="썸네일이미지" style="width: 240px;height: 160px;"/>
						                        	</c:otherwise>
						                        </c:choose>
						                        </cmsBtn:view>
											</div>											
											<h5 class="mg-title text-weight-semibold">
												<span class="checkbox-custom checkbox-text-primary">
												<input type="checkbox" data-style="checkbox" id="arrNttNo${status.index}" name="arrNttNo" value="${movList.nttNo}" />
												<label></label>
												</span>
												${fn:substring(movList.sj, 0, 20)}${fn:length(movList.sj) > 20? '...':'' }
											</h5>
											<div class="mg-description">
												<small class="pull-left text-muted">${movList.wrter}</small>
												<small class="pull-right text-muted">${cmsFn:convertDate(movList.writngDe, 'yyyy.MM.dd') }</small>
											</div>
										</div>
									</div>
								</c:forEach>
							</div>
							<c:if test="${empty listVO.listObject}">
							 	<div style="font-size:12px; padding-top:50px; text-align:center;">등록된 데이터가 없습니다.</div>
							</c:if>
						</form>
					</div>
				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-7">
							<cms:paging listVO="${listVO}" />
						</div>
						<div class="col-sm-5">
							<div class="btns">
								<cmsBtn:insert bbsSettingVO="${bbsSettingVO}" admin="true" cssClass="btn btn-primary">게시물 등록</cmsBtn:insert>
							</div>
						</div>
					</div>
				</footer>
			</section>
			</div>

		</div>
