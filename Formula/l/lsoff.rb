class Lsoff < Formula
  desc "List listening TCP and UDP ports"
  homepage "https://github.com/yutat23/lsoff"
  url "https://github.com/yutat23/lsoff/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "25117f42705801040ea63bf09cf6396a063d54c0087a7ce6a57554195b5f17ae"
  license "MIT"
  head "https://github.com/yutat23/lsoff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43ed99253b1ecadc51532167f88c5eab1b0b6d8d077a6f984142bb967b0de74e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eafa1c1b71a5dbb96e46a6ff56c3bfd20e75318b9db4ea6f9fc02a87d850eaa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "115258613b26164b568fa0cf377398c5e1743a9a7edc2e0c4351a9cf5e859d89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "448c7c5e499ffde915b7c26ae45b568cf57a040be028912b94d46beef3466068"
    sha256 cellar: :any,                 x86_64_linux:  "316feb7670302b3c61f89cb4dca8d067a72f9f2745b8e552b3c8913998cd6776"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsoff --version")
    output = shell_output("#{bin}/lsoff --kill 2>&1", 2)
    assert_match "-k requires a port", output
  end
end
