class FlintCli < Formula
  desc "Lightweight tool for managing linux virtual machines"
  homepage "https://github.com/ccheshirecat/flint"
  url "https://github.com/ccheshirecat/flint/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "4b302cb4d72f7978747c49fb4f400c4cf838d15674738d8e042b98dc7e43fcf9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5af96b3b59171cc23024264959f7ac273e6b36c10a49c6d8351c20b1d77f8496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6150d6ec291ed31f3148d6544766818dbb6a4dd2e5cdbdf15f9e94b529295770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60de89a8e9da788ef8da26fbd25f2cd3374c2f82b508a62f532ba4cf82385ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f770cfb892aee30655b77cc00e80d0948b7ee9f5ba7b735632caa240dd39dbc5"
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

    generate_completions_from_executable(bin/"flint", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/flint api-key")
    assert_match "Use this key in the Authorization header", output
  end
end
