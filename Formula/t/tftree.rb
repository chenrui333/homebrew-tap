class Tftree < Formula
  desc "Display your Terraform module call stack in your terminal"
  homepage "https://github.com/busser/tftree"
  url "https://github.com/busser/tftree/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b69f527afc4b0d6b910042941b4268202161a48122ac12e21947c9de527620f4"
  license "Apache-2.0"
  head "https://github.com/busser/tftree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "518e84f35d42cfb6d0f668d01e628a64bbb95340c0ffb41b4dd8852f91aa707b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38d3814f7abd5120bea3dceb4661dfa27f62833c9b95adf924b2f6102fbfbd18"
    sha256 cellar: :any_skip_relocation, ventura:       "1c34c3a315df3bc69090e669b9837ee759a6ba751c16ac5afa6edb18a150c895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "674935227c58461c4d9a5094c0ed20f30bbafdd99626b0b781b75099194057ca"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  # upstream pr ref, https://github.com/busser/tftree/pull/20
  patch do
    url "https://github.com/busser/tftree/commit/4dfa91fd22d61cb476d70e0aa8e51f409d8f5783.patch?full_index=1"
    sha256 "8212c5130521d2c8619390ddfd505fb37ca9ffd9de423c9b1bdc98f23a92c4cc"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tftree -version")

    output = shell_output("#{bin}/tftree -no-color -terraform-bin tofu #{testpath} 2>&1", 1)
    assert_match "No configuration files", output
  end
end
