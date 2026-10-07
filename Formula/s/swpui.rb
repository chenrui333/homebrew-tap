class Swpui < Formula
  desc "Interactive search and replacement preview"
  homepage "https://github.com/beeb/swpui"
  url "https://github.com/beeb/swpui/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "517a8f19498d3e5d689baabb7e48001aba81042c727010491fec27c092cd236d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/beeb/swpui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce72d520a8eea293a41d213dd4320d4746bb4eee2bf11520b2bd6f073ae105e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16a68d5132be7c36732ab71c880107e9554ff7b6dea1d5111c9d23501cc62b42"
    sha256 cellar: :any,                 arm64_linux:   "d397e5c6829868c0fb53197fa7a6f56669abc220e73ac452ccf5e542193d6063"
    sha256 cellar: :any,                 x86_64_linux:  "b24a39140ec7d81ac37e689f1415378de1af25ae2336c5cdf63e27f9199371e0"
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
    # TODO: Upstream does not expose a version command.
    # FIXME: Replace the startup error check when upstream adds a headless preview mode.
    (testpath/"swpui.log").mkpath
    output = shell_output("DEBUG=1 #{bin}/swp 2>&1", 1)
    assert_match "Is a directory", output
    assert_predicate testpath/"swpui.log", :directory?
  end
end
