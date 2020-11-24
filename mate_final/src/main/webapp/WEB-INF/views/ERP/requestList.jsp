<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/><%-- 한글 깨짐 방지 --%>
<jsp:include page="/WEB-INF/views/common/headerE.jsp"/>
<script>
<c:if test="${not empty msg }">	alert("${msg}");</c:if>
</script>
<div class="container">
	<table class="table">
	  <thead class="thead-dark">
	    <tr>
	      <th scope="col">요청 번호</th>
	      <th scope="col">상품명</th>
	      <th scope="col">카테고리</th>
	      <th scope="col">가격</th>
	      <th scope="col">요청 수량</th>
	      <th scope="col">요청 지점명</th>
	      <th scope="col">발주 상태</th>
	      <th scope="col">발주 승인</th>
	      <th scope="col">발주 거부</th>
	    </tr>
	  </thead>
	  <tbody>
	  	<!-- 발주 요청이 있을 경우 -->
	  	<c:if test="${ not empty list }">
	  		<c:forEach items="${list}" var="request" varStatus="vs">
	 	 	<tr>
	  			<td style="text-align:center;">${request.requestNo}</td>
	  			<td>${request.productName}</td>
	  			<td>${request.category}</td>
	  			<td>${request.price}</td>
	  			<td>${request.amount}</td>
	  			<td>${request.empName}</td>
	  			<td>
	  				${request.confirm eq 0 ? '발주 요청' : '발주 거부'}
	  			</td>
	  			<td>
	  				<button type="button" onclick="appRequest(${request.requestNo});">발주 승인</button>
	  			</td>
	  			<td>
	  				<button type="button" onclick="refRequest(${request.requestNo});">발주 거부</button>
	  			</td>
	  		</tr>
	  		</c:forEach>
	  	</c:if>
	  	
	  	<!-- 발주 요청이 없을 경우  -->
	  	<c:if test="${ empty list }">
	  	<tr>
	  		<td colspan="9">발주 요청이 없습니다.</td>
	  	</tr>
	  	</c:if>
	  </tbody>
	</table>
	
		<!-- 페이징 바 -->
	<nav aria-label="..." style="text-align: center;">
		<div class="pageBar">
			<ul class="pagination">
				<c:if test="${not empty pageBar }">
						<li>${ pageBar }</li>
				</c:if>
			</ul>
		</div>
	</nav>
	
</div>
<script>
function appRequest(no){
	console.log(no);
	var confirm_val = confirm("상품을 발주하시겠습니까?");

	if(confirm_val){
		$.ajax({
			url : "${pageContext.request.contextPath}/ERP/appRequest.do",
			data : {
				requestNo : no
			},
			dataType : "json",
			method : "POST",
			success : function(data){
				alert(data.result);
				window.location.reload();
			},
			error : function(xhr, status, err){
				alert("오류가 발생하였습니다.");
				console.log(xhr);	
				console.log(status);	
				console.log(err);	
			}
		});
	}
}
function refRequest(no){
	console.log(no);
	var confirm_val = confirm("발주 요청을 취소하시곘습니까?");

	if(confirm_val){
		$.ajax({
			url : "${pageContext.request.contextPath}/ERP/refRequest.do",
			data : {
				requestNo : no
			},
			dataType : "json",
			method : "POST",
			success : function(data){
				alert(data.result);
				window.location.reload();
			},
			error : function(xhr, status, err){
				alert("오류가 발생하였습니다.");
				console.log(xhr);	
				console.log(status);	
				console.log(err);	
			}
		});
	}
}
</script>

<jsp:include page="/WEB-INF/views/common/footerE.jsp"/>