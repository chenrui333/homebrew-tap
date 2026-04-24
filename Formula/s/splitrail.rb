class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://github.com/Piebald-AI/splitrail"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "0195a600e30ba92e861468123c061bb456469fea55319cb83f3cb10852875ec3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd8406751098ad72c1b3b94910fecd78748db846cc2a0bd4676b85669db99776"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c36ed71597f1aa13cdb042576711b15603bbf3bef83880e4ef38ea6a3956991a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48f5f055e60361298b16121052a6b304890f8689f99ab063229438550c9e8d30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86e64e4bdff8c7f32e8221052bfd2d7f4f625b54fe75bee3259efbd7fba8f9fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9614b1808ddbef185b14c80bcea0233fe3fac044eefeb4457d4964c2e5555635"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")
  end
end
