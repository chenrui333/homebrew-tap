class Tftree < Formula
  desc "Display your Terraform module call stack in your terminal"
  homepage "https://github.com/busser/tftree"
  url "https://github.com/busser/tftree/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b69f527afc4b0d6b910042941b4268202161a48122ac12e21947c9de527620f4"
  license "Apache-2.0"
  head "https://github.com/busser/tftree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7d10d5d9d9f4aaebff6a8ca456a27471785433a79f31aa6f9475fa0f966c5ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7d10d5d9d9f4aaebff6a8ca456a27471785433a79f31aa6f9475fa0f966c5ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e22202ba459b91221a75e7f87bea950127a4fb233c1761e5940d6c94c9a170f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "257434c008455d32987cc8fe0d5f4bea4185ecbb173c98ad997c91d59a4a8178"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  # upstream pr ref, https://github.com/busser/tftree/pull/20
  patch do
    url "https://github.com/busser/tftree/commit/4dfa91fd22d61cb476d70e0aa8e51f409d8f5783.patch?full_index=1"
    sha256 "8212c5130521d2c8619390ddfd505fb37ca9ffd9de423c9b1bdc98f23a92c4cc"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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
