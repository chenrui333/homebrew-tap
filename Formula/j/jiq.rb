class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.23.2.tar.gz"
  sha256 "2d3262b71a7fe9721d3fd98e7824eff71016aa078e9059244f306e3e44a351ee"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e14e04cdd6f6bc88e49c36b50f69f632ed37c33b37a0110fb3e2c3fc710c9c0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "479884506ce91f873528e071373b4ef95ceeb52b19109a3c7e34df0830f6cd59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "373c076aae5438d00033f480db40f95992045d33f1440d563206013d4381974b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8111e11b77f54eacb81525cbeb067cd54fa4abe34a5c99889b19f365f3e84a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59301f42bc08600751055ef82cfd114aa47ff0365524433a83d805cd81866e85"
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
