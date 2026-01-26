class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "c57226c17b48cc6c3aa2024e5f9fe032660a84bec851a89b4280e01ba1842263"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc2aed56e8b7398231adb1546a02aaeeae99cb55d6ee4a7415d0941c9cf5fd16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "461674119c9bbf777038a4171dee25ea88484df6a7fb3754755bc0c9d85685ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "786aab0cc11d900503e1cba751729fe3fb53cc79abda2fdf51a528ffb15c4d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "202bf5a305461c1f37048bea32301f431e9565da8c43df61bb230f40eb1aa18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abc526c7c118717c1209fc75c3623135439f857571cdbbbeac4acd4c4ee8a2c0"
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
