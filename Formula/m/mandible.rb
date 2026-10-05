class Mandible < Formula
  desc "Interactive reference for installed command-line tools"
  homepage "https://github.com/AS-FOSS/mandible"
  url "https://github.com/AS-FOSS/mandible/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "5b4d70ccb61201959bf9558f0e6cd84d0010cd396f7820aaaf3e6f4398c29b0d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/AS-FOSS/mandible.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af2534abb78e492bdca37e9610524b9fcad90a884193c13ca43fa5bdadc8c8f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2578664cbea4493dda541f3ee30be3452b589af5dd143265f3681528585dd78"
    sha256 cellar: :any,                 arm64_linux:   "f5a5a299b23aaf19f70a5d8e8a371aae3b900db695cbac21d406cef887311cf7"
    sha256 cellar: :any,                 x86_64_linux:  "ac70776279c51647a905cfe9815f4811b0792c2ae305a721876950c8862c1a16"
  end

  depends_on "rust" => :build

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
