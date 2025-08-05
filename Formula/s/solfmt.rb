class Solfmt < Formula
  desc "De-minifier (formatter, exploder, beautifier) for shell one-liners"
  homepage "https://github.com/noperator/sol"
  url "https://github.com/noperator/sol/archive/7762c5115dd899bfac10d2f46d066de3c0e81774.tar.gz"
  version "0.0.1"
  sha256 "e72473ad928528216d98107275f7a402cae5f36f8fb0c65032ebee5c19e04f61"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a82eae7dd4734ff948dd7cd58470f9069b972ab579eb43f62f9928ca1db6ac6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c573dca4c94467c8db014b3f2c06f82e3d9855abfcd68a2634233d83b159773"
    sha256 cellar: :any_skip_relocation, ventura:       "ec1eda4c6195390ed3fb48d218d74f116e40773aef43d1a95d6ea8dc7706f73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "388b319b93b60875a99a411af5b84898aefab621c1cd6f3ef1348b2aa03396db"
  end

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
