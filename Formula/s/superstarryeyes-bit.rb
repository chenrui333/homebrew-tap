class SuperstarryeyesBit < Formula
  desc "CLI/TUI logo designer with ANSI fonts, gradients, shadows, and exports"
  homepage "https://github.com/superstarryeyes/bit"
  url "https://github.com/superstarryeyes/bit/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "2aa41585332d53685a3bd644d8d086f3ae999750b9e2f19ee8832ba9cec9737c"
  license "MIT"
  head "https://github.com/superstarryeyes/bit.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44704b6db736f43e26cb9f1ce1c402d291718b704b63456f2182d3d1fb2ec662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44704b6db736f43e26cb9f1ce1c402d291718b704b63456f2182d3d1fb2ec662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44704b6db736f43e26cb9f1ce1c402d291718b704b63456f2182d3d1fb2ec662"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "695f0cdd62be8f59df06185c49a8c091692e6542a671dc7aaf220e42c1e8a8f4"
    sha256 cellar: :any,                 x86_64_linux:  "b364a0912f2af8ef78c23fc9014842f9f97e77943fe81c0161906810655d6fb2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"bit"), "./cmd/bit"
  end

  test do
    assert_match "Available fonts", shell_output("#{bin}/bit -list")
  end
end
