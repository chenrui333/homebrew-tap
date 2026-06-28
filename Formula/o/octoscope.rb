class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "fb7c03860e95b970b35ef0c1e4d04ec3e1cf0c276b4885b9f65d278ff18df1fc"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad51ee901ba80e8f944fa81b0123989f5900332a66069707f0925c885f2c0a7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad51ee901ba80e8f944fa81b0123989f5900332a66069707f0925c885f2c0a7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad51ee901ba80e8f944fa81b0123989f5900332a66069707f0925c885f2c0a7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "289cdf82859b08df6060283e63108cef8a93ef03c5eccc08481e118e24550682"
    sha256 cellar: :any,                 x86_64_linux:  "621c74494b412d4e5b92bef056433665532d29e9fa63feb81a411debe5b35b82"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
