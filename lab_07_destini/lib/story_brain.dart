import 'story.dart';

class StoryBrain {
  int _storyNumber = 0;

  final List<Story> _storyData = [
    Story(
      storyTitle:
          'Xe của bạn bị xẹp lốp trên một con đường vắng. Bạn quyết định đi nhờ xe. Một chiếc xe tải màu gỉ sét dừng lại bên cạnh bạn. Một người đàn ông với đôi mắt vô hồn mở cửa xe và hỏi: "Cần đi nhờ không?"',
      choice1: 'Đồng ý đi nhờ. Cảm ơn vì sự giúp đỡ!',
      choice2:
          'Khoan đã, tốt hơn là tôi nên hỏi anh ta trước xem anh ta có phải là kẻ giết người không.',
    ),
    Story(
      storyTitle:
          'Anh ta gật đầu chậm rãi, không bận tâm đến câu hỏi của bạn.',
      choice1: 'Ít nhất anh ta cũng thật thà. Tôi sẽ lên xe.',
      choice2: 'Khoan, tôi biết cách thay lốp xe mà.',
    ),
    Story(
      storyTitle:
          'Khi xe bắt đầu lăn bánh, người tài xế bắt đầu kể về mối quan hệ kỳ lạ giữa anh ta và mẹ mình. Càng nói, ông ta càng trở nên giận dữ. Ông ta yêu cầu bạn mở ngăn đựng găng tay. Bên trong có một con dao dính máu, hai ngón tay bị cắt đứt và một cuốn băng cassette của Elton John. Ông ta với tay về phía ngăn đựng đồ.',
      choice1: 'Tôi thích Elton John! Đưa cuốn băng cassette cho anh ta.',
      choice2: 'Là anh ta hoặc là mình! Bạn chộp lấy con dao và đâm anh ta.',
    ),
    Story(
      storyTitle:
          'Cái gì? Thật là vô lý! Bạn có biết rằng tai nạn giao thông là nguyên nhân tử vong do tai nạn đứng thứ hai ở hầu hết các nhóm tuổi trưởng thành không?',
      choice1: 'Bắt đầu lại',
      choice2: '',
    ),
    Story(
      storyTitle:
          'Khi bạn vượt qua rào chắn và lao xuống vách đá, bạn nghĩ về sự khôn ngoan đáng ngờ khi đâm ai đó trong lúc họ đang lái xe mà bạn đang ngồi trong đó.',
      choice1: 'Bắt đầu lại',
      choice2: '',
    ),
    Story(
      storyTitle:
          'Bạn cùng người tài xế hòa giọng theo bài hát "Can you feel the love tonight". Anh ta đưa bạn đến thị trấn tiếp theo và vẫy tay chào tạm biệt an toàn.',
      choice1: 'Bắt đầu lại',
      choice2: '',
    ),
  ];

  String getStory() {
    return _storyData[_storyNumber].storyTitle;
  }

  String getChoice1() {
    return _storyData[_storyNumber].choice1;
  }

  String getChoice2() {
    return _storyData[_storyNumber].choice2;
  }

  void nextStory(int choiceNumber) {
    if (choiceNumber == 1 && _storyNumber == 0) {
      _storyNumber = 2;
    } else if (choiceNumber == 2 && _storyNumber == 0) {
      _storyNumber = 1;
    } else if (choiceNumber == 1 && _storyNumber == 1) {
      _storyNumber = 2;
    } else if (choiceNumber == 2 && _storyNumber == 1) {
      _storyNumber = 3;
    } else if (choiceNumber == 1 && _storyNumber == 2) {
      _storyNumber = 5;
    } else if (choiceNumber == 2 && _storyNumber == 2) {
      _storyNumber = 4;
    } else if (_storyNumber >= 3) {
      restart();
    }
  }

  void restart() {
    _storyNumber = 0;
  }

  bool buttonShouldBeVisible() {
    return _storyNumber < 3;
  }
}
