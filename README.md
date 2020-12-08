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
  

-----------------------
### 이 외 구현기능
+ 회원 가입 및 정보수정, 삭제
+ 수업 등록 및 정보수정, 삭제
+ 내가 신청한 수업 스케줄 보기
+ 고객센터 게시판
+ 관리자 기능 ( 가입 회원 조회및 관리, 이력서 승인 및 거부, 현황 보기 - 매출조회 )
