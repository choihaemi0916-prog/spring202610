<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        #app {
            width: 800px;
            margin: 30px auto;
        }
        table{
            width: 750px;
        }
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }

        #paging {
            text-align: center;
        }
        #paging a{
            margin-right: 6px;
            text-decoration: none;
        }
        #paging .active {
            font-weight: bold;
            color: black;
        }

    </style>
</head>
<body>
    <div id="app">
            <select v-model="page" @change="fnList">
                <option value="">:: 전체 ::</option>
                <option value="5">5</option>
                <option value="10">10</option>
                <option value="15">15</option>
                <option value="20">20</option>
                <option value="25">25</option>
                <option value="30">30</option>
            </select>        
            <table>
                <tr>
                    <!-- <th>선택</th> -->
                    <th><input type="checkbox" @click="fnSelectItem" value="true" v-model="checked"></th>
                    <th>번호</th>
                    <th>제목</th>
                    <th>아이디</th>
                    <th>조회수</th>
                    <th>작성일</th>
                </tr>
                <tr v-for="item in list">
                    <!-- <td><input type="radio" name="board" :value="item.boardNo" v-model="selectItem"></td> -->
                    <td><input @change="fnSelect" type="checkbox" name="board" :value="item.boardNo" v-model="selectItemList"></td>
                    <td>{{item.boardNo}}</td>
                    <td>{{item.title}}</td>
                    <td>{{item.userId}}</td>
                    <td>{{item.cnt}}</td>
                    <td>{{item.cDateTime}}</td>
                </tr>
            </table>
            <div id="paging">
                <a @click="currentPage = item; fnList();" :class="{active : currentPage == item}" href="javascript:;" v-for="item in idx">{{item}}</a>
            </div>
            <div>
                <!-- <button @click="fnRemove">삭제</button> -->
                <button @click="fnRemoveAll">삭제</button>
            </div>
    </div>
	
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
				list : [],
                selectItem : "", // 라디오 버튼으로 삭제할 때
                selectItemList : [], // 체크박스로 삭제할 때
                selectFlg : false,
                checked : false,

                idx : 1, // 페이징 갯수(최대 페이지 수)
                pageSize : 5, // 한페이지에 출력할 개수
                currentPage : 1, // 현재 페이지
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList : function () {
                let self = this;

                let param = {
                    limit : self.pageSize,
                    offset : self.pageSize * (self.currentPage - 1)
                };
                $.ajax({
                    url: "http://localhost:8080/board/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.list = data.list;
                        console.log(data);
                        self.idx = Math.ceil( data.count / self.pageSize );
                    }
                });
            },
            fnRemove : function(){
                let self = this;
                if(self.selectItem == ""){
                    alert("삭제할 게시글을 선택해주세요.");
                    return;
                }
                if(!confirm("정말 삭제???")){
                    return;
                }

                let param = {
                    boardNo : self.selectItem
                };
                $.ajax({
                    url: "http://localhost:8080/board/remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        self.fnList();
                        self.selectItem = "";               
                    }
                });                
            },
            fnRemoveAll : function (){
                let self = this;
                console.log(self.selectItemList);
                if(self.selectItemList.length == 0){
                    alert("삭제할 게시글을 선택해주세요.");
                    return;
                }
                if(!confirm("정말 삭제???")){
                    return;
                }

                let param = {
                    selectItemList : JSON.stringify(self.selectItemList)
                };
                $.ajax({
                    url: "http://localhost:8080/board/remove-all.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        self.fnList();
                        self.selectItemList = [];  
                        self.checked = false;             
                    }
                });                  
            },
            fnSelectItem : function (){
                let self = this;
                self.selectItemList = [];
                // for(let i = 0; i<self.list.length; i++){
                //     self.selectItemList.push(self.list[i].boardNo);
                // }
                if(!self.checked){
                    self.list.forEach(map => {
                        self.selectItemList.push(map.boardNo);
                    });
                } else {
                    self.selectItemList = []; 
                }
            },
            fnSelect : function(){
                let self = this;
                self.checked = self.list.length == self.selectItemList.length;
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
			self.fnList();
        }
    });

    app.mount('#app');
</script>