class Mult < Formula
  desc "Run a command multiple times and glance at the outputs"
  homepage "https://github.com/dhth/mult"
  url "https://github.com/dhth/mult/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "73ecbe739b5f8bef3508f22641771818eed4e250564a9247e84c28190f293d43"
  license "MIT"
  head "https://github.com/dhth/mult.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b3b650a0e11d5713ca59fa6fd77ae7f182801f1807df7799cdb032cb244ce81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b3b650a0e11d5713ca59fa6fd77ae7f182801f1807df7799cdb032cb244ce81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b3b650a0e11d5713ca59fa6fd77ae7f182801f1807df7799cdb032cb244ce81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec0d6194a3529b102d5e7a5f0f49b58d052073febaf8cc0fcc278895c600574"
    sha256 cellar: :any,                 x86_64_linux:  "c652832ed24cce40d9db29b584b93fef5b58c2395c2d213d8fdb1afdc960c42c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    output = shell_output("#{bin}/mult -n 1 -- true 2>&1", 1)
    assert_match "invalid number of runs requested", output
  end
end
