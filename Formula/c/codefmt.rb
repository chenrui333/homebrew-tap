class Codefmt < Formula
  desc "Markdown code block formatter"
  homepage "https://github.com/1nwf/codefmt"
  url "https://github.com/1nwf/codefmt/archive/refs/tags/0.1.3.tar.gz"
  sha256 "b953401eb793cd23ad74f127fef67bcb8acb222476ec5d7ea2480e8df4e998f1"
  license "MIT"
  head "https://github.com/1nwf/codefmt.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LC_ALL"] = "C"

    input = <<~MARKDOWN
      ```ruby
      puts 'hello'
      ```
    MARKDOWN

    output = pipe_output("#{bin}/codefmt --stdin", input)
    assert_match "```ruby", output
    assert_match "puts 'hello'", output
  end
end
