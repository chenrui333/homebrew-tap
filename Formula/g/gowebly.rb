class Gowebly < Formula
  desc "Next-generation CLI tool to easily build amazing web applications"
  homepage "https://gowebly.org/"
  url "https://github.com/gowebly/gowebly/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "f69c582180408a45c1f6a728594f39a617410d3b774be4d8236466e3ea4536e5"
  license "Apache-2.0"
  head "https://github.com/gowebly/gowebly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb42d0839893274c4dc99bfcfb35f72fb200c3518642fc7e30df255fdfef3c36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb26df1cca63df1eb8fbc806d6f473f940427a7f0de32c45b906a500192b53f8"
    sha256 cellar: :any_skip_relocation, ventura:       "f3c2dd1f8fc9a60aac9abf80a1168f48359b6fbc9a4250f976daf743628b90bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47152a1858b4a73f7b2784f1f0019e6a8e67c340ff9fc937327e9be187033262"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowebly doctor")

    output = shell_output("#{bin}/gowebly run 2>&1", 1)
    assert_match "No rule to make target", output
  end
end
