class Jl < Formula
  desc "JSON Logs, a development tool for working with structured JSON logging"
  homepage "https://github.com/koenbollen/jl"
  url "https://github.com/koenbollen/jl/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "91d01ace8795f156a84d0d0294451ba5d9b5a3ee2b00cb27852cf901657fc115"
  license "ISC"
  head "https://github.com/koenbollen/jl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53f75a39ed32c695ae593fbb228907458d332a9d6df2e768cf98fbe6915a0f47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "815aa0d62961e707e566951dc2fd93da7dbd5acb50f0e17f4b3070d17298808e"
    sha256 cellar: :any_skip_relocation, ventura:       "e22cc2a9970ac3852f566f631615ca9284baaca2fb3a93e36a0b0482b9898fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "217403b334a63ab92dd06cf0d6e026f6f0b3a18e87d2ad5050021f5b1f62b315"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jl --version")

    ENV["JL_OPTS"] = "--no-color"

    output = pipe_output("#{bin}/jl", "{\"msg\": \"It works!\"}", 0)
    assert_equal "It works!", output.chomp
  end
end
