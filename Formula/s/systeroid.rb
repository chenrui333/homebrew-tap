class Systeroid < Formula
  desc "Powerful alternative to sysctl(8) with a terminal user interface"
  homepage "https://systeroid.cli.rs/"
  url "https://github.com/orhun/systeroid/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "756b341dc86553ce8df583d55e6d01517bf52721a556713a4fb6056c0f823f3b"
  license any_of: ["Apache-2.0", "MIT"]

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
