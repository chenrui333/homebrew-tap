class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "af6c59e523e12aa4eda4f8d54316e8e21e72e1711a8c91f953d8c71e9fb1e908"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "801701dcb86e42d268d958c48130500a05f5ba15d1609fc7ad572926640343f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e13dac656817005905ef93ecd21688bc7b295a91c98132632ac3241cba9ebda3"
    sha256 cellar: :any,                 arm64_linux:   "8d262d657829a8fe00c07fd8d9edbc22d099669b283f827a1dddeb8727ccbdaa"
    sha256 cellar: :any,                 x86_64_linux:  "769222f4aff7cdaec3cfd09e40d6373ac8aa22a18aa768418f37dc694620a16f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "extra/tennis.bash" => "tennis"
    zsh_completion.install "extra/_tennis"
    man1.install "extra/tennis.1"
  end

  test do
    (testpath/"scores.csv").write <<~CSV
      name;score
      Alice;42
      Bob;7
    CSV

    output = shell_output("#{bin}/tennis --color off --delimiter ';' --title Scores #{testpath/"scores.csv"}")
    assert_match "Scores", output
    assert_match "Alice", output
    assert_match "42", output
  end
end
