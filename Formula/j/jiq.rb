class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.30.1.tar.gz"
  sha256 "755de3032facd8954e6a49b2c68f52230f2356c4a35c586de5f8551354a02948"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "419808337d63bc0ae974e4e136559f9b470641b6e2648d6fead5db43a58049f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1bac43a759f2dd88f574fcee5e7ae5482006f8989f1c516aedb348a0e53aa9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b125087e60e3295c837f309c74d8a8e6ed05e58da10804b290fcdfc78d6c53f"
    sha256 cellar: :any,                 arm64_linux:   "9492539f1922e4c96edff2a772a8025f8d00f62b2610b3b799a6bd98c5668d1e"
    sha256 cellar: :any,                 x86_64_linux:  "807c51aa63c6cc74c90985abd0912a23172be687d5703256c447df08ac208dba"
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
