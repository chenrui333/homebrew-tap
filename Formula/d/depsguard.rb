class Depsguard < Formula
  desc "Harden your package manager configs against supply chain attacks"
  homepage "https://github.com/arnica/depsguard"
  url "https://github.com/arnica/depsguard/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "e4730a6a781c5fefc20c28a7cafe6907546498d0f4aa12cca9bd7dee43877196"
  license "MIT"
  head "https://github.com/arnica/depsguard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e43deb5b5c8aaab5cb0090eae024d6b00d27c606df90a0f1c2d4b6819dc6c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bddb10666d3e848d795cf022243fffbd997552a8847ab2ace3d43428280c11f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6003f578b87eea7800b533258d88f8e5d50ea844d91e0d4797d52a733c18a9e0"
    sha256 cellar: :any,                 arm64_linux:   "676b3e4257164ae07205ee56972f158f63e0e97f44617e686981a3c0a28614e4"
    sha256 cellar: :any,                 x86_64_linux:  "cfd3fb10d29222fed893cb49a3eccb40f4f6c6ead1fe8426a18ca293ccb1530b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depsguard --version")
    output = shell_output("#{bin}/depsguard --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
