class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.31.3.tar.gz"
  sha256 "11a5c39004f80ae32d7bd956ade8bdc58d1cfcb316beb0c9398c8cac4652c561"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5efa6a67a4c640ea562cfe0630a03308681751a652fc395e891e53369848bc04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a87365439b52d405d5ca46ce1abda3e0ca645c9d97fd674a8f7c2181f3551c2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ff44f2a27d56ce9342ebe7103d2da15ac39d2600b8fc28b8847b4d0a895591c"
    sha256 cellar: :any,                 arm64_linux:   "62671945a7d6d560aca21f6f9cb9ffb6cdf2282ef042f92ca0c4c51b8f022ad3"
    sha256 cellar: :any,                 x86_64_linux:  "8a54f9e418975af71dea4201935f79c3470c33d020b637dbc6f56caa0ed7bb84"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
