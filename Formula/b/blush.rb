class Blush < Formula
  desc "Grep with colours"
  homepage "https://github.com/arsham/blush"
  url "https://github.com/arsham/blush/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6db6b033bb5d4c4ac350b36b82d79447d5b91509db3a5eceb72ecb9484495e54"
  license "MIT"
  head "https://github.com/arsham/blush.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e4965bcf1d5c76f970c887b6ceb0b3ad781a96da41aa578d2216cd24ff65275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f5239d798d04c3f2f38363014e313ab070b30aeca154dee51dfda0a5760e436"
    sha256 cellar: :any_skip_relocation, ventura:       "bc466066f6da541f0a8873fd5e5f82ab1dbd70d450fb3ad9d81b9dae4a5e0be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed0d94801b9e22702add2c7618aa2de11350f719725ae462e53ae8c56f64359d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    pipe_output("#{bin}/blush -r test", "brew test\n", 0)
  end
end
