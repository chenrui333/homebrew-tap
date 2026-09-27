class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "af6c59e523e12aa4eda4f8d54316e8e21e72e1711a8c91f953d8c71e9fb1e908"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60e443d1da294715121f317a1a0668841229cee740df869d2c3dfe172b0f4fa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "678ca45fa647f03179ffb90d56c32e5055631e0c1cff6967326062f4f6261abb"
    sha256 cellar: :any,                 arm64_linux:   "75ff1b3fe0eea751f14a347eaff18b188b398aca20d97f8222e6d40ddecc4535"
    sha256 cellar: :any,                 x86_64_linux:  "327d88e235deafaa211e3fa6c31a985e619f8e51263fd3c9eadd89abd597a576"
  end

  depends_on "rust" => :build

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
