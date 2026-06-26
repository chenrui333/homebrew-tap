class Kyushu < Formula
  desc "Self-hostable Wasm sandbox for JavaScript workers"
  homepage "https://github.com/peterpeterparker/kyushu"
  url "https://github.com/peterpeterparker/kyushu/archive/refs/tags/cli/v0.1.0.tar.gz"
  sha256 "0fccf800b577b5f5dbf0504d852ed0061ca2a07d52ac563204cb1b22c5f8f711"
  license "MIT"
  head "https://github.com/peterpeterparker/kyushu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51ef11cec4bd01439e312b23584fda8275281f9bb5aa65010dd6e6b7ea718e99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea22a8a4a0ef640e35fab4a4c468e8889743b4fe0bf295d45ef0d67780c28ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7543c79f7e898d189e48586f91a054d1b18b142a29742afeeb23fe2a3b016b"
    sha256 cellar: :any,                 arm64_linux:   "9331b1acff0101613b2a09583822069152ed5801e3a4b72e2c37b4805f2e920d"
    sha256 cellar: :any,                 x86_64_linux:  "835beb414906e2cec9b0953761b4e784f767414d8b5fef3545159b9bd9e88e08"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyu --version")
    output = shell_output("#{bin}/kyu --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
