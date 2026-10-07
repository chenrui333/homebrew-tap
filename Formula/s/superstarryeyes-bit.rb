class SuperstarryeyesBit < Formula
  desc "CLI/TUI logo designer with ANSI fonts, gradients, shadows, and exports"
  homepage "https://github.com/superstarryeyes/bit"
  url "https://github.com/superstarryeyes/bit/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "2aa41585332d53685a3bd644d8d086f3ae999750b9e2f19ee8832ba9cec9737c"
  license "MIT"
  head "https://github.com/superstarryeyes/bit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "911e22e00a2cde7247a4a93a773e22930e098039c52ed92bb58788ad8d91565d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "911e22e00a2cde7247a4a93a773e22930e098039c52ed92bb58788ad8d91565d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b40c8efa6832d4db062608c0a4745c513c38dcc4d5bcfc6dd4c1d6d994a31646"
    sha256 cellar: :any,                 x86_64_linux:  "a33b2e6e3a6491a446cc41634f2e395e81f28d47d8f8498b4df122eb1c5cf0a6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"bit"), "./cmd/bit"
  end

  test do
    assert_match "Available fonts", shell_output("#{bin}/bit -list")
  end
end
