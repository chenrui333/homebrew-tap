class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.10.0.tar.gz"
  sha256 "b72731c25d1782c18330667360a6362930f47d357269e5d99e49d6358e22ed7b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d88771a8e68ab640a4986bfd28a9a0351055a74e7bec1af42326b4f4bef3cc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c9c60d27061bfa84b9cd60d30a175394a09973eccc2c61c64ec2ab492bc26b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98aa9c4cfcd3dd9d3bd117fc59a8b90838878fe7ce9d6df2d2ff8ca5cc3733ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce9d1c3cd8d64cd769b70fb40b56a4390cc451368037b1c501dd1b1dec1d8380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72e9928fc38f85c4b5c6c723802b589bffac1160f4f3f9efe800a3e5bbc9d622"
  end

  depends_on "rust" => :build

  def install
    cd "packages/actionbook-rs" do
      # Keep binary `--version` aligned with the tagged CLI release.
      inreplace "Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
      system "cargo", "install", "--bin", "actionbook", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionbook --version")

    output = shell_output("HOME=#{testpath} #{bin}/actionbook profile list --json")
    assert_match "\"name\": \"actionbook\"", output
  end
end
