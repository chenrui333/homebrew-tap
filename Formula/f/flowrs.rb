class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "8e18fc941e6a316589bfc7eac38836eb821fd8f5e298eff984fea6bb52017c48"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35136b941d73a593596293e1808764cb687e07f4fee38f74147ae5963b99554e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b935c6e4ef05735e76fc0775e87dcd3bef16c878394b4179f943c88188d4762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b75748ca8ee642597502e2d852c944c6fc3fa36ec00055089ac1430cfb3b2d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "869256eb9ef262045b41969351d6ba4d38eea7b5965a8c5b9ee32929c13ac79a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fef2dd996e9d88085fba280af87f75532734566e35a749b18b163c5ec342f8a"
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
