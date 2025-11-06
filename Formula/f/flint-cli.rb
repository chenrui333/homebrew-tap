class FlintCli < Formula
  desc "Lightweight tool for managing linux virtual machines"
  homepage "https://github.com/ccheshirecat/flint"
  url "https://github.com/ccheshirecat/flint/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "4b302cb4d72f7978747c49fb4f400c4cf838d15674738d8e042b98dc7e43fcf9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e1cb2ae112840762952c244c60bbd70dcc2fd7b35626b5b95343d210ab77f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be8ef580236a31374040de44ac1e1ac9cd70900c3bb68d24ffa17f3b038871a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd0021b58d581454809c47eb26230dbed1848412b8cf028313242edc099aca96"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "libvirt"
  depends_on "qemu"

  def install
    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"flint")

    generate_completions_from_executable(bin/"flint", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    output = shell_output("#{bin}/flint api-key")
    assert_match "Use this key in the Authorization header", output
  end
end
