class Travelgrunt < Formula
  desc "Package manager for Terraform providers"
  homepage "https://github.com/ivanilves/travelgrunt"
  url "https://github.com/ivanilves/travelgrunt/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "3a97f1c60f107507e965a826798c38e511a02462c417d1dda8fd619590c22aa9"
  license "Apache-2.0"
  head "https://github.com/ivanilves/travelgrunt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "622841722e37578f9821b6850e25ab6adf93abbd17c7f6fc5c0b0660552e1be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43744b70810727436d9d4c89606fea99086ba14d83e3e9e14fd984c9df6dffbe"
    sha256 cellar: :any_skip_relocation, ventura:       "a03a087822ea718746f172898344546045735a85d83dad618802c1c81061c708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f18d5c11b724aa81aa39f9175677f2df9ca9cc10c44549a2b170dff5cb7030e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.appVersion=#{version}"), "./cmd/travelgrunt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/travelgrunt -version 2>&1")

    output = shell_output("#{bin}/travelgrunt -top 2>&1", 1)
    assert_match "failed to extract top level filesystem path", output
  end
end
