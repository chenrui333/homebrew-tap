class Tftree < Formula
  desc "Display your Terraform module call stack in your terminal"
  homepage "https://github.com/busser/tftree"
  url "https://github.com/busser/tftree/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b69f527afc4b0d6b910042941b4268202161a48122ac12e21947c9de527620f4"
  license "Apache-2.0"
  head "https://github.com/busser/tftree.git", branch: "main"

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
