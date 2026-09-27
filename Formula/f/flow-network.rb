class FlowNetwork < Formula
  desc "Real-time network throughput dashboard"
  homepage "https://github.com/programmersd21/flow"
  url "https://github.com/programmersd21/flow/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "3aae1c2f9890661e0b5b2f01b11a679ad8ff016dd78307d8a983191ffa44610c"
  license "MIT"
  head "https://github.com/programmersd21/flow.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a7392693a4d3556fe7514325aa5d39f9f7475f26e33822aed6412e8878ad066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a2930e6497778b6faadbc229c3f540bbfc6b5b6ac6121351894b781a1c0cf85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6757f9afc829aa23e5e03fbc4080b2805f0e84300821a0fc26dfe999af1d680b"
    sha256 cellar: :any,                 x86_64_linux:  "7483a3699bc4e2d438eb6163661dd204bd474cd4b7f07a2f955b4d0c8dfdc9f5"
  end

  depends_on "go" => :build

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
