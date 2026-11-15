class Trdl < Formula
  desc "Deliver software updates securely from a trusted TUF repository"
  homepage "https://trdl.dev/"
  url "https://github.com/werf/trdl/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "7b54f1612db87c50de279e36b5cdc646e086fa3499aba9db2dbecc3e6faa6a39"
  license "Apache-2.0"
  head "https://github.com/werf/trdl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d6f0d8b1a051498c3d834b62f3ec938ade7050ca86eef2df1c36ca7f68e8767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d6f0d8b1a051498c3d834b62f3ec938ade7050ca86eef2df1c36ca7f68e8767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ebceecaf1dd119d01e458892e3bd39c70f599c8e904eb6b3d6cc8e4cc309be2"
    sha256 cellar: :any,                 x86_64_linux:  "82327787248871722179a8ae69eee830c272197af719eb837cf0e767f732fa7a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "client" do
      system "go", "mod", "download"
    end
  end

  def install
    ldflags = "-X github.com/werf/trdl/client/pkg/trdl.Version=#{version}"
    cd "client" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/trdl"
    end
  end

  test do
    ENV["TRDL_DEBUG"] = "true"
    ENV["TRDL_HOME_DIR"] = testpath.to_s

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/trdl list")
    assert_match "Name", output
    assert_match "Default Channel", output
  end
end
