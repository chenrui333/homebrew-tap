class Shuk < Formula
  desc "Filesharing command-line application that uses Amazon S3"
  homepage "https://github.com/darko-mesaros/shuk"
  url "https://github.com/darko-mesaros/shuk/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "da15a5c54e55c127a54f69daa36aa904ba22ca59e805d53ae5b03a172103f096"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/darko-mesaros/shuk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d200ae1eea463c31d1bf5dcf03592f23f470b051084890dfefbad56a78dff582"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b9d1b2c31d37359ab8075f0e8647f99e2f2e3712df26e5741caeec2a1c68c55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ac69e725905868cc6b7755d540d0ba190eb869b05389d9dc82b1f9497863b2"
    sha256 cellar: :any,                 arm64_linux:   "445bdc5b7e762ec607088254fb23821b0afb6bbf7400a0a0115364e203db8e14"
    sha256 cellar: :any,                 x86_64_linux:  "d3f5c635afeaed0a4b95d37a41663fd3496f84a66f88e51d3bc18d3c0e4bd93e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuk --version")

    output = shell_output("#{bin}/shuk test_file 2>&1", 1)
    assert_match "Could not read config file", output
  end
end
