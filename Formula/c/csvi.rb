class Csvi < Formula
  desc "Cross-platform terminal CSV editor"
  homepage "https://hymkor.github.io/csvi/"
  url "https://github.com/hymkor/csvi/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "05ddf95ca2829888c656fbc7cd7216e62d96658299891ca8dd2698ef77d48c02"
  license "MIT"
  head "https://github.com/hymkor/csvi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b858d0bfc779e9d0602ab6cb7ab258f009f8244c227de24a0d366c23643785fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b858d0bfc779e9d0602ab6cb7ab258f009f8244c227de24a0d366c23643785fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b858d0bfc779e9d0602ab6cb7ab258f009f8244c227de24a0d366c23643785fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4967fa6289a84b92c5b5066d72091798aa0c594603f1cf87a55ff0ca80db4102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b697aa85ae83bc35c79ef0afe0b61e235a56a0a926077300399813058f2273"
  end

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
