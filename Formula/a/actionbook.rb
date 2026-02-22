class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.7.3.tar.gz"
  sha256 "eb8ba6df41c00819f937082e08758987aa18341e76cd62defb03ec0ce3f70433"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c55fc553735c0dcc72724c27d95eca0507f17b1e72b5e859836649da678b4cc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96f376af481a2edf74b711e0749cc3a851b43260512ec0b9880cafb04d6d28f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd33a5d16918a4a19cc569ea56d251c21335d5d13b593b0d62de4919927afcaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fd7556ec1b02d3ccf31e14cfdf0bcfdd6e610a02ea0a7da51409b0963377e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19f5a31369e487de66518c0077e839c1deb3f00c22df2be99da9a0b1d8000c9c"
  end

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
