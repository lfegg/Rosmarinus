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
  let mut in_latin_word = false
  for i in context {
    let is_ascii_letter = ('a' <= i && i <= 'z') || ('A' <= i && i <= 'Z')
    let is_digit = '0' <= i && i <= '9'
    let is_underscore = i == '_'
    let is_ascii_alnum = is_ascii_letter || is_digit || is_underscore
    if is_ascii_alnum {
      if !in_latin_word {
        count += 1
        in_latin_word = true
      }
    } else {
      in_latin_word = false
    }
  }
  return count
}

///|
fn count_chinese_chars(path: String) -> Int {
  let content = @fs.read_file_to_string(path) catch {
    error => {
      println("读取文件失败: \{error}")
      return 0
    }
  }
  
  let mut count = 0
  for ch in content {
    let code = ch.to_int()
    if (code >= 0x4E00 && code <= 0x9FFF) ||   // CJK 基本汉字
       (code >= 0x3400 && code <= 0x4DBF) ||   // 扩展A（可选）
       code == 0x3007 {                         // 〇
      count += 1
      
    }
  }
  return count
}

///|
fn main {
  let path = "./README.md"
  let char_count = count_char(path)
  let line_count = count_line(path)
  let en_word_count = count_english_words(path)
  let cn_char_count = count_chinese_chars(path)
  let total_word = en_word_count + cn_char_count
  println("文本字数" + char_count.to_string())
  println("文本行数" + line_count.to_string())
  println("英文单词数" + en_word_count.to_string())
  println("中文字数" + cn_char_count.to_string())
  println("文本单词数" + total_word.to_string())
}
