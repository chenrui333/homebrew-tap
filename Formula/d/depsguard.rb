class Depsguard < Formula
  desc "Harden your package manager configs against supply chain attacks"
  homepage "https://github.com/arnica/depsguard"
  url "https://github.com/arnica/depsguard/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "e4730a6a781c5fefc20c28a7cafe6907546498d0f4aa12cca9bd7dee43877196"
  license "MIT"
  head "https://github.com/arnica/depsguard.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depsguard --version")
    assert_match "USAGE:", shell_output("#{bin}/depsguard --help")
  end
end
