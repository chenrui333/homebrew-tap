class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c79374308c2edad6eaac789e30b5dd99b89c595495db0ea41d80bb3d154b26e0"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "574a1ef77eb1c6bc765a6e0be43649210590f709611fc1543fe4906ae6b225ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "574a1ef77eb1c6bc765a6e0be43649210590f709611fc1543fe4906ae6b225ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "574a1ef77eb1c6bc765a6e0be43649210590f709611fc1543fe4906ae6b225ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6c72f066cda061202c93c014f3150b443e9e64cd61033f2e8ee5c3b98d3347a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb61369fa73d6d3fe7d38125068eb11907932594c74e374a7773987485ff69a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
