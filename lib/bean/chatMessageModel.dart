/**
 * DESC: 聊天内容
 * Author：原哥
 * QQ: 2729404527
 * Email: 2729404527@qq.com
 */

class ChatMessage {
  //内容
  String messageContent;
  //类型 0发送 1接收
  int messageType;
  //发送者
  String fromUser;
  //接收者
  String toUser;
  //记录时间
  String recordTime;

  ChatMessage({this.messageContent, this.messageType,this.fromUser,this.toUser,this.recordTime});
}
