class Hulak < Formula
  desc "Lightweight file-based API client with encrypted secrets store"
  homepage "https://github.com/xaaha/hulak"
  url "https://github.com/xaaha/hulak/archive/refs/tags/v0.4.00.tar.gz"
  sha256 "21a0dca437e0843425b7e2354ba0285d3df0d274ed8e981c8958ec8f3c0580c1"
  license "MIT"
  head "https://github.com/xaaha/hulak.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6db9a56f7c0f5c7b64a1a52f1ea34ce8f9712914136d7dc936b80a1b53475d8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6db9a56f7c0f5c7b64a1a52f1ea34ce8f9712914136d7dc936b80a1b53475d8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a427f3d0111747d911a46dd2bd598a91804e38f5870ee7415c1fd3d7950f110"
    sha256 cellar: :any,                 x86_64_linux:  "2c86bec5835823837f87c246bd34de94fc83c9da97d10fd4f02a26248065ec7e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/xaaha/hulak/pkg/userFlags.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hulak version")
    assert_match "Initialize a hulak project", shell_output("#{bin}/hulak help")

    system bin/"hulak", "init", "classic"
    assert_path_exists testpath/"env/global.env"
    assert_match "env/", (testpath/".gitignore").read
  end
end
