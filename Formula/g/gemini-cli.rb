class GeminiCli < Formula
  desc "CLI for Google Gemini"
  homepage "https://github.com/reugn/gemini-cli"
  url "https://github.com/reugn/gemini-cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f875af3da015efd435f36d6a23dc3699c041621879c34a8a51679db723ff1d75"
  license "MIT"
  head "https://github.com/reugn/gemini-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "899e2ed2f6f0adffde1adc6ef241edd951bf845117bf42ed4f433576d871e304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "899e2ed2f6f0adffde1adc6ef241edd951bf845117bf42ed4f433576d871e304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "899e2ed2f6f0adffde1adc6ef241edd951bf845117bf42ed4f433576d871e304"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe6cc71c2051df1b4ec96a53e2ac481cc154d06547366ed8dd8436215982bc97"
    sha256 cellar: :any,                 x86_64_linux:  "bb1ec8c7d0135fc7fdeaaf4abbee8c5a8f6f786f89d0d212edf554b17cfb2c69"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gemini"), "./cmd/gemini"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    output = shell_output("#{bin}/gemini test 2>&1", 1)
    assert_match "api key is required for Google AI backend", output
  end
end
