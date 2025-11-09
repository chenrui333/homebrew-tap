class Systeroid < Formula
  desc "Powerful alternative to sysctl(8) with a terminal user interface"
  homepage "https://systeroid.cli.rs/"
  url "https://github.com/orhun/systeroid/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "756b341dc86553ce8df583d55e6d01517bf52721a556713a4fb6056c0f823f3b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c1fc7b3d0f147bcc0da379e284411462ff8a44b64258cb12fda31bca0fc54fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3aaa97eef8dcf6091f0c37aff3868b988ce15d06ebcc1fcf2b772746c8393ecc"
  end

  depends_on "rust" => :build
  depends_on :linux

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
