class SuperstarryeyesBit < Formula
  desc "CLI/TUI logo designer with ANSI fonts, gradients, shadows, and exports"
  homepage "https://github.com/superstarryeyes/bit"
  url "https://github.com/superstarryeyes/bit/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b58bf458db0d8f2f5ee48628bcc9b7aaacccda0ab7d4216c5e404aa0e83e02f2"
  license "MIT"
  head "https://github.com/superstarryeyes/bit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff6e022171932453fcaa60f26d623d771dd20187e79684d82ba07785771b9960"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff6e022171932453fcaa60f26d623d771dd20187e79684d82ba07785771b9960"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff6e022171932453fcaa60f26d623d771dd20187e79684d82ba07785771b9960"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "717aa9de81d745c735b0cda2f4bd038ddbdef9baca4c6807b4872882c4d4aaeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e227fd69174b502610612465b2e240960d8d4a2c0ea5336a1e3cec44797619a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"bit"), "./cmd/bit"
  end

  test do
    assert_match "Available fonts", shell_output("#{bin}/bit -list")
  end
end
