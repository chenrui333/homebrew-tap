class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "91832298ac6af26d26d6706acb14c8d5e630d3eb80b8fb2e22f34f522275e1fb"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faa4d8dde103cde4da45425d2f388976f8dbfc22555587826cd4441f291b9bd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69eed6f916dd3bae989bc6d9aaedad4f27644ee43952f9793850817890cc5c19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "488d168aecc2d8bdde011e01b9e4596a4749e726d93b1a6d980fdb8cf15f1c73"
    sha256 cellar: :any,                 arm64_linux:   "15e17b7e44d9568837a5dabf83e64374e499a5bc27598ab5bd363d49e2ec15a5"
    sha256 cellar: :any,                 x86_64_linux:  "690f35f4518ba008469b94128f34d223dec7835f7cf6a689a7c55c251f21deaa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
