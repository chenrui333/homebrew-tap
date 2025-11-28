class Tatuin < Formula
  desc "Task Aggregator TUI for N providers"
  homepage "https://github.com/panter-dsd/tatuin"
  url "https://github.com/panter-dsd/tatuin/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "4295f7bea79e646a0b156f0d3ff071be4ab5071bf5b9f73b26d135aa070c1b49"
  license "MIT"
  head "https://github.com/panter-dsd/tatuin.git", branch: "master"

  depends_on "rust" => :build

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
