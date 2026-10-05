class Hulak < Formula
  desc "Lightweight file-based API client with encrypted secrets store"
  homepage "https://github.com/xaaha/hulak"
  url "https://github.com/xaaha/hulak/archive/refs/tags/v0.3.33.tar.gz"
  sha256 "082d5ab2d036238fa2a008b502a4b01bd8b23935c40c50fdcc2ed16918a4f840"
  license "MIT"
  head "https://github.com/xaaha/hulak.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9be915ae763288f3d89f139376101c0549529861a0ed116cad83b0d3e53d1f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9be915ae763288f3d89f139376101c0549529861a0ed116cad83b0d3e53d1f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "211e636c5729d82e99927a18fb0a5f2d7a3495810d5f9636a9fba8c204f6a68c"
    sha256 cellar: :any,                 x86_64_linux:  "42513c29d3ab83e43bafdf65fd55369c2cd007a2363ca1bf00a7b4bfa05bda53"
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
