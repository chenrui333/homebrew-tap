class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "cc3d71c19cf33e8ad8222338bc2df8c623fe58c6289413376298bd094c419c91"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e6cb677743b4d14728d8c57454b9be0591dd2d2fb63aeb252324ee9a8831934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46fee1391c3e08b7ade2f6ef8d37ae87ed77647114f652b5e8ede0e18de9519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eebe84f044f6e40a589d37a615a22bd737ed867fa054cd5a7637bb45ee5cfdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d3971af99692ed42d08656e1b39ce8e999041cc092ff3fd833328ae16b75c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc3abd4eb233b08d8f098af1b144e83f6f26f1b28f83a5b4cb9eb119cfb08bc6"
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
