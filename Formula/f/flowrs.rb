class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "30ec0af4622b764b05c1dc63554b5e71a40d4742e96fd2702bba3918c1dfc85b"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "becf3ba90c5c0a637084c3c97819fba9693a15b55c25171cee932dbfc7a9a253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68495172ba599fe5f79f9d3c2f1e6b70979504f46efcf69bafc3ae87edbfef08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf1b553931394bf596e14a3377b0d696a580ef1f483484bb4939aed94a6d55b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9125ffb15de6fa83a9b6df3d31db844c4696805990466d3ad22dde8134f36175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1faf779d3987fb683dfaf611324de2e55e884ddf94a086b16c436ec7e0cf14"
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
