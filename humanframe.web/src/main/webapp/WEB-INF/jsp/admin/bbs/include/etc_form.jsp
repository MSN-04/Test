<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<c:if test="${bbsSettingVO.etcIemAt eq 'Y'}">
	<c:forEach items="${boardEtcItemList}" var="list">
	<c:if test="${list.useAt eq 'Y'}">
	<tr>
		<th>${list.etcIemNm}<c:if test="${list.essntlInputAt eq 'Y'}"> <span class="required">*</span></c:if></th>
		<td colspan="3" class="left">
			<span>
			<c:choose>
				<c:when test="${list.dataInputTy eq 'select' }">
					<select name="etcInputIem${list.etcIemNo}" id="etcInputIem${list.etcIemNo}" class="form-control">
						<option value="">선택</option>
						<c:forEach items="${list.itemExList }" var="itemExList">
						<option value="${itemExList.etcIemExNm }" <c:if test="${list.etcInputIem eq  itemExList.etcIemExNm}">selected="selected"</c:if>>${itemExList.etcIemExNm }</option>
						</c:forEach>
					</select>
				</c:when>
				<c:when test="${list.dataInputTy eq 'radio' }">
					<div class="radio-group">
						<c:forEach items="${list.itemExList }" var="itemExList">
							<span class="radio-custom radio-inline radio-primary">
								<input type="radio" name="etcInputIem${list.etcIemNo}" id="etcInputIem${list.etcIemNo}_${itemExList.etcIemExNm }"  class="form-control" value="${itemExList.etcIemExNm }" <c:if test="${list.etcInputIem eq  itemExList.etcIemExNm}">checked="checked"</c:if>><label for="etcInputIem${list.etcIemNo}_${itemExList.etcIemExNm }">${itemExList.etcIemExNm }</label>
							</span>
						</c:forEach>
					</div>
				</c:when>
				<c:when test="${list.dataInputTy eq 'checkbox' }">
					<div class="control-group">
						<c:forEach items="${list.itemExList }" var="itemExList">
							<span class="checkbox-custom checkbox-text-primary checkbox-inline">
								<input type="checkbox" name="etcInputIem${list.etcIemNo}" id="etcInputIem${list.etcIemNo}_${itemExList.etcIemExNm }" value="${itemExList.etcIemExNm }" <c:if test="${fn:indexOf(list.etcInputIem, itemExList.etcIemExNm) > -1}">checked="checked"</c:if> class="form-control"><label for="etcInputIem${list.etcIemNo}_${itemExList.etcIemExNm }">${itemExList.etcIemExNm }</label>
							</span>
						</c:forEach>
					</div>
				</c:when>
				<c:when test="${list.dataInputTy eq 'text' }">
					<input type="text" name="etcInputIem${list.etcIemNo}" id="etcInputIem${list.etcIemNo}" value="${list.etcInputIem}" class="form-control"/>
					<c:if test="${list.bbsNo eq 407}">
						<c:choose>
							<c:when test="${list.etcIemNo eq 1}">ex) 사하구 당리동 일부</c:when>
							<c:when test="${list.etcIemNo eq 4}">ex) 2017.01.23(수) 22:00 ~ 익일 06:00</c:when>
							<c:when test="${list.etcIemNo eq 5}">ex) 20170123 (8자리로 입력 안하면 홈페이지 메인화면에서 조회 불가)</c:when>
						</c:choose>
					</c:if>
				</c:when>
				<c:when test="${list.dataInputTy eq 'textarea' }">
					<textarea rows="10" cols="10" name="etcInputIem${list.etcIemNo}" id="etcInputIem${list.etcIemNo}" class="form-control" >${list.etcInputIem}</textarea>
				</c:when>
			</c:choose>
			</span>
		</td>
	</tr>
	</c:if>
	</c:forEach>
	</c:if>