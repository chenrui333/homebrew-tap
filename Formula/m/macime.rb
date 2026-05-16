class Macime < Formula
  desc "Blazingly fast IME switcher for macOS"
  homepage "https://github.com/riodelphino/macime"
  url "https://github.com/riodelphino/macime/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "46b6ba42296c76954d3017bb7b7fc32cee0cca0fa991c383024ebe3246adf696"
  license "MIT"
  head "https://github.com/riodelphino/macime.git", branch: "4.x"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8b6f068c430c90e40371471a89fd33101c89b1a9a592afdab84bae12b74f77a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb02cf7426ac0e8aeff3825c8c69b03544351afda582c15bfbafbbe5137e6a87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65f09eb157b93dc787ed3fffdef1635aa8bd27dc6a6ce4a15e5b53de232bbee1"
    sha256 cellar: :any_skip_relocation, sequoia:       "0b359e964fd475f778c780366b4d08ef552089788db0e74e5af011f868a4f145"
  end

  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/macime", ".build/release/macimed"
  end

  service do
    run [opt_bin/"macimed"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macime --version")
    assert_match version.to_s, shell_output("#{bin}/macimed --version")
    assert_match "Invalid log level", shell_output("#{bin}/macimed --log-level nope 2>&1", 1)
  end
end
