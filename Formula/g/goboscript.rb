class Goboscript < Formula
  desc "Scratch compiler"
  homepage "https://aspizu.github.io/goboscript/"
  url "https://github.com/aspizu/goboscript/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "8ff142f3b218c9f76abdf2a41fd9765ef6a544ad8ef076a482b09700c3260695"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba65f4bb7d795be06e0e4f70ed68b5e94c369fc467e3780a8e8f3e79a42ca438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f85d557cf0e40a2cc9e7645738f8485a090d316f419107db576dd89a2232344c"
    sha256 cellar: :any_skip_relocation, ventura:       "c5bf4178f0e8843f71fd0e03dfc2527cfd98fa28f8055ad593b0a6cd58350818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50dcd7b08583add0e5bf112d5d404928a594ed2d3cb40c80026522676658d234"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"goboscript", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goboscript --version")

    # test scratch file
    scratch_file = testpath/"test.scratch"
    scratch_file.write <<~SCRATCH
      when gf clicked
      say [Hello, world!]
    SCRATCH

    system bin/"goboscript", "fmt", "-i", scratch_file

    system bin/"goboscript", "new", "--name", "brewtest"
    assert_path_exists testpath/"brewtest/goboscript.toml"
  end
end
