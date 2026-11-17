class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.41.3.tar.gz"
  sha256 "2fac2ed11fd897fa1310cd939763a615fb876ba6c3d6cdb16bc755db83723610"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93d508af34242cd696379c78e88ac85370359eb39710142112ef31f9c13a6400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d508af34242cd696379c78e88ac85370359eb39710142112ef31f9c13a6400"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f1a859a819e48ed222522503864083a6f6f125dddff951bd3e6de8f5560b68e"
    sha256 cellar: :any,                 x86_64_linux:  "c88d23cb8150bc2832051ac494e4cc2a8f79cc1f5414b260ad7b62609d364879"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output

    ENV["NO_COLOR"] = "1"
    assert_match(/Available themes:.*high-contrast.*phosphor/m, shell_output("#{bin}/octoscope --theme list"))
  end
end
