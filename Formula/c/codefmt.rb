class Codefmt < Formula
  desc "Markdown code block formatter"
  homepage "https://github.com/1nwf/codefmt"
  url "https://github.com/1nwf/codefmt/archive/refs/tags/0.1.3.tar.gz"
  sha256 "b953401eb793cd23ad74f127fef67bcb8acb222476ec5d7ea2480e8df4e998f1"
  license "MIT"
  head "https://github.com/1nwf/codefmt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afbdb181b63215c1457cbcc67b9fd2d2f95573116e10d74ba3e4b6a9ae5d8e37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93d5eef92d72bc2d9a755cf54fa0d3952aeaa48651df65067e6e5a3f1d58eaf5"
    sha256 cellar: :any_skip_relocation, ventura:       "cdfb3964ac613eb6d2e1c1c0e87792aa5d095b40ca198ae1b80b8d4d87ba89ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b31be5466779a921f035a7956842e2cdc3de80179705e649989e42988aa825"
  end

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
