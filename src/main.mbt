///|
fn is_chinese(ch : Char) -> Bool {
  let code = ch.to_int()
  return (code >= 0x4E00 && code <= 0x9FFF) || // CJK 基本汉字
    (code >= 0x3400 && code <= 0x4DBF) || // 扩展A（可选）
    code == 0x3007 // 〇
}

///|
fn is_whitespace(ch : Char) -> Bool {
  return ch == ' ' || ch == '\n' || ch == '\t' || ch == '\r'
}

///|
fn is_english_word_char(ch : Char) -> Bool {
  let is_ascii_letter = ('a' <= ch && ch <= 'z') || ('A' <= ch && ch <= 'Z')
  let is_digit = '0' <= ch && ch <= '9'
  let is_underscore = ch == '_'
  return is_ascii_letter || is_digit || is_underscore
}

///|
fn count_line(path : String) -> Int {
  let mut line = 1
  let context = @fs.read_file_to_string(path) catch {
    error => {
      println("读取文件失败: \{error}")
      return 0
    }
  }
  for i in context {
    if i == '\n' {
      line += 1
    }
  }
  return line
}

///|
fn count_char(path : String) -> Int {
  let mut char = 0
  let context = @fs.read_file_to_string(path) catch {
    error => {
      println("读取文件失败: \{error}")
      return 0
    }
  }
  for _ in context {
    char += 1
  }
  return char
}

///|
fn count_english_words(path : String) -> Int {
  let context = @fs.read_file_to_string(path) catch {
    error => {
      println("读取文件失败: \{error}")
      return 0
    }
  }
  let mut count = 0
  let mut in_word = false
  for ch in context {
    if is_english_word_char(ch) {
      if !in_word {
        count += 1
        in_word = true
      }
    } else {
      in_word = false
    }
  }
  return count
}

///|
fn count_chinese_chars(path : String) -> Int {
  let content = @fs.read_file_to_string(path) catch {
    error => {
      println("读取文件失败: \{error}")
      return 0
    }
  }
  let mut count = 0
  for ch in content {
    if is_chinese(ch) {
      count += 1
    }
  }
  return count
}

///|
fn count_all(path : String) -> (Int, Int, Int, Int, Int) {
  //复用已有的模块化函数
  let char_count = count_char(path)
  let line_count = count_line(path)
  let en_word_count = count_english_words(path)
  let cn_char_count = count_chinese_chars(path)
  let punctuation_count = count_punctuation(path)
  return (
    char_count, line_count, en_word_count, cn_char_count, punctuation_count,
  )
}

///|
fn count_punctuation(path : String) -> Int {
  let content = @fs.read_file_to_string(path) catch {
    error => {
      println("读取文件失败: \{error}")
      return 0
    }
  }
  let mut count = 0
  for ch in content {
    if !is_chinese(ch) && !is_english_word_char(ch) && !is_whitespace(ch) {
      count += 1
    }
  }
  return count
}

///|
fn main {
  let path = "./README.md"
  let (char_count, line_count, en_word_count, cn_char_count, punctuation_count) = count_all(
    path,
  )
  let total_word = en_word_count + cn_char_count
  println("文本字数" + char_count.to_string())
  println("文本行数" + line_count.to_string())
  println("英文单词数" + en_word_count.to_string())
  println("中文字数" + cn_char_count.to_string())
  println("文本单词数" + total_word.to_string())
  println("标点符号数" + punctuation_count.to_string())
}
