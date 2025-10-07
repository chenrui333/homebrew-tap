class ConfigFileValidator < Formula
  desc "CLI tool to validate different configuration file types"
  homepage "https://boeing.github.io/config-file-validator/"
  url "https://github.com/Boeing/config-file-validator/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "e7c50fded0e036ef56d2479a2fee1eba35ea7fd232a4ba7c98ab087e4ae521ed"
  license "Apache-2.0"
  head "https://github.com/Boeing/config-file-validator.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb1f418cddc83aea7aa406cac98e0a5d229ebf4f135379981c03bacc7cf4aac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e677b0f08d0193a7863005981d16913b399284999d918e0eb7c054ae5386243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "240ff176e069adfff15073ce3636ca1758f46abd087e8ebb1de9af17e58d6051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d9a0680637d64a7d1b6251328140ac482ffa28a16f9bc41ff431dce32d283c2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Boeing/config-file-validator.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"validator"), "./cmd/validator"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/validator -version")

    test_file = testpath/"test.json"
    test_file.write('{"valid": "json"}')
    assert_match "✓ #{test_file}", shell_output("#{bin}/validator #{test_file}")
  end
end
