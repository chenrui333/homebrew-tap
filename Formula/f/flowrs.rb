class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ad8af35fc65f27fc1454d4705334c8dff112bc402c5362c526ecef7c57da1d88"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e01e7ece3b9957d8f3eda07133f815dc00ffbf133d8645e9fdc39f2ac855de7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "946827c058fda0f3d19583805e8f1c631c99842946e8309db994cf29602726b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ae46ddc01660c209bf1fedec37ee4eebd169ede150b8c87f15114cbe5e3fc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a67fcaea892fe95613e8832f98d3d6c227fce474d3f88639cb8e4fbd7add507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "655bb7e9fc7c69217449b9b1454ebcc9336d0f5fb2c7ca5d1f2b72c106058960"
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
