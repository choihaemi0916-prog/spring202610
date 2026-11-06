<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            아이디 : <input v-model="userId">
        </div>
        <div>
            비밀번호 : <input type="password" v-model="pwd1">
        </div>
        <div>
            비밀번호 확인 : <input type="password" v-model="pwd2">
        </div>
        <div>
            이름 : <input v-model="userName">
        </div>
        <div>
            주소 : <input v-model="addr">
            <button @click="fnAddr">주소검색</button>
        </div>
        <div>본인인증 :
            <span v-if="authFlg == 1"><button @click="fnAuth">문자전송</button></span>
            <span v-else-if="authFlg == 2">
                <input v-model="inputNumber" :placeholder="timer">
                <button @click="fnNumberCheck">인증</button>
            </span>
            <span v-else>인증완료</span>
        </div>
        <div>
            <button @click="fnJoin">가입하기</button>
        </div>      
    </div>
    
</body>
</html>

<script>
    function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn,detBdNmList,bdNm,bdKdcd,siNm,sggNm,emdNm,liNm,rn,udrtYn,buldMnnm,buldSlno,mtYn,lnbrMnnm,lnbrSlno,emdNo){
        console.log("roadFullAddr ==>",roadFullAddr);
        console.log("roadAddrPart1 ==>",roadAddrPart1);
        console.log("engAddr ==>",engAddr);
        window.vueObj.addr = roadFullAddr;
    }

    const app = Vue.createApp({
        data() {
            return {
                userId : "",
                pwd1 : "",
                pwd2 : "",
                userName : "",
                addr : "",
                authNumber : "", 
                inputNumber : "", 
                authFlg : 1,
                timer : "03:00",
                intervalId : null,
                count : 180       
            };
        },
        methods: {
            fnJoin : function () {
                let self = this;
                if(self.userId.length < 5){
                    alert("아이디는 최소 5글자 입니다.");
                    return;
                }
                const regex = /^[a-zA-Z](?=.*\d)[a-zA-Z\d]*$/;
                if(!regex.test(self.userId)){
                    alert("아이디는 영어 소문자+숫자 조합입니다. \n아이디는 영어로 시작해야 합니다.");
                    return;
                }
                if(self.pwd1.length < 8  || self.pwd2.length < 8){
                    alert("비밀번호는 최소 8글자 입니다.");
                    return;
                }               
                const passwordRegex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+~`\-={}[\]:;"'<>,.?/\\|]).{8,20}$/;
                if(!passwordRegex.test(self.pwd1)){
                    alert("비밀번호는 특수문자 필수 포함");
                    return;
                }
                if(self.pwd1 != self.pwd2){
                    alert("비밀번호가 서로 다릅니다.");
                    return;
                }                 
                if(self.userName == "" || self.addr == ""){
                    alert("필수값은 모두 입력해주세요!");
                    return;
                }
                if(self.authFlg !== 3){
                    alert("본인인증을 완료해주세요.");
                    return;
                }

                let param = {
                    userId : self.userId,
                    pwd1 : self.pwd1,
                    userName : self.userName,
                    addr : self.addr
                };
                $.ajax({
                    url: "http://localhost:8080/user/add.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("가입되었습니다");
                        location.href="login.do";
                    }
                });
            },
            fnAddr : function(){
                window.open("addr.do", "addr", "width=500, height=500");
            },
            fnAuth : function(){
                let self = this;
                let param = {};
                $.ajax({
                    url: "http://localhost:8080/send-one",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.res.groupInfo.status == "SENDING"){
                            alert("문자가 전송되었습니다.");
                            self.authNumber = data.authNumber;
                            self.authFlg = 2;
                            
                            // 기존 타이머가 돌고 있다면 초기화 후 재시작
                            if(self.intervalId != null) {
                                clearInterval(self.intervalId);
                            }
                            self.count = 180;
                            self.fnTimer(); // 즉시 1초 표시 갱신
                            self.intervalId = setInterval(self.fnTimer, 1000);
                        } else {
                            alert("문자 전송 실패");
                        }
                    }
                });                
            },
            fnNumberCheck : function(){
                let self = this;
                if(self.authNumber == self.inputNumber){
                    alert("인증되었습니다.!");
                    clearInterval(self.intervalId); // 인증 성공 시 타이머 정지
                    self.authFlg = 3;
                } else {
                    alert("인증번호를 다시 확인해주세요.");
                }
            },
            fnTimer : function(){
                let self = this;

                if(self.count <= 0){
                    alert("시간초과!");
                    clearInterval(self.intervalId);
                    self.timer = "시간초과";
                    self.authFlg = 1; // 시간 초과 시 다시 문자전송 가능하도록 변경 선택사항
                    return;
                }

                let min = "";
                let sec = "";
                min = parseInt(self.count / 60);
                sec = parseInt(self.count % 60);
                    
                min = min < 10 ? "0" + min : min;
                sec = sec < 10 ? "0" + sec : sec;

                self.timer = min + ":" + sec;
                self.count--;
            }        
        },
        mounted() {
            let self = this;
            window.vueObj = this;
        }
    });

    app.mount('#app');
</script>