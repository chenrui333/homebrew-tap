class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "022a2c0d6390989b0cd731c375ea44ddcaa0c0879338f2aacb33b309c992da59"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c9edbd6ab91c019503ac6615a0f0814a06999b6b92f01fee015457bf9dedb8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05af345c81a72c43590f6650c14a715891bca5d700fa47c0131e663978b6a571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "542a51bd0f39a6f8176d2f08bb4d15b488440c26bcabcca180e5b4d15e749008"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7b6d9465824ece36399fd8bae15ff2986fc678c9b91f35c9697e1e232cf42b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b639fd4d28f9129d94135956a53edae7474aa998ee3f9b923e1650c4f4635d86"
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
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
