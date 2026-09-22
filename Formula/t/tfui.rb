class Tfui < Formula
  desc "Interactive TUI for Terraform plan and apply workflows"
  homepage "https://github.com/SayYoungMan/tfui"
  url "https://github.com/SayYoungMan/tfui/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "a22df58883a0b6d3f80835acf4469f46bee86d2d8cacf66e2efef1f2d2109987"
  license "MIT"
  head "https://github.com/SayYoungMan/tfui.git", branch: "main"

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
