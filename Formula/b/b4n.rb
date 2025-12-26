class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "d6de828d01021502813952c9cd4a2a46d460b53710a9ba6560124cc6e6a45731"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56d418802b20e901093d5809abbfd8a1a8f21909f77bc6f85943c6fc63cc4d74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a333e70e499e605c5941b3cafea620b9c014ec0ab8bd7a53940dec2a78b7889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1db8aca2708e29c9e54436b17e0762a346e297b7935ba9f61e3747392238e8c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "668b3bee0305c70640ac9d7652917906c14c41737e0e80af7b947b9e2b60bab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d542929ab529910780c478d94e6448fbb207b07be46db7fbc40560f17d52f068"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
