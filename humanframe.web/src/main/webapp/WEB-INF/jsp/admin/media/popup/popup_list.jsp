<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
		<c:choose>
			<c:when test="${param.srchMediaCodeId eq 'IMAGE'}">
				<c:set var="mediaPopTyNm" value="이미지" />
			</c:when>
			<c:when test="${param.srchMediaCodeId eq 'MOVIE'}">
				<c:set var="mediaPopTyNm" value="동영상" />
			</c:when>
			<c:when test="${param.srchMediaCodeId eq 'MUSIC'}">
				<c:set var="mediaPopTyNm" value="음악" />
			</c:when>
			<c:when test="${param.srchMediaCodeId eq 'ETC'}">
				<c:set var="mediaPopTyNm" value="ETC" />
			</c:when>
			<c:otherwise>
				<c:set var="mediaPopTyNm" value="전체" />
			</c:otherwise>
		</c:choose>
		<script>
		function f_searchUseAt(at){
			$("#useAt").val(at);
			$("#searchFrm").submit();
		}

		function f_setMedia(mediaNo){
			/* if (opener.CKEDITOR.instances.${targetId}.mode == 'wysiwyg' ) { */
				$.ajax({
					type : "post",
					url: '/admin/media/mediaInfo.json',
					data: 'mediaNo=' + mediaNo,
					dataType: 'json',
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					success: function(data) {
						
						if($("#targetId").val() == "cnRelateImage"){
							// 콘텐츠 롤링이미지 위함
							opener.f_insertCnRelateImage(data);
							
						} else {
							
							var insertHtml = "";
							if(data.mediaVO.streMthTy == "FILE"){
								if(data.mediaVO.mediaFileList[0].fileExtsn == "jpg" || data.mediaVO.mediaFileList[0].fileExtsn == "jpeg" || data.mediaVO.mediaFileList[0].fileExtsn == "gif" || data.mediaVO.mediaFileList[0].fileExtsn == "png"){
									var sumry = "";
									if(data.mediaVO.sumry != null){
										sumry = data.mediaVO.sumry.replace(/[\"\']/g, '');
									}else{
										sumry = data.mediaVO.mediaNm;
									}
									insertHtml = "<img src=\"/comm/getImage?srvcId="+ data.mediaVO.mediaFileList[0].srvcId +"&amp;upperNo="+ data.mediaVO.mediaFileList[0].upperNo +"&amp;fileTy="+ data.mediaVO.mediaFileList[0].fileTy +"&amp;fileNo="+ data.mediaVO.mediaFileList[0].fileNo +"\" alt=\""+ sumry  +"\" />";
								}else if(data.mediaVO.mediaFileList[0].fileExtsn == "mp4"){
									insertHtml = "<div style=\"width:600px;\"><video id=\"videoplayer\" preload=\"none\" loop controls style=\" min-width:100%;min-height: 100%;width: auto;height: auto;\">";
									insertHtml = insertHtml + "<source src=\"/comm/getFile?srvcId="+ data.mediaVO.mediaFileList[0].srvcId +"&amp;upperNo="+ data.mediaVO.mediaFileList[0].upperNo +"&amp;fileTy="+ data.mediaVO.mediaFileList[0].fileTy +"&amp;fileNo="+ data.mediaVO.mediaFileList[0].fileNo +"\" type=\"video/mp4\">";
									insertHtml = insertHtml + "Sorry, your browser does not support HTML5 video.";
									insertHtml = insertHtml + "</video></div>";
								}else if(data.mediaVO.mediaFileList[0].fileExtsn == "mp3"){
									insertHtml = "<div style=\"width:600px;\"><audio id=\"audioplayer\" preload=\"none\" loop controls style=\" min-width:100%;min-height: 100%;width: auto;height: auto;\">";
									insertHtml = insertHtml + "<source src=\"/comm/getFile?srvcId="+ data.mediaVO.mediaFileList[0].srvcId +"&amp;upperNo="+ data.mediaVO.mediaFileList[0].upperNo +"&amp;fileTy="+ data.mediaVO.mediaFileList[0].fileTy +"&amp;fileNo="+ data.mediaVO.mediaFileList[0].fileNo +"\" type=\"audio/mp3\">";
									insertHtml = insertHtml + "Sorry, your browser does not support HTML5 audio.";
									insertHtml = insertHtml + "</audio></div>";
								}else{
									insertHtml = "<a href=\"/comm/getFile?srvcId="+ data.mediaVO.mediaFileList[0].srvcId +"&amp;upperNo="+ data.mediaVO.mediaFileList[0].upperNo +"&amp;fileTy="+ data.mediaVO.mediaFileList[0].fileTy +"&amp;fileNo="+ data.mediaVO.mediaFileList[0].fileNo +"\">"+ data.mediaVO.mediaNm +"</a>";
								}
							}else if(data.mediaVO.streMthTy == "HTML"){
								insertHtml = data.mediaVO.mediaHtml;
							}
							
							opener.f_insertMedia(insertHtml);
							
							/* opener에 추가하면 됩니다.
							<a style="margin-bottom:5px;" class="btn" href="/admin/media/popup/list?targetId=cn" target="_blank" onclick="window.open(this.href, 'mediaPopup', 'width=800, height=910'); return false;" >미디어 삽입</a>
							function f_insertMedia(insertHtml){
								smEditor.setVal(에디터id,insertHtml);
							} */
							window.close();	
						} 				
					},
					error: function(data, status, err) {
						//console.log('error forward : ' + data);
					}
				});
			/* } else {
				alert( "위지윅 모드여야 추가 가능합니다" );
			} */
		}

		</script>

	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions">
				<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">미디어 관리 <small>${mediaPopTyNm} 관리</small></h2>
		</header>
		<div class="panel-body">
			<div class="tabs">
				<!-- tap 상단 -->
		        <c:if test="${!empty mediaCodeList}">
                   <ul class="nav nav-tabs">
                   	<li <c:if test="${empty param.srchMediaCodeId}">class="active"</c:if>><a href="./list<c:if test="${!empty param.targetId}">?targetId=${param.targetId}</c:if>">전체</a></li>
                    	<c:forEach items="${mediaCodeList}" var="mediaCodeList">
                    	<li <c:if test="${param.srchMediaCodeId eq mediaCodeList.codeId}">class="active"</c:if>><a href="./list?srchMediaCodeId=${mediaCodeList.codeId}<c:if test="${!empty param.targetId}">&amp;targetId=${param.targetId}</c:if>">${mediaCodeList.codeNm }</a></li>
                    	</c:forEach>
                   </ul>
                </c:if>
				
				<div class="tab-content">
					<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
						<input type="hidden" id="targetId" name="targetId" value="${param.targetId}" />
						<input type="hidden" id="srchMediaCodeId" name="srchMediaCodeId" value="${param.srchMediaCodeId}" />
						<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />
					
						<div class="form-group">
							<div class="form-inline ml-md">			
								<select id="searchKey" name="searchKey" class="form-control">
								<option value="mediaNm" <c:if test="${param.searchKey eq 'mediaNm' || param.searchKey eq ''}">selected="selected"</c:if>>미디어명</option>
								<option value="sumry" <c:if test="${param.searchKey eq 'sumry'}">selected="selected"</c:if>>요약</option>
								</select>
								
								<input type="text" id="searchText" name="searchText" value="${param.searchText}" class="form-control">
								<button type="submit" class="btn btn-default"><i class="fa fa-search"></i>검색</button>
							</div>
						</div>
					</form>
					<section class="media-gallery">
					<div class="row mg-files" data-sort-destination data-sort-id="media-gallery">
						<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
							<c:set var="pageParam" value="mediaNo=${resultList.mediaNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
							<div class="isotope-item document col-sm-6 col-md-6 col-lg-3" style="width:230px; height:210px;" >
								<div class="thumbnail">
									<div class="thumb-preview">
										<a class="thumb-image" href="#">
										<c:if test="${fn:length(resultList.thumbFileList) > 0 }">
											<img src="/comm/getImage?srvcId=${resultList.thumbFileList[0].srvcId }&amp;upperNo=${resultList.thumbFileList[0].upperNo }&amp;fileTy=${resultList.thumbFileList[0].fileTy }&amp;fileNo=${resultList.thumbFileList[0].fileNo }&amp;thumbTy=S"  style="width:230px; height:145px;" class="img-responsive"  />
										</c:if>
										<c:if test="${fn:length(resultList.thumbFileList) == 0 && resultList.mediaCodeId eq 'IMAGE' }">
											<c:if test="${fn:length(resultList.mediaFileList) > 0 }">
				                            	<img src="/comm/getImage?srvcId=${resultList.mediaFileList[0].srvcId }&amp;upperNo=${resultList.mediaFileList[0].upperNo }&amp;fileTy=${resultList.mediaFileList[0].fileTy }&amp;fileNo=${resultList.mediaFileList[0].fileNo }&thumbTy=S"  style="width:230px; height:145px;" class="img-responsive"  />
				                            </c:if>
				                            <c:if test="${fn:length(resultList.mediaFileList) == 0 }">
				                            	<img src="${globalAdminAssets}/images/no_image.jpeg" alt="no_thumb_image" style="width:230px; height:145px;" class="img-responsive" />
				                            </c:if>
										</c:if>
										<c:if test="${fn:length(resultList.thumbFileList) == 0 && resultList.mediaCodeId ne 'IMAGE' }">
											<img src="${globalAdminAssets}/images/no_image.jpeg" alt="no_thumb_image" style="width:230px; height:145px;" class="img-responsive" />
										</c:if>
										</a>								
									
										<div class="mg-thumb-options">
											<c:if test="${fn:length(resultList.mediaFileList) > 0  && resultList.mediaCodeId eq 'IMAGE'}">
		                                    <a class="mg-zoom" title="미리보기 새창" href="/comm/getImage?srvcId=${resultList.mediaFileList[0].srvcId }&amp;upperNo=${resultList.mediaFileList[0].upperNo }&amp;fileTy=${resultList.mediaFileList[0].fileTy }&amp;fileNo=${resultList.mediaFileList[0].fileNo }" target="_blank"><i class="fa fa-search"></i></a>
		                                    </c:if>
		                                    <c:if test="${fn:length(resultList.mediaFileList) > 0  && resultList.mediaCodeId ne 'IMAGE'}">
		                                    <a class="mg-zoom" title="미리보기 새창" href="/comm/getFile?srvcId=${resultList.mediaFileList[0].srvcId }&amp;upperNo=${resultList.mediaFileList[0].upperNo }&amp;fileTy=${resultList.mediaFileList[0].fileTy }&amp;fileNo=${resultList.mediaFileList[0].fileNo }" target="_blank"><i class="fa fa-search"></i></a>
		                                    </c:if>
											<div class="mg-toolbar">
												<div class="mg-option"  onclick="f_setMedia('${resultList.mediaNo}'); return false;">
													<i class="glyphicon glyphicon-download"></i>
													<label for="file_1">소스삽입</label>
												</div>
											</div>
										</div>
									</div>
									<h5>
									<a href="./view?${pageParam}"  title="미디어상세보기">${fn:substring(resultList.mediaNm, 0, 20)}${fn:length(resultList.mediaNm) > 20? '...':'' }</a>
									</h5>
								</div>
							</div>						
	                    </c:forEach>
	                     
		                 <c:if test="${empty listVO.listObject}">
						 	<div style="font-size:12px; padding-top:50px; text-align:center;">등록된 데이터가 없습니다.</div>
						 </c:if>
	                     
	                  </div>
	                  </section>
				</div>
			</div>
		</div>
		<footer class="panel-footer">
			<div class="row">
			<div class="form-group">
				<div class="col-sm-7">
					<cms:paging listVO="${listVO}" />
				</div>
				<div class="col-sm-5  text-right">
					<c:set var="pageParam2" value="curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}&amp;srchMediaCodeId=${param.srchMediaCodeId }&amp;useAt=${param.useAt }&amp;targetId=${param.targetId}" />
                 	<cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?${pageParam2}" >미디어 등록</cmsBtn2:btn>
                </div>
			</div>
			</div>
		</footer>
	</section>
	
