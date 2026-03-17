class Taskbook < Formula
  desc "Tasks, boards & notes for the command-line habitat"
  homepage "https://taskbook.sh"
  url "https://github.com/taskbook-sh/taskbook/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "86e63a776a11e4b597f9b3c453f7712953eff186fd5462c555611cb035210f5c"
  license "MIT"
  head "https://github.com/taskbook-sh/taskbook.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93fe0d44336e478239370dde7164b3c9e56a5445f7d7484e1129f91274b4b7e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e89ad275c07427d4fc05eb5ce63822692a91adbea5c77cf0d7b2a8c6d72cfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c70e8e5b71bacb6d18a06c4bdb2ca5244b9ffda3460894196fb230d2315ac0b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb6752580a7162fd7203d2f4ac50f7ba335ab5bec788153c273b71b59f5bc684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28eb041ce26cede98e201977b0b97a9027b0004d360d40549aad4a6e74bf6691"
  end

  depends_on "rust" => :build

  def install
    ENV["CARGO_TARGET_DIR"] = buildpath/"target"

    system "cargo", "install", *std_cargo_args(path: "crates/taskbook-client")
    system "cargo", "install", *std_cargo_args(path: "crates/taskbook-server")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tb --version")

    system bin/"tb", "--cli", "--taskbook-dir", testpath, "--task", "Ship formula"
    output = shell_output("#{bin}/tb --cli --taskbook-dir #{testpath} --list pending")
    assert_match "Ship formula", output
  end
end
