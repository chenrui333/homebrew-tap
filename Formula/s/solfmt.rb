class Solfmt < Formula
  desc "De-minifier (formatter, exploder, beautifier) for shell one-liners"
  homepage "https://github.com/noperator/sol"
  url "https://github.com/noperator/sol/archive/7762c5115dd899bfac10d2f46d066de3c0e81774.tar.gz"
  version "0.0.1"
  sha256 "e72473ad928528216d98107275f7a402cae5f36f8fb0c65032ebee5c19e04f61"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"sol"), "./cmd/sol"
  end

  test do
    input = "echo hello && echo world"
    output = pipe_output("#{bin}/sol -b", input)
    assert_match "echo hello &&\n    echo world\n", output
  end
end
