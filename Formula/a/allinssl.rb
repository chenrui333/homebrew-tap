class Allinssl < Formula
  desc "All-in-one SSL certificate lifecycle management tool"
  homepage "https://allinssl.com/"
  url "https://github.com/allinssl/allinssl/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "be5a1f3fab194efdbd24d41dac90d86d88cdc89531f40f2818872c6af6d78e01"
  license "GPL-3.0-only"
  head "https://github.com/allinssl/allinssl.git", branch: "1.1.1"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c94fece6f8b4aa9799f2a10431d5a3a22fc38c8f7e5b24cf69c78e7f2e650f48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c94fece6f8b4aa9799f2a10431d5a3a22fc38c8f7e5b24cf69c78e7f2e650f48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c94fece6f8b4aa9799f2a10431d5a3a22fc38c8f7e5b24cf69c78e7f2e650f48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f102665e0cc58496393b14b8dc759cba3b3aa39b1a64dd0e6c5373f151f1d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d8f25cc1fb02369fe82efc84b04222776bfb025de94d8354f741203051897e2"
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
