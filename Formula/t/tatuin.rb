class Tatuin < Formula
  desc "Task Aggregator TUI for N providers"
  homepage "https://github.com/panter-dsd/tatuin"
  url "https://github.com/panter-dsd/tatuin/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "953f1d0cf9cee1eea05ea9818d1b65b31d704e381f27dac6547a577738743657"
  license "MIT"
  head "https://github.com/panter-dsd/tatuin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "617901e2fc3c9d589eb2f4236d490db8b3ccfc5e1d78bfa82964779e3c6a698b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acccd182bc47e5bc9d2616b3e1bf8764a19e211c81926690e3a4e1e07adf3eb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f29b1af9356e26c88ddfc7dfa20025231bdd4cd85ab0d12affc7fe6ccb3c4f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1c662233661fcc88292b34e5bbff38e5e079ea79bbc3e3cfdd614bc6762e304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49073861dd1a4bf1613d17b40c38f148074d8eb16e7ebb207891b2af838c70ae"
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
