class Roc < Formula
  desc "Run AI coding agents in disposable Docker containers"
  homepage "https://github.com/andreimerlescu/roc"
  url "https://github.com/andreimerlescu/roc/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "992102537434505032753f35fcad51425ebd3308698924b6815a62f0deb933a8"
  license "Apache-2.0"
  head "https://github.com/andreimerlescu/roc.git", branch: "master"

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
