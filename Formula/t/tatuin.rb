class Tatuin < Formula
  desc "Task Aggregator TUI for N providers"
  homepage "https://github.com/panter-dsd/tatuin"
  url "https://github.com/panter-dsd/tatuin/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "c4225a1630f7ea1b102965fbf64c06d60a71a7e940b4869b4f2705fbddf42d5f"
  license "MIT"
  head "https://github.com/panter-dsd/tatuin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93646b69a031410e6e39557ca72d1afcb851391fa493f634b44fc7e860cff78d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bd838e371a42a46f88e8a0743c363da3b01e8e0845e07004a17ef842acb77a6"
    sha256 cellar: :any,                 arm64_linux:   "ac0d8104d01519cdc4a394d6301b73b1d9298fa52665ea03b67517b08dacb6b0"
    sha256 cellar: :any,                 x86_64_linux:  "f5e643c9a041d1885f907a40605124f37f9cd298c3643aafe6214efdc56e55bd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tatuin --version")

    (testpath/"tatuin/settings.toml").write <<~TOML
      [providers.test]
      type = "Tatuin"

      [states]

      [interface.task_info_panel]
      description_line_count = 3
    TOML

    output = shell_output("#{bin}/tatuin --settings-file #{testpath}/tatuin/settings.toml providers")
    assert_match "Available providers: Tatuin, Obsidian, Todoist, GitLabTODO, GitHub Issues, iCal, CalDav", output
  end
end
