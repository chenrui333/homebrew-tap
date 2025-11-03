class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v15.0.0.tar.gz"
  sha256 "b1b0e65f599c4af7f4d751e1ce494ba4e3c2d7cdaa0ff67eeed1d95b775493f4"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d67cb158a5294853d567272271741309653512cd19f56789c1cde6c432f80eed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d67cb158a5294853d567272271741309653512cd19f56789c1cde6c432f80eed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d67cb158a5294853d567272271741309653512cd19f56789c1cde6c432f80eed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc08663a83972b9c868de6d67adc68986117b13f8607de0cb139e923ad63a865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ad8882ab3962a89227874cffbd781171a1d337f14bb0e1ee47f66982b7fea1e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "FATAL confluence password should be specified", output
  end
end
