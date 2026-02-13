class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "779648dc35b05b061799b82fa23dd61128d7ffc1bfd6701fa327d2d7ac9e5dd8"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "397e1724cea2c15c908cf865f3a7ed9b5304e2474cecc6a986acbe3a2848a939"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "124acc003e69439508ef59a70c03ae68667e3ac9362371d206976b8ff39b1129"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf693928ccbd530c19be52a1b58f64f7a6fab100170e570802d90b32ad05e8d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "343cca30485f674ca6ed789e561a7e48103e06f51c747622a4cedddb4487c9e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b502ff982c8065c6136ed5953b1161f171ff0f04a2f3e842cc318b44eb607ef"
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
