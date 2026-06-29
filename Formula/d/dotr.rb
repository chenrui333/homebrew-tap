class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "fdf2fcd3ecca6a4dadf388efd202fc04885c5f32784a3dfc840b858c6f71255b"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4526960198e75a19a7422f0ededff9626926c1c6c7686d09c9ccdf7a0c42d6cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06a73c5cf809cb8789f6ffb38536b0aa068e9afb7611196a4068c8308fab3361"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f99e25f5be0ebd51f719c33178e62cc666c78bc99d7e9037bab6c49f1fa34c5c"
    sha256 cellar: :any,                 arm64_linux:   "18ea685f0aa354c4b9de2a01cfbdc0ed3fea7d074f8967dda31c64572f798369"
    sha256 cellar: :any,                 x86_64_linux:  "607b9e1607befbbfb32576bad11b1f36ae22266c50340d02c57f679c27e4845f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotr --version")

    system bin/"dotr", "init"
    assert_path_exists testpath/"config.toml"
    assert_path_exists testpath/".gitignore"
  end
end
