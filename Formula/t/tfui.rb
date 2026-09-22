class Tfui < Formula
  desc "Interactive TUI for Terraform plan and apply workflows"
  homepage "https://github.com/SayYoungMan/tfui"
  url "https://github.com/SayYoungMan/tfui/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "a22df58883a0b6d3f80835acf4469f46bee86d2d8cacf66e2efef1f2d2109987"
  license "MIT"
  head "https://github.com/SayYoungMan/tfui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fe32824bcb592913837ea28f80d07b6681b857cad4cc9fb4b6231bcf25a8585"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe32824bcb592913837ea28f80d07b6681b857cad4cc9fb4b6231bcf25a8585"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf9da502f991f46c4d29adbf0da3c855334ac1eb6182945091ff51d84ae5004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "249c4ce04300d25765b2bdc0ecdf6372f7f2374d0aae4819ce10cec463d0408b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(output: bin/"tfui"), "./cmd/tfui"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    assert_path_exists bin/"tfui"
    output = shell_output("#{bin}/tfui --binary definitely-not-a-real-terraform-binary 2>&1", 1)
    assert_match '"definitely-not-a-real-terraform-binary" not found in PATH', output
  end
end
