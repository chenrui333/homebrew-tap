class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.7.3.tar.gz"
  sha256 "eb8ba6df41c00819f937082e08758987aa18341e76cd62defb03ec0ce3f70433"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    cd "packages/actionbook-rs" do
      # Keep binary `--version` aligned with the tagged CLI release.
      inreplace "Cargo.toml", 'version = "0.7.1"', "version = \"#{version}\""
      system "cargo", "install", "--bin", "actionbook", *std_cargo_args(path: ".")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionbook --version")

    output = shell_output("HOME=#{testpath} #{bin}/actionbook profile list --json")
    assert_match "\"name\": \"actionbook\"", output
  end
end
