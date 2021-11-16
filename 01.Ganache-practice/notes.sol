// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
// STUDENT |    ID        |   GRADE
// -----------------------------------
//  Marcos |    77755N    |      5
//  Joan   |    12345X    |      9
//  Maria  |    02468T    |      2
//  Marta  |    13579U    |      3
//  Alba   |    98765Z    |      5

contract notes {
    // 先生のadress
    address public profesor;

    // Constructor
    constructor() public {
        profesor = msg.sender;
    }

    // 生徒のIDと試験のスコアを紐づけるmapping
    mapping(bytes32 => uint256) Grades;

    // Array de los alumnos de pidan revisiones de examen
    // 再試験のリクエストの配列
    string[] revisiones;

    // Eventos
    // イベント
    // 評価対象の学生
    event student_evaluated(bytes32);
    // 再試験イベント
    event event_revision(string);

    // 評価を実施する関数
    function Evaluate(string memory _idStudent, uint256 _grade)
        public
        OnlyProfessor(msg.sender)
    {
        // 生徒IDのハッシュを生成
        bytes32 hash_idStudent = keccak256(abi.encodePacked(_idStudent));
        // 生徒IDのハッシュと評価グレードを紐づける
        Grades[hash_idStudent] = _grade;
        // イベントの発行
        emit student_evaluated(hash_idStudent);
    }

    // 先生が実行可能な機能の制御
    modifier OnlyProfessor(address _address) {
        // 入力値のアドレスが先生のアドレスかどうかを確認
        require(_address == profesor, "この機能を実行する権限がありません.");
        _;
    }

    // 学生の成績を確認
    function ViewGrades(string memory _idStudent)
        public
        view
        returns (uint256)
    {
        // 生徒IDのハッシュを生成
        bytes32 hash_idStudent = keccak256(abi.encodePacked(_idStudent));
        // 生徒IDのハッシュと評価グレードを紐づける
        uint256 grade_student = Grades[hash_idStudent];
        // 成績の表示
        return grade_student;
    }

    // 評価の見直しを要求
    function Revision(string memory _idStudent) public {
        // 学習者のIDを配列に格納
        revisiones.push(_idStudent);
        // イベントを発行する
        emit event_revision(_idStudent);
    }

    // 評価の見直しを要求した学生を確認
    function ViewReviews()
        public
        view
        OnlyProfessor(msg.sender)
        returns (string[] memory)
    {
        // revisionesを返す
        return revisiones;
    }
}
