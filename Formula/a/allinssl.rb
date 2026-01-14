class Allinssl < Formula
  desc "All-in-one SSL certificate lifecycle management tool"
  homepage "https://allinssl.com/"
  url "https://github.com/allinssl/allinssl/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "090a24028b0aca237fc53a5da5ee3535157a3cfe820b23577f69476e487b3916"
  license "GPL-3.0-only"
  head "https://github.com/allinssl/allinssl.git", branch: "1.1.1"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78f4dea295400b9a3b1061e453899aee3a0248f67ee41f6a71d37478922f68f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f4dea295400b9a3b1061e453899aee3a0248f67ee41f6a71d37478922f68f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f4dea295400b9a3b1061e453899aee3a0248f67ee41f6a71d37478922f68f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eef164f83e75f0632f1064065fa9a8a36206432720db784f8e1f64caf02aec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f814da640ca6e2bfa5cddf893ef612c9870882436ecb277d68749ec32899392"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    assert_match "Restarting ALLinSSL...", shell_output("#{bin}/allinssl 3")
    assert_match "无效的命令", shell_output("#{bin}/allinssl 16")
  end
end
