class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.8.2.tar.gz"
  sha256 "6e180fe92854c9ac7b46a6d42b0bedc83f155466ecc8b428139dcb037d53e2d0"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1397929ed56e940d2341fca50d9818f54ee16907d7d992343ac260649613502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc13e4872ea74afe5eb6a0320f0f3dfa812f17446f9d81d5553888d0da4b3806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b82aefa3424536276c0cb8cab48fdebad60335fb28a7d72365094fd5ba07f149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de6e62bdee6c359d228180622434acd91f2ed80f52a28cd5e9ece242a293f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7bbb76db3bd79b18109a7e08929eabdc24d38591fadb5d8916c6bc921620655"
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
