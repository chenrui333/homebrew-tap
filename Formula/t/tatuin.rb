class Tatuin < Formula
  desc "Task Aggregator TUI for N providers"
  homepage "https://github.com/panter-dsd/tatuin"
  url "https://github.com/panter-dsd/tatuin/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "c4225a1630f7ea1b102965fbf64c06d60a71a7e940b4869b4f2705fbddf42d5f"
  license "MIT"
  head "https://github.com/panter-dsd/tatuin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b327aca22091f9e65a8ee49dbec8c316e36aeb78d5c3d5b96ab9e0598378060"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14931bedfdf5094207913ef087dea4c81a7a860e316ea29043e30e58a6320b9c"
    sha256 cellar: :any,                 arm64_linux:   "4d48e8cebd01372ad2286c33f93f62ac1600997e5e1b7e2755146156e6fde41f"
    sha256 cellar: :any,                 x86_64_linux:  "5d585b13fecd0a3449e388843b9d7fcc27167d2645fd4878b4e60cafecb9f88d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
