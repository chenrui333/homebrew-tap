class FlintCli < Formula
  desc "Lightweight tool for managing linux virtual machines"
  homepage "https://github.com/ccheshirecat/flint"
  url "https://github.com/ccheshirecat/flint/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "c5c472a0a1dcb7133692ca3c5058c3a38f4409ae78662a085c6c87bda975917e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34f5fdf183c902d29d7b4d43a1f16071c056e1be127f8732b2ea40fe31a904b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "495ea2e4c332da91b9ddee060d1cb68d115230f2faf3f12e4256c4d4c4da1767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfaa28e7895424ecc510a4713f48c2d70e11d561259673370eb26d4b140b1ab6"
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
