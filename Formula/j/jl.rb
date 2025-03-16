class Jl < Formula
  desc "JSON Logs, a development tool for working with structured JSON logging"
  homepage "https://github.com/koenbollen/jl"
  url "https://github.com/koenbollen/jl/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "91d01ace8795f156a84d0d0294451ba5d9b5a3ee2b00cb27852cf901657fc115"
  license "ISC"
  head "https://github.com/koenbollen/jl.git", branch: "master"

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
