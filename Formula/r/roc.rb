class Roc < Formula
  desc "Run AI coding agents in disposable Docker containers"
  homepage "https://github.com/andreimerlescu/roc"
  url "https://github.com/andreimerlescu/roc/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "992102537434505032753f35fcad51425ebd3308698924b6815a62f0deb933a8"
  license "Apache-2.0"
  head "https://github.com/andreimerlescu/roc.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "aeec622802b26517ba02bffcf63f54cae913bd0ed4808f4d19bc23c635d41f84"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "819fb77da95235e8c532bae6dceafdf37301a755611ca2d186c48e5dbed4f270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48cd89f1446abfaf4eff483186478cf9266a721f8c346a5786896321ff3db532"
    sha256 cellar: :any,                 arm64_linux:   "d222f39044bcc1316ba54e688e9bcc1421994eb5143b97f6c49ddfd222ca7df0"
    sha256 cellar: :any,                 x86_64_linux:  "f5cc0ba0679cf00b5760918e04bc5d88032b3c680b4b3a540a57f90c65c2db81"
  end

  depends_on "rust" => :build
  depends_on "docker"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      Running agents requires a reachable Docker daemon. This formula installs
      the Docker CLI, but does not install or start a Docker daemon.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/roc --version")

    system bin/"roc", "--init", "--yes", "--state", "state.json", "--provider", "none", "--binary", "goose"
    assert_path_exists testpath/"state.json"
    state = JSON.parse(shell_output("#{bin}/roc --show-state --state state.json"))
    assert_equal 1, state.fetch("version")
    assert_equal "none", state.dig("config", "ai", "provider")
    assert_equal "goose", state.dig("config", "agent", "binary")
  end
end
