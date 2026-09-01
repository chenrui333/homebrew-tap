class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "d55e638952fb74ab3a61be58bc7b3b5a9f74ef07435aef2de0c15c6db5b2e65d"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8b8c754c53a839126b3c5761c724970ed337a613d7ae522b0cdde609070741c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7d5263af75e17de677e91b1945186b8f080671a55c376759ca99691c4b5151c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1764d32601e1b35dda01561a5af71a97a053784e6c1757474c4c73e276e3c7b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f1e4e635fe521c2a1ac5d857daff6b20730318aeae419af5750c10e1c7c85a6"
    sha256 cellar: :any,                 x86_64_linux:  "d4ee23d800f08c1c095b28fcc2701c6aa21f51646f223201952848cc3d4b1004"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gobgp"

    # `context deadline exceeded` error when generating completions
    # generate_completions_from_executable(bin/"gobgp", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobgp --version")
    assert_match "connect: connection refused", shell_output("#{bin}/gobgp neighbor 2>&1", 1)
  end
end
