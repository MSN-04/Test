<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

		<script type="text/javascript">
		function f_selectProfile(rowNum) {

			var webpropertyId = $("#webpropertyId_" + rowNum).val();
			var profileId = $("#profile_" + rowNum).val();
			var accessToken = $("#accessToken").val();
			var refreshToken = $("#refreshToken").val();

			//alert(webpropertyId+":"+profileId);

			$("#googleKey", opener.document).val(webpropertyId);
			$("#googleProfileId", opener.document).val(profileId);
			$("#googleAccesTkn", opener.document).val(accessToken);
			$("#googleRefreshTkn", opener.document).val(refreshToken);

			$("#btnOAuth", opener.document).text("인증되었습니다");
			window.close();
		}

		</script>

			<div style="padding:0 10px;">
                <!-- Start Main Content -->
                <div class="row-fluid">
                    <div class="span12">
						<div class="widget dark">
							<div class="widget-head">
								<span class="title">Google Analytics Account Name</span>
							</div>
							<div class="widget-content no-padding" id="siteMenuTree">
								<form name="frmProfile" action="#">
								<input type="hidden" name="accessToken" id="accessToken" value="${accessToken}" />
								<input type="hidden" name="refreshToken" id="refreshToken" value="${refreshToken}" />
								<table class="table table-hover">
								<colgroup>
									<col style="width:80px;" />
									<col />
								</colgroup>
								<thead>
									<tr>
										<th>번호</th>
										<th>계정명 (프로퍼티ID)</th>
									</tr>
									<c:forEach items="${profileList}" var="profile" varStatus="row">
									<tr>
										<td>${row.count}</td>
										<td>
										<a href="#" onclick="f_selectProfile(${row.count})">${profile.accountName} (${profile.webpropertyId})</a>
										<input type="hidden" name="webpropertyId_${row.count}" id="webpropertyId_${row.count}" value="${profile.webpropertyId}" />
										<input type="hidden" name="profile_${row.count}" id="profile_${row.count}" value="${profile.profileId}" />
										</td>
									</tr>
									</c:forEach>
								</table>
								</form>
							</div>
						</div>
                    </div>
                </div><!-- End -->
                <br />
            </div><!-- End Main Content -->