class Systeroid < Formula
  desc "Powerful alternative to sysctl(8) with a terminal user interface"
  homepage "https://systeroid.cli.rs/"
  url "https://github.com/orhun/systeroid/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "756b341dc86553ce8df583d55e6d01517bf52721a556713a4fb6056c0f823f3b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "87d5352bd1389941c7d41c5fda1f11ab151bc096edca97ed5e431a8bac98c494"
    sha256 cellar: :any, x86_64_linux: "a8f4d7bf6082814793d2f4fe06f90b53985a091299c252254bbdfbdb9723074a"
  end

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    %w[systeroid systeroid-tui].each do |crate|
      system "cargo", "install", *std_cargo_args(path: crate)
    end
  end

  test do
    %w[systeroid systeroid-tui].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    assert_match "abi", shell_output("#{bin}/systeroid --tree")
  end
end
