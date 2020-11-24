package com.kh.mate.common;

public class Paging {
	

	public static String getPageBarHtml(int cPage, int numPerPage, int totalContents, String url) {
		StringBuilder pageBar = new StringBuilder();
		//cPage앞에 붙을 구분자를 지정
		char delim = url.indexOf("?") > -1 ?'&':'?';
 		url = url +delim;
		int pageBarSize = 5; //페이지바에 나열될 페이지 번호의 갯수 
		// 118 -> 한페이지당 10개  => 118/10 =>
		int totalPage = (int)Math.ceil(totalContents/numPerPage);
		// cPage * pageBarSize + 1
		//1 2 3 4 5 => 1 0 
		// 6 7 8 9 10 => 6
		// 11 12 13 14 15 => 11
		// 수학 공식 규칙을 찾아야 함 ~!~!
		int pageStart = ((cPage-1) / pageBarSize) * pageBarSize + 1;

		int pageEnd = (pageStart + pageBarSize) -1;
		int pageNo = pageStart;
		
		// 이전
		if(pageNo == 1) {
			
		}else {
			pageBar.append("<a href='"+url+"cPage="+(pageNo-1)+"'>이전</a>\n");
		}
		
		//PageNo
		while(pageNo <= pageEnd && pageNo <=totalPage) {
			//현재페이지인 경우
			if(pageNo==cPage) {
				pageBar.append("<span class='cPage' style='background-color:#F2F2F2;'>"+pageNo+"</span>\n");
			}
			//현재페이지가 아닌경우
			else {
				pageBar.append("<a href='"+url+"cPage="+pageNo+"'>"+pageNo+"</a>\n");
			}
			pageNo++;
			
		}
		
		//다음
		if(pageNo > totalPage ) {
			
		}else {
			pageBar.append("<a href='"+url+"cPage="+pageNo+"'>다음</a>\n");
		}
		
		return pageBar.toString();
	}

}
