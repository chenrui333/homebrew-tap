class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "3aba3ce459e64ca69224c9bca1784a45ce28d8812fc6cae36ee83a462036b9db"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04e2347e04141819a4c4b3bc1a29ffcc2ccbd8a54dd038253462b802c8ebd986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "315a9f7db558aa01756e14f22a6543657f3cd4ec21a428e7ae0183b8a628c3f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80f4e2fc6501d1e221832b7925b640c50724fcb0d8ef586a86db191141c5b6e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0868df4bfa4e1b14c8a8d7f6ee848a3a42136a040d408198c04bfee7d5f78562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e686c17fd2fcb18e04635223739d85c41b4b92f9c7ac777ea3b6733157a08f7"
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
