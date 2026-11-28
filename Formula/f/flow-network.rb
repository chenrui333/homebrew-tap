class FlowNetwork < Formula
  desc "Real-time network throughput dashboard"
  homepage "https://github.com/programmersd21/flow"
  url "https://github.com/programmersd21/flow/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "cb477f30483749c8333385bcbd87e6525a7ce80a89c4a91c2e24ac2eec107e46"
  license "MIT"
  head "https://github.com/programmersd21/flow.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "401c3dba2125a9667b6bab79ad4e96d3389879b12dc9692a65f19e72d2c757c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b87ad051aa46e32faee88bd2bb2900870388a586b9fc33d68e7bb92c3d41846"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "848a867733caa613b36817b2dea9e4442ebb05f04f9aa82f92a155e1eae25a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c38ad1a53cb09388a6b345126539fe85895976186dc51957e4cd110120aafd65"
    sha256 cellar: :any,                 x86_64_linux:  "a87de1a5b8f0f44f2a80b960ee8082a6c4d1249ddbbb53269db786aa19d55dc5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/flow"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow-network --version")
    output = JSON.parse(shell_output("#{bin}/flow-network --json --refresh 10ms"))
    assert_equal "ok", output.fetch("status")
    assert_operator output.fetch("download_bps"), :>=, 0
  end
end
