class Tatuin < Formula
  desc "Task Aggregator TUI for N providers"
  homepage "https://github.com/panter-dsd/tatuin"
  url "https://github.com/panter-dsd/tatuin/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "f43253ca899996faaa31f0cf9cf88e4cf4c1286b43ab80ff68973a9244568b44"
  license "MIT"
  head "https://github.com/panter-dsd/tatuin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9416b50bc640913b6b9e23fc8bf068e0dd863779945f43493837cf45d3f2c2ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a27dfabad402cb09243bcf9b32b669d67e7731e77c4b03d64c4a350cd71fd0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56c1a1131fae8a177874926dc0ad806ee2c8e22f013890acdefc1e34fedb8d27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "914088cd2edabde8bcd2477a36197ec0fe8cafbd8922543bd9e730fd5cb9bf46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "840d8ae331117739bd6bee3895a15e641366c839f695ce5abbb25a772eee8d2c"
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
