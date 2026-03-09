class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "48c4e87132ce8c9469cd471eb1e21c18ac0d60ea889188197f11504300a022d7"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4ea238c2e3ee55c1b191da30983421ce2d988341f2c0921f20b37a79e015139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e863815987c0e03fa989a9c6a67151b2a83921e1e5d6722fdcc27077910db04b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89198d911b5971fd52398c2d12ee5ebd8c3aec0501e50a456616fe20f52f1fbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c3ae9b8ae3b92d74dc50cf876b09f1372dcaa032648796167f3d7a5055e5b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94a00991a1448c319842ef085e5ce5d1435997a9a01ee8b01b8f0927fe35bb9c"
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
