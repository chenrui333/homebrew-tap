class Pitchfork < Formula
  desc "Daemons with DX"
  homepage "https://github.com/endevco/pitchfork"
  url "https://github.com/endevco/pitchfork/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "ba564d1cd429aff1737baa24df1c2c0ac66c1cfeff95d54eee73b6adfa81620e"
  license "MIT"
  head "https://github.com/endevco/pitchfork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f18f8983050caf22388e2b60edff3b663764b4f07446d13a624baac9c6af1ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93edf1abb182aab956d98b79f4ffedc10ea3bb512cb06d42269fa253b0ec4077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "844db1ff587729174349f6fcf9e95fff8f1c815120e5782808a2901e632e0639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ae22ecca05636f1646520ae396b6a39720af34f0ffbce9239d17592041264f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77819f162ea61f5dea2403e147861925940eba2be268fd35480f1d3cba32a4c7"
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
