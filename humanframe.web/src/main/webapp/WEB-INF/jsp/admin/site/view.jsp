<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
			<script>
			function f_useAtChg(at){
				$.ajax({
					type : "post",
					url: './useAtChg',
					data: 'siteNo=${siteVO.siteNo}&useAt='+at,
					dataType: 'text', //전송받을 데이터의 타입
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					success: function(data) {
						if(data=="true"){
							alert("사용여부가 변경되었습니다.");
							location.reload();
						}else{
							alert("상태 변경에 실패하였습니다\n\n잠시후 다시 시도해 주시기 바랍니다.");
						}
					},
					error: function(data, status, err) {
						console.log('error forward : ' + data);
					}
				});

			}

			function f_callbackAdminList(sn, mn){

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
							$("#mngrMapngTable tbody").append("<tr><td>"+inputMngrId+mngrNm+"</td><td>"+ mngrDept +"</td></tr>");
		                });
						if(data.length < 1){
							$("#mngrMapngTable").append("<tr class=\"emptyTr\"><td>등록된 관리자가 없습니다.</td></tr>");
						}
					},
					error: function(data, status, err) {
					}
				});
			}

			$(function() {

				f_callbackAdminList("${siteVO.siteNo}", "");

			});
			</script>



			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="사이트 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-9 p-none">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">사이트 상세</h2>
						<p class="panel-subtitle">

						</p>
					</header>
					<div class="panel-body">



						<table class="table">
							<colgroup>
								<col style="width:150px"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>사이트 분류</th>
									<td>${siteVO.clCodeNm}</td>
								</tr>
								<tr>
									<th>사이트명</th>
									<td>${siteVO.siteNm}</td>
								</tr>
								<tr>
									<th>사이트 URL</th>
									<td>http://${siteVO.siteUrl}/<c:if test="${siteVO.firstUriDivYn eq 'Y' }">${siteVO.firstUri}/</c:if></td>
								</tr>
								<tr>
									<th>사이트 스킨</th>
									<td>${siteVO.siteSkn }</td>
								</tr>
								<tr>
									<th>사이트 언어</th>
									<td>${siteVO.langCodeNm }</td>
								</tr>
								<tr>
									<th>사이트 설명</th>
									<td>${siteVO.siteDc }</td>
								</tr>
								<tr style="display:none;">
									<th>GNB메뉴</th>
									<td>
										<c:if test="${siteVO.mnmnuUseAt eq 'Y'}">사용</c:if>
										<c:if test="${siteVO.mnmnuUseAt eq 'N'}">사용안함</c:if>
									</td>
								</tr>
								<tr style="display:none;">
									<th>LNB메뉴</th>
									<td>
										<c:if test="${siteVO.sbmnuUseAt eq 'Y'}">사용</c:if>
										<c:if test="${siteVO.sbmnuUseAt eq 'N'}">사용안함</c:if>
									</td>
								</tr>
								<tr>
									<th>Meta tag(공통)</th>
									<td>${siteVO.metaTag }</td>
								</tr>
								<tr>
									<th>구글 접속통계 KEY</th>
									<td>${siteVO.googleKey}</td>
								</tr>
								<tr>
									<th>네이버 접속통계 KEY</th>
									<td>${siteVO.naverKey}</td>
								</tr>
								<tr>
									<th>지도 API</th>
									<td>${mapTyCode[siteVO.mapTy]}</td>
								</tr>
								<tr>
									<th>만족도 조사 사용여부</th>
									<td>${useAtCode[siteVO.stsfdgUseAt]}</td>
								</tr>
								<tr>
									<th>코멘트 사용여부</th>
									<td>${useAtCode[siteVO.cmUseAt]}</td>
								</tr>
								<tr>
									<th>담당자 사용여부</th>
									<td>${useAtCode[siteVO.mnuChargerUseAt]}</td>
								</tr>
								<tr>
									<th>사용여부</th>
									<td>
										<c:if test="${siteVO.useAt eq 'Y'}">사용</c:if>
										<c:if test="${siteVO.useAt eq 'N'}">사용안함</c:if>
									</td>
								</tr>
							</tbody>
						</table>

					<!--테이블-->


					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="curPage=${param.curPage }&amp;srchKey=${param.srchKey}&amp;srchText=${param.srchText}&amp;srchClCodeId=${param.srchClCodeId}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
								<a href="./menu/form?siteNo=${siteVO.siteNo}" class="btn btn-success">메뉴 관리</a>
							</div>
							<div class="col-sm-6 text-right">
								<cmsBtn2:btn btnTy="modify" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?siteNo=${siteVO.siteNo}&amp;${pageParam}">수정</cmsBtn2:btn>
								<c:if test="${siteVO.useAt eq 'Y'}">
								<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('N'); return false;" useAt="N" >사용안함</cmsBtn2:btn>
								</c:if>
								<c:if test="${siteVO.useAt eq 'N'}">
								<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('Y'); return false;" useAt="Y" >사용</cmsBtn2:btn>
								</c:if>

							</div>
						</div>
					</footer>
				</section>
				</div>

				<div class="col-md-3 pr-none">

				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">사이트 관리자</h2>
						<p class="panel-subtitle"></p>
					</header>
					<div class="panel-body">
						<table class="table" id="mngrMapngTable">
							<tr class="emptyTr">
								<td>등록된 관리자가 없습니다.</td>
							</tr>
							</tbody>
						</table>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12">
							</div>
						</div>
					</footer>
				</section>

				</div>

			</div>



            <div id="modal" class="modal hide fade">
                <div class="modal-body">
                    <p>
                    	사이트 사용여부를 <span class="label label-important">사용안함</span>으로 변경시 해당사이트의 접속이 불가능합니다.<br />
                    	반드시 확인후 변경하시기 바랍니다.<br /><br />
                    	상태를 변경하시겠습니까?
                    </p>
                </div>
                <div class="modal-footer">
                    <button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
                    <button class="btn btn-primary" onclick="f_useAtChg('N'); return false;">확인</button>
                </div>
            </div>
