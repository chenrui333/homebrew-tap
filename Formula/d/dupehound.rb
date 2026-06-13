class Dupehound < Formula
  desc "Fast, offline duplicate-code detector with history chart and CI gate"
  homepage "https://github.com/Rafaelpta/dupehound"
  url "https://github.com/Rafaelpta/dupehound/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b8915a13c7846a6da748914ea09aa32398f358bd9e07dc204a646437f29cf40b"
  license "MIT"
  head "https://github.com/Rafaelpta/dupehound.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c265467c65432e3bd4053d0360f21f41a09f8ec8a4b7c465a208113a1cadf4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85e1a29d5295225ff19b7170602874dc9d0787b9f0fc05113a51af93f47726e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5155c50708149527405d6e6c813f381b072ed4775e301fdcaefd45ca3eecc3c"
    sha256 cellar: :any,                 arm64_linux:   "43226a959bc4b50082f134ce346c858c4b7695216d3677122ee30c85d7342ef5"
    sha256 cellar: :any,                 x86_64_linux:  "7d7bab7a302b0bbe15aef21d836dda514b9283f05b830e68d9704094944010a8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dupehound --version")

    (testpath/"a.rs").write "fn hello() { println!(\"hello\"); }\n"
    (testpath/"b.rs").write "fn hello() { println!(\"hello\"); }\n"
    output = shell_output("#{bin}/dupehound scan #{testpath}")
    assert_match(/duplicate|clone|pair/i, output)
  end
end
