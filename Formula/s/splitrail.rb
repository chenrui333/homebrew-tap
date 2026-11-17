class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "53c1b7afa44f74490afbfd2b9493ad229889b710efeb7229d245d229f544c9fe"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d1a9e9b09cb75e597007fc999e35e8292e48ededa650d91be8f923483525d10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c10e04112e8e24964b44be654d9783337941ab2d20274653acab6c24ab864a"
    sha256 cellar: :any,                 arm64_linux:   "867a95ab8532ca5939019a9923a8437cd467816fa03b01c1b1d025ec8c20f7a2"
    sha256 cellar: :any,                 x86_64_linux:  "005bab764270b1b41376b03005b64ece957df38f1f043a47f18c4c86ab42cf58"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
