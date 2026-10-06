class Spdr < Formula
  desc "Read-only DDR5 SPD decoder and semantic linter in Rust"
  homepage "https://github.com/The-Open-Memory-Initiative-OMI/spdr"
  url "https://github.com/The-Open-Memory-Initiative-OMI/spdr/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f0bf7a9d80b11885ce47e7288cde33df712a22ae0d1c393cda6c4ee0a308c5f7"
  license "Apache-2.0"
  head "https://github.com/The-Open-Memory-Initiative-OMI/spdr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "803ecae7fe097119aacf34966ce57ae66fb01ae506aa95336e145425a6bd2e48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57f0be19f1fc0b65e9f375dbc80e2df911138e05d59c0adb9d1c9886940be4d6"
    sha256 cellar: :any,                 arm64_linux:   "bead7709d4950b90d93edc71873976a8c932b4fc725cc46a3f6eb05ffad8f81f"
    sha256 cellar: :any,                 x86_64_linux:  "c5661736ba619a4a09848816d544dbfabd9b69783acbac4662f839b53be4ad35"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "spdr-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spdr --version")
    output = shell_output("#{bin}/spdr not-a-real-command 2>&1", 2)
    assert_match "unrecognized subcommand", output
  end
end
