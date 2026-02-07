class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "a97c2c33b1dca82e7388f59b76814bf39b1d6d6db508bb897a32aaf67b45a53a"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c42ca1cd8e847cd5267d2eb666c117a3fe4f823764509907082fe056eb089f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ef846c717013e21929a4082916917d4290c781bc24da00292e5b92363a88d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "624c8b4289735e66a94de0b934b17f1d26dc92f4809ef81926bcc4dec9d744c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b29926d08b443a430e55acafb2039f32630026eacb5b56bd38df97b437a0880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32fd0c5f6198060807519a7d548294e8845b426c72a0587d553f7fa1f80dabe1"
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
