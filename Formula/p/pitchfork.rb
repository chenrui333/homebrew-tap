class Pitchfork < Formula
  desc "Daemons with DX"
  homepage "https://github.com/endevco/pitchfork"
  url "https://github.com/endevco/pitchfork/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "644c119e7b3c3b79f7008fab12e15b3cb5c0416746c7eb05692b6977a85392da"
  license "MIT"
  head "https://github.com/endevco/pitchfork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbcbaeda22e0941b83f1c56874a78abd1c14704bf1da3ed83f6298a50a68072e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddcfca9473e4046eff8954e3c23969cb89a1871beadb6810eafe6cac1a34fd43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72fc1f1f5b4c8477eb681a122297dd564ca86dafdab7872ca8ae07c13ab156c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f99eeceeda47b2f8c4a14fe1f85627906e16bebe86b5db2177e8e1d039c0c8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d11b61aa21cdead87617f01ee6ab10afff4f8fc54b450af77339c1d725857b"
  end

  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    (testpath/"pitchfork.toml").write <<~TOML
      [daemons.test]
      run = "echo hello"
    TOML
    output = shell_output("#{bin}/pitchfork list 2>&1")
    assert_match "test", output
  end
end
