class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "481f3e6b0d94600c3531c86277f5a4dd6d5ca598367e78d9d99132b41d345d42"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e47c55f2266c847264c482201b6e9e30038552ae279d9ca14036fae62a73ac48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05a630d1e5e45601e5bb43c5b936e5cc96078b7302e34d42b3f4f861c04be136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a73b9d5e64ffb26da6385e67d445ac204f03d885b2d8d2a267140e14e04ddf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "398702304f170586103396e0711ac135cfd4cd7213e941594bd7aa6dde65e06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e1e7874a21c758e92a4a89a8fa76ca16df116c21ab927e68fe1353429b5007e"
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
