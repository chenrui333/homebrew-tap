class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c79374308c2edad6eaac789e30b5dd99b89c595495db0ea41d80bb3d154b26e0"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "824fa6ffa6e7fdebd7bf5f54eb8a51f3ab9c022312efc6f08edce513497496a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824fa6ffa6e7fdebd7bf5f54eb8a51f3ab9c022312efc6f08edce513497496a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824fa6ffa6e7fdebd7bf5f54eb8a51f3ab9c022312efc6f08edce513497496a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "259601a0a04a86b32711e373cb9e38aef244ae809777d07a1f1138ed31dc16fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ccca4a19296a8ee44a435257cc4a210e040b388f3250d6969b9513cc301d8d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
