class Mandible < Formula
  desc "Interactive reference for installed command-line tools"
  homepage "https://github.com/AS-FOSS/mandible"
  url "https://github.com/AS-FOSS/mandible/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "5b4d70ccb61201959bf9558f0e6cd84d0010cd396f7820aaaf3e6f4398c29b0d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/AS-FOSS/mandible.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db2dd90e0c4a0ed8de0e163b62cf991b7fc4364e59368c279afd10930e084878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85f5a7fcf78a95d9f7484dea990c2f1292b77d8192b04f5cbab130e51f0cbb27"
    sha256 cellar: :any,                 arm64_linux:   "2b7a27d87a336529bf2c5b7200c6ec168cb228690149224652e05064e06908a5"
    sha256 cellar: :any,                 x86_64_linux:  "c41aa37be698bf523f35d2193a13b101c53cc7a5c4e8d020aa0072e0584351b9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "mandible")
    generate_completions_from_executable(bin/"mandible", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mandible --version")
    output = shell_output("#{bin}/mandible 2>&1", 1)
    assert_match "no tool given", output
  end
end
