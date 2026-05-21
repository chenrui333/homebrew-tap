class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.84.6.tar.gz"
  sha256 "dc0e390710f02634b38c4e78f2ed3b2239caaabdaf5c1b5b20f8cf4e4b7190d9"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8377b1e4bd842f5c554b58eaf8232747b20fa334663b25e2caef5adb5d97da70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8377b1e4bd842f5c554b58eaf8232747b20fa334663b25e2caef5adb5d97da70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8377b1e4bd842f5c554b58eaf8232747b20fa334663b25e2caef5adb5d97da70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27450d29d383a212311b511da8f7211078dfac1945bf9ec7cd5f184b385f614d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93e15bb50986c70f705235d54d3c6ffb387b8cf05c502df71a272b0af2ceea9a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
