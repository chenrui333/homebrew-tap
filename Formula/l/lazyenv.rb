class Lazyenv < Formula
  desc "TUI tool for managing multiple .env files in the terminal"
  homepage "https://github.com/lazynop/lazyenv"
  url "https://github.com/lazynop/lazyenv/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "62498af6b30c4612b700e8dbc96bd8cbdb5cf951fbda3d624c5df74fe40a2131"
  license "MIT"
  head "https://github.com/lazynop/lazyenv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1938ddda58b6aea60e8d293e96d06c2c1caff651e375e5a3b64c5b7e84cae80d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1938ddda58b6aea60e8d293e96d06c2c1caff651e375e5a3b64c5b7e84cae80d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1938ddda58b6aea60e8d293e96d06c2c1caff651e375e5a3b64c5b7e84cae80d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5572d542a7cee0247df6dda5f660b3aa915393c5f66add49616ea8e21bdc795c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b5d2ffe39b931115eb92c6820e11190828bc1e5590354f5a211c1c03f3175dd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyenv --version 2>&1")
  end
end
