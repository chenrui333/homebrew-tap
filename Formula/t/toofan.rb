class Toofan < Formula
  desc "Minimal, lightning-fast typing tester TUI"
  homepage "https://github.com/vyrx-dev/toofan"
  url "https://github.com/vyrx-dev/toofan/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "058741268cb43b1fe6c3896606f8bc03fb49043e644347d8f014d3ceed8573cc"
  license "MIT"
  head "https://github.com/vyrx-dev/toofan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "6f8e2a94855d0eabdb7cd59c3a62752fa252634572933692f464a5a776be9710"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95d17c0d05386fa9ff6596da1da015b98b66ce8399276ba082c6ced975d26a6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95d17c0d05386fa9ff6596da1da015b98b66ce8399276ba082c6ced975d26a6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0243ad92f1a7891a099e60e07298907e3ebe46b31e2d2e83a9f2424bebbe020b"
    sha256 cellar: :any,                 x86_64_linux:  "3fefba051e168c91a49b1238dd3d261628b0c55ff38cc1503a5b58c85e2877dc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toofan --version 2>&1")
  end
end
