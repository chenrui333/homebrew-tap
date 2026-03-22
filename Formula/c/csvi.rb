class Csvi < Formula
  desc "Cross-platform terminal CSV editor"
  homepage "https://hymkor.github.io/csvi/"
  url "https://github.com/hymkor/csvi/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "05ddf95ca2829888c656fbc7cd7216e62d96658299891ca8dd2698ef77d48c02"
  license "MIT"
  head "https://github.com/hymkor/csvi.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/csvi"
  end

  test do
    input = <<~CSV
      name,score
      ann,1
    CSV

    assert_match version.to_s, shell_output("#{bin}/csvi -version 2>&1")

    output = pipe_output("#{bin}/csvi -auto 'w|-|q|y' 2>/dev/null", input, 0)
    assert_equal input, output.gsub("\r\n", "\n")
  end
end
