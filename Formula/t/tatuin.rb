class Tatuin < Formula
  desc "Task Aggregator TUI for N providers"
  homepage "https://github.com/panter-dsd/tatuin"
  url "https://github.com/panter-dsd/tatuin/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "f43253ca899996faaa31f0cf9cf88e4cf4c1286b43ab80ff68973a9244568b44"
  license "MIT"
  head "https://github.com/panter-dsd/tatuin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5718c68fb267b8fe5b33430f6a666d067d18423dba0da4712cb5cbcfc885646c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bd71828940d604dddcabce69d187427c22a7b257f28967f1c6cdedaa99b2fb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0d7549875a5ebfd09909a81ecccb61898c97e6c45014d746fd137c55a869284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40f31df72b491d18bf779e14542e97e6bdab7b33aec8d6ea43fc6a909510e684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e914fe19eda6948ffefa500ee15197f9f3985798661b5d78835ec5288d1a389b"
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
