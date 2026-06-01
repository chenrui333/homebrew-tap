class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.32.1.tar.gz"
  sha256 "be515187b42e51b63de193ecd6cb92a8ba7dd6de3133f34e2dfec62d8a38177e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f86f751f73ed4ea6aeb4ec47a93a338eae05ff3b85bcca3c2d42187b7380dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cb39eb609802cc59809b086f7155c4c69bac4cfc3af06c75da8f905122fba4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "222c9ef8e3ba0b2aae112c680ce86244bf011e4c6c492bc2d0377f20dd349174"
    sha256 cellar: :any,                 arm64_linux:   "aa9f9892e1b14894d982d4066961fac649f3bc7ae6ea92f1b4f85e053aa72714"
    sha256 cellar: :any,                 x86_64_linux:  "0c9bd05738668af1a711a446dfaf6023010dd265f8d91038d1959ad403ecae79"
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
