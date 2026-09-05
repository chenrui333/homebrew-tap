class Panix < Formula
  desc "Deploy Nix configurations across machines"
  homepage "https://github.com/mihakrumpestar/panix"
  url "https://github.com/mihakrumpestar/panix/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "ca2f052d74372ecb2c8ddbc6e67183923aab42ea53a385c66aee6aa0fa3dca25"
  license "AGPL-3.0-only"
  head "https://github.com/mihakrumpestar/panix.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/panix"
    generate_completions_from_executable(bin/"panix", "completion", "--code")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/panix --version")
    output = shell_output("#{bin}/panix schema --output -")
    assert_match "Panix Configuration Schema", output
  end
end
