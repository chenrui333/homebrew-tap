class FlowNetwork < Formula
  desc "Real-time network throughput dashboard"
  homepage "https://github.com/programmersd21/flow"
  url "https://github.com/programmersd21/flow/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "f2b172c6986f26a32d1404960d392c49579d8de95c59a906e60b66852c782488"
  license "MIT"
  head "https://github.com/programmersd21/flow.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a26bf42d88d2082348e6ee743d5c3ba6a0af0a7b2eb275865af4bb55bb584eba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd8c2136c4200ad5c62e24b48f68069e2ce1c636502d7bfa28b70544f2caffd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ca0ae708ff655347dc95001f012063979fe77efa0283eb9149452cc543a79ee"
    sha256 cellar: :any,                 x86_64_linux:  "f58aa5f3e698c9d9e42156d9ed5534928352f782d7473fcca7c361aab097a5e3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/flow"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow-network --version")
    output = JSON.parse(shell_output("#{bin}/flow-network --json --refresh 10ms"))
    assert_equal "ok", output.fetch("status")
    assert_operator output.fetch("download_bps"), :>=, 0
  end
end
