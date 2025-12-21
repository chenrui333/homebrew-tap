class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "cc3d71c19cf33e8ad8222338bc2df8c623fe58c6289413376298bd094c419c91"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ccce44e400243d32d8948d2a39be17e40ff99f5f0337ae3ce6aa75ea88b57f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45f67a89f7ad242f91ca330d0f37f9454bc41b845925bd0a2195530c8e6bad7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fd3be5bf18b5f05b524d9bc9c664005cdcc677762d2e17c1d6cc2ff1ad50d3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b181655ddcf1c5e0cfae089ccaa61b74a38247c0de7635377312c15cf66d2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c81895a5215d9b5e762cba61a20cf2349200a5f88aabce4d5702c95de1d7c225"
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
