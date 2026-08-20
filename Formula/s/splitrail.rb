class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "e0cd15d78e38f7813edab999ce7cfc7f7dcc3c89c582dd3d39c387e273c542f9"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a363bbd58c5b32f3bcca23ac5817a38404c2f5ffd851d9da34b7919b08178598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23a1bcf3ec0f92e810f48bcbd13fae7745e90f9733fc670cb68c5f8c35af9bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e2190b41d197d412d1e59320eeec0699e281faa2f5cf63bfd88e6235754aebe"
    sha256 cellar: :any,                 arm64_linux:   "de3c92476e899e2fe0e8c4b112e57010c609cbc195528567ff3f5300b4ce5edd"
    sha256 cellar: :any,                 x86_64_linux:  "d7f6514365b87aab5a2dc4478ab10692049ad3a08d4eb83c3d83f159445220ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
