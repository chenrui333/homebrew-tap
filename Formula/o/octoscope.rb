class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "b75c04e8939f0a6ab50460f9db71ec6609e20004b971807e65f5b4f2a6a2193c"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f29567c621718557796198db2e2f11af2c29dae3ca8a66f94133c63485fa34c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f29567c621718557796198db2e2f11af2c29dae3ca8a66f94133c63485fa34c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f29567c621718557796198db2e2f11af2c29dae3ca8a66f94133c63485fa34c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "736265dff30902203ff631a8252f28b39729b47272440a4d894bb5e494069459"
    sha256 cellar: :any,                 x86_64_linux:  "6e184a194566ef84e7fe03af58c62a132d1e887939f799362e0c2b3f23a92c82"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
