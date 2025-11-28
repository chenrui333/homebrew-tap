class Mufetch < Formula
  desc "Neofetch-style music cli"
  homepage "https://github.com/ashish0kumar/mufetch"
  url "https://github.com/ashish0kumar/mufetch/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "c6cba3e87e21809c640e540d396d3f72bdaa4fd42fdb79de43ada7cd6a589f0e"
  license "MIT"
  head "https://github.com/ashish0kumar/mufetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9544aed3ef0e36876a05b9028d4f2f95dfd49d247ef78e418eba0026a2b7df6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9544aed3ef0e36876a05b9028d4f2f95dfd49d247ef78e418eba0026a2b7df6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9544aed3ef0e36876a05b9028d4f2f95dfd49d247ef78e418eba0026a2b7df6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "869c690d422a1755023c7a97797683dc446c8e05d44c8daabce5d477028904e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18a2ca95acf740dc45b2d48449503406bc0d03f6066ab0d2d783e5275860c28e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ashish0kumar/mufetch/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mufetch --version")
    output = shell_output("#{bin}/mufetch search 'Bohemian Rhapsody' 2>&1", 1)
    assert_match "No Spotify credentials found", output
  end
end
