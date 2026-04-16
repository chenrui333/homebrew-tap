class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.22.1.tar.gz"
  sha256 "797d0b988e0231a20cb4da205ddb1f4e3b974c15613f45951fbd502d9082a418"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b13ff62eb7a7d52fdbb05f47ffb97425036d7eba6650930551923a378c7a6879"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50515511752350e10e177d7d181195f3abfc4ce9763c29812235f2e458cdf53f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f37e04653ef307346be857cf63894d1f4d567c715316c35e24d6ae59ff4e0414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3a18289874e72ccbaa61b2a74f580e6fc6b102d0f405c78d15de6a21e9fc4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6fa68f788a6bac39fbdf02c45cc8a2816f2528efda238c433bfc82a845ab85f"
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
