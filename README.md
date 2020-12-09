finalproject 
작성자 : 김 종완

----------------------
### 프로젝트명 : MATE
##### 조원 :  박준혁 김가영 김종완 김찬희 박도균 이호근 
----------------------


### 프로젝트 기획 이유
>쇼핑몰이나 음식점및 기업체 등 상품을 다루는 곳에서는 재고를 관리할 수 있는 시스템이 필수적이다.
>
>상품 관리가 가능한 ERP시스템을 구축하고, 지점과 제조사간 소통이 가능한 게시판을 만들어 재고의 순환을 더욱 윤활하게 만들기 원했다.
>
>또한 '키덜트'시장을 겨냥한 쇼핑몰을 구추하고 구현된 ERP시스템을 연동하여 온라인, 오프라인 쇼핑몰의 소통 및 재고관리를 진행하도록 하였다.
-----------------------

### 개발 환경
  
+ 운영 체제 : Window 10  
+ 언어 : Java / Javascript / HTML5 / CSS3 / SQL
+ IDE : STS4
+ DB : Oracle
+ Server : Apache tomcat 8.5
+ Framework / Platform : Maven / Mybatis / Spring framework / Spring security / commons-io

-----------------------

### 주요 테이블  
  
+ MEMBER ( 쇼핑몰 회원 관리용 테이블 )
  + 시스템에 가입되어있는 회원의 정보를 저장하는 테이블
  + member_id COLUMN 을 Primary key로 사용
  
+ EMP ( 관리자 회원 관리용 테이블 )
  + 관리자 회원 정보를 관리하는 테이블 
  + emp_id COLUM 을 Primary key로 사용 
  + STATUS값으로 지점, 제조사, admin회원을 구분할 수 있다. ( 0 = admin, 1 = 지점, 2 = 제조사 )
  
+ PRODUCT ( 상품 정보 관리 테이블 )
  + 취급 상품 정보가 관리되는 테이블
  + PRODUCT_NO COLUMN을 Primary key로 사용
  + ENABLED COLUMN값으로 판매 상태를 결정하도록 한다. ( '0'일 경우 판매, '1'일 경우 판매 중지)
  
+ STOCK ( 상품 재고 관리 테이블 )
  + 각 지점 별 취급 상품의 재고를 관리하는 테이블
  + 각 지점에서 판매를 원하는 상품을 발주시 해당 테이블에 상품의 정보가 입력되며 재고 관리가 가능하게된다.
  + PRODICT_ID와 EMP_ID를 Primary key로 사용
  
+ REQUEST_LOG ( 발주 요청 관리 테이블 )
  + 지점에서 신청한 발주 요청을 관리하는 테이블
  + REQUEST_NO COLUMN을 Primary key로 사용 *제조사 회원이 발주 승인시 CONFIRM COLUMN 값이 '1'로 update되며 동시에 입고 로그 테이블에 해당 상품 정보가 입력되는 Trigger가 실행된다.

+ RECEIVE ( 입고 요청 관리 테이블 )
  + 제조사 회원이 발주 요청 승인 시, 실행되는 Trigger에 의해 입고 요청 정보가 입력되는 테이블
  + RECEIVE_NO COLUMN을 Primary key로 사용
  + 지점 회원이 입고 요청 목록을 확인 후, 승인 시 CONFIRM COLUMN 값이 '1'로 update되며 입출고 로그 테이블에 기록되는 Trigger가 실행된다.
  + 입출고 로그 테이블에 입력이 감지되면 그 상태값이 'I'일 경우, 해당 상품과 지점 정보를 통해 상품 재고 테이블의 재고를 update는 Trigger가 실행되며 재고 관리가 가능하다.
  
 
-----------------------

### 주요 기능  (해당 부분은 작성자 본인이 구현한 기능 위주로 작성되었습니다.)
  
+ 상품 등록 및 수정, 삭제
  + 상품 등록 기능및 정보수정, 삭제 기능은 'admin'등급의 회원에게만 제공되는 기능이다.
  + ERP -> 상품 관리 메뉴에서 '상품 등록'버튼 클릭 시 새로운 상품을 등록할 수 있는 form이 제공되며 양식에 맞춰 정보를 입력 후, form을 제출하면 새로운 상품이 product테이블에 등록된다.
  + 상품 등록시 본문에 추가될 내용은 CKEditor를 사용하여 위지윅 방식으로 구현하였으며, 본문에 노출될 이미지는 별도의 저장소를 통해 저장되도록 하였다.
  ```java
  //상품 등록 Controller
  @RequestMapping(value = "/ERP/productEnroll.do",
					method = RequestMethod.POST)
	public String productEnroll(Product product,
								@RequestParam("upFile") MultipartFile[] upFiles,
								@RequestParam(value = "content", defaultValue = "내용을 입력해 주세요.") String content,
								@RequestParam("imgDir") String imgDir,
								HttpServletRequest request,
								RedirectAttributes redirectAttr) throws Exception {
		try {
			//Content내 img태그 -> 저장 폴더명 변경
			if(!content.equals("내용을 입력해 주세요.")) {
				String repCont = content.replaceAll("temp", imgDir);
				product.setContent(repCont);
			}else {
				product.setContent(content);
			}
			
			//썸네일로 사용할 이미지 저장
			List<ProductMainImages> mainImgList = new ArrayList<>();
			String saveDirectory = request.getServletContext().getRealPath("/resources/upload/mainimages");
			
				for(MultipartFile upFile : upFiles) {
					
					//파일을 선택하지 않고 전송한 경우
					if(upFile.isEmpty()) {
						//섬네일 이미지는 반드시 필요하기 때문에 제출하지 않은 경우 에러넘겨줘야됨.
						throw new Exception("파일을 첨부해 주세요.");
					}
					//파일을 첨부하고 전송한 경우 
					else {
						//1.1  파일명(renamdFilename) 생성
						String renamedFilename = Utils.getRenamedFileName(upFile.getOriginalFilename());
						
						//1.2 메모리(RAM)에 저장되어있는 파일 -> 서버 컴퓨터 디렉토리 저장 tranferTo
						File dest = new File(saveDirectory, renamedFilename);
						upFile.transferTo(dest);
						
						//1.3 ProductMainImages객체 생성
						ProductMainImages mainImgs = new ProductMainImages();
						mainImgs.setOriginalFilename(upFile.getOriginalFilename());
						mainImgs.setRenamedFilename(renamedFilename);
						mainImgList.add(mainImgs);
						
					}
					
				}
			
			//Product객체에 MainImages객체를 Setting
			product.setPmiList(mainImgList);
			
			//ProductImage 임시 저장 폴더
			String tempDir = request.getServletContext().getRealPath("/resources/upload/temp");
			//ProductImage 저장 폴더
			String realDir = request.getServletContext().getRealPath("/resources/upload/" + imgDir);
			File folder1 = new File(tempDir);
			File folder2 = new File(realDir);
			
			List<String> productImages = new ArrayList<>();
			//Content에 Image파일이 있을 경우 (temp폴더내 파일이 저장되었을 경우)
			if(folder1.listFiles().length > 0) {
				//productImage객체 생성 후 DB에 저장
				productImages = FileUtils.getFileName(folder1);
				product.setProductImagesName(productImages);
			}
			
			//DB에 Product insert
			int result = erpService.productEnroll(product);
			
			//product입력 시, file입력 처리 -> DB에 image등록과 동시에 fileDir옮기기  
			if(result > 0) {
				//folder1의 파일 -> folder2로 복사
				FileUtils.fileCopy(folder1, folder2);
				//folder1의 파일 삭제
				FileUtils.fileDelete(folder1.toString());
				redirectAttr.addFlashAttribute("msg", "상품 추가 완료");
			}else {
				//folder1의 파일 삭제
				FileUtils.fileDelete(folder1.toString());
				redirectAttr.addFlashAttribute("msg", "상품 추가 실패");
			}
			
			return "redirect:/ERP/searchInfo.do";
			
		}catch(Exception e) {
			e.printStackTrace();
			redirectAttr.addFlashAttribute("msg", "페이지 오류 발생, 확인 후 다시 시도해주세요!");
			return "redirect:/ERP/searchInfo.do";
		}
	}
  ```
+ CKeditor
  + 위지윅 에디터인 CKeditor API를 적용하여 이미지를 적용할 필요가 있는 본문영역에는 에디터를 구현하도록 하였다.
  + 우선 에디터를 통하여 저장된 이미지는 임시 저장소에 저장된 뒤, form 제출이 완료가 되면 서버에 마련된 별도의 저장소로 해당 이미지를 옮기는 방식으로 진행된다.
  + form제출이 정상적으로 처리가 되지않거나, 취소버튼을 클릭하면 임시 저장소의 파일들이 삭제가되며 이미지또한 저장되지않도록 처리되어있다.
  ```java
  //CKeditor 파일 업로드
	@RequestMapping(value = "/imageFileUpload.do", method = RequestMethod.POST)
	@ResponseBody
	public String fileUpload(HttpServletRequest request, HttpServletResponse response,
							 MultipartHttpServletRequest multiFile) throws Exception {
		request.setCharacterEncoding("utf-8");
		JsonObject json = new JsonObject();
		PrintWriter printWriter = null;
		OutputStream out = null;
		MultipartFile file = multiFile.getFile("upload");
		
		//파일이 넘어왔을 경우
		if(file != null) {
			if(file.getSize() > 0 ) {
				//이미지 파일 검사
				if(file.getContentType().toLowerCase().startsWith("image/")) {
					try {
						String fileName = Utils.getRenamedFileName(file.getOriginalFilename());
						byte[] bytes = file.getBytes();
						String uploadPath = request.getServletContext().getRealPath("/resources/upload/temp");
						File uploadFile = new File(uploadPath);
						if(!uploadFile.exists()) {
							uploadFile.mkdirs();
						}
						out = new FileOutputStream(new File(uploadPath, fileName));
						out.write(bytes);
						
						printWriter = response.getWriter();
						response.setContentType("text/html");
						String fileUrl = request.getContextPath() + "/resources/upload/temp/" + fileName;
						
						//json 데이터로 등록
						json.addProperty("uploaded", 1);
						json.addProperty("fileName", fileName);
						json.addProperty("url", fileUrl);
						
						printWriter.println(json);
						
					} catch(IOException e) {
						e.printStackTrace();
					} finally {
						if(out != null)
							out.close();
						if(printWriter != null)
							printWriter.close();
					}
				}
			}
		}
		//파일이 넘어오지 않았을 경우
		return null;
	}
  ```
+ 발주및 입고 요청 처리
	+ 발주요청과 입고 요청의 처리는 비동기 요청 처리 (AJAX) 방식으로 처리된다.
	+ 발주 요청 처리는 회원 등급이 '제조사'등급인 회원만 이용 가능한 기능이며, 입고 요청처리는 'admin'과 '지점'등급 회원이 이용 가능한 기능이다.
	+ 해당 페이지 진입 시 해당 회원의 정보를 참조, 각각 발주 테이블의 데이터와 입고 테이블의 데이터를 조회하게된다.
	+ 요청 승락과 거절은 해당 테이블의 confirm컬럼값을 변경하는 방식으로 처리가된다.
```javascript
//발주 처리 
function appRequest(no){

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
	
```

-----------------------
### 이 외 구현기능
+ (쇼핑몰)카카오, 네이버 연동 회원가입
+ (쇼핑몰)지도 API연동 오프라인 판매점 위치 확인
+ (쇼핑몰)고객센터
+ (쇼핑몰)장바구니 및 상품 결제 카카오 결제 API
+ (ERP)지점및 제조사 관리
+ (ERP)상품 재고 관리
+ (ERP)현황 조회
